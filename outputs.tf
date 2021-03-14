output "ip" {
  value = {
    ipv4 = hcloud_server.server.ipv4_address
    ipv6 = hcloud_server.server.ipv6_address
  }
}

output "id" {
  value = hcloud_server.server.id
}

output "name" {
  value = hcloud_server.server.name
}
