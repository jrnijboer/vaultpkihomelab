resource "vault_mount" "secrets_approles" {
  path        = "secrets-approles"
  type        = "kv-v2"
  description = "This is the KV Version 2 secret engine mount for approle secrets and id's"
}

resource "vault_mount" "secrets" {
  path        = "secrets"
  type        = "kv-v2"
  description = "This is the KV Version 2 secret engine mount for secrets"
}
