terraform {
  required_version = ">= 1.2.9"

  required_providers {
    vault = ">= 3.8.2"
  }
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}
