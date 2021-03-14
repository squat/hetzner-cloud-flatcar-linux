variable "os_image" {
  type        = string
  description = "Channel for a Container Linux derivative (stable, beta, alpha)"
  default     = "stable"

  validation {
    condition     = contains(["stable", "beta", "alpha"], var.os_image)
    error_message = "The os_image must be stable, beta, or alpha."
  }
}

variable "snippets" {
  type        = list(string)
  description = "Container Linux Config snippets"
  default     = []
  sensitive   = true
}

variable "name" {
  type        = string
  description = "The name to give the server"
}

variable "ssh_keys" {
  type        = list(string)
  description = "SSH public keys for user 'core' and to register on Hetzner Cloud"
}

variable "server_type" {
  type        = string
  default     = "cx11"
  description = "The server type to rent"
}

variable "datacenter" {
  type        = string
  description = "The region to deploy in"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels that should be applied to the server"
}
