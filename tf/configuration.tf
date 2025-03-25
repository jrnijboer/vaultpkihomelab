terraform {
  required_version = ">=1.9.5"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.5.0"
    }
  }
  backend "azurerm" {
    # project-wide settings
    key                  = "vaultpkihomelab"
    storage_account_name = "nijboerhomelabsa"
    resource_group_name  = "home-rg"
    subscription_id      = "6ef9ed97-0307-44d1-a389-abc57c45de2d"
    container_name       = "tfstate"
    tenant_id            = "f1c48361-ecf4-42f7-8179-35b6c5836975"
    use_azuread_auth     = true
    client_id            = "280d3758-d450-449d-8919-09cde5ee1ab3"
    client_secret        = "" # in vault: /v1/secrets/data/projects/vaultpkihomelab
  }
}

provider "vault" {
  address         = var.vault_address
  token           = var.vault_token
  skip_tls_verify = true
}
