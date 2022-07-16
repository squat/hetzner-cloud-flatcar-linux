terraform {
  required_version = ">= 0.13"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.23, < 2"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.7.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}
