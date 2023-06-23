variable "vault_address" {
  type        = string
  description = "Address to the Hashicorp Vault API"
}

variable "vault_token" {
  type        = string
  description = "Token to access the Hashicorp Vault API"
  sensitive   = true
}
# token should have following policy
# Enable secrets engine
# path "sys/mounts/*" {
#   capabilities = [ "create", "read", "update", "delete", "list" ]
# }

# # List enabled secrets engine
# path "sys/mounts" {
#   capabilities = [ "read", "list" ]
# }

# # Work with pki secrets engine
# path "pki*" {
#   capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
# }

# Allow tokens to look up their own properties
# path "auth/token/create" {
#     capabilities = ["read","update"]
# }