resource "hcloud_ssh_key" "first" {
  name       = var.name
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_server" "server" {
  name     = var.name
  ssh_keys = [hcloud_ssh_key.first.id]
  # boot into rescue OS
  rescue = "linux64"
  # dummy value for the OS because Flatcar is not available
  image       = "debian-11"
  server_type = var.server_type
  datacenter  = var.datacenter
  connection {
    private_key = tls_private_key.ssh.private_key_pem
    host        = self.ipv4_address
    timeout     = "1m"
  }
  provisioner "file" {
    content     = data.ct_config.ignition.rendered
    destination = "/root/ignition.json"
  }

  provisioner "remote-exec" {
    inline = [
      "set -ex",
      "apt-get update",
      "apt-get install gawk -y",
      "curl -fsSLO --retry-delay 1 --retry 60 --retry-connrefused --retry-max-time 60 --connect-timeout 20 https://raw.githubusercontent.com/kinvolk/init/flatcar-master/bin/flatcar-install",
      "chmod +x flatcar-install",
      "./flatcar-install -s -i /root/ignition.json -C ${var.os_image}",
      "shutdown -r +1",
    ]
  }

  provisioner "remote-exec" {
    connection {
      private_key = tls_private_key.ssh.private_key_pem
      host        = self.ipv4_address
      timeout     = "3m"
      user        = "core"
    }

    inline = [
      "sudo hostnamectl set-hostname ${self.name}",
    ]
  }
}

data "ct_config" "ignition" {
  content  = data.template_file.config.rendered
  strict   = true
  snippets = var.snippets
}

data "template_file" "config" {
  template = file("${path.module}/config.yaml.tmpl")

  vars = {
    ssh_keys = jsonencode(concat(var.ssh_keys, [tls_private_key.ssh.public_key_openssh]))
  }
}
