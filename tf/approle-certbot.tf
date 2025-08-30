resource "vault_approle_auth_backend_role" "approle_certbot" {
  backend        = vault_auth_backend.approle.path
  role_name      = "certbot"
  token_policies = ["policy-certbot"]
}

resource "vault_approle_auth_backend_role_secret_id" "approle_certbot_secret" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.approle_certbot.role_name
}

resource "vault_policy" "policy_certbot" {
  name   = "policy-certbot"
  policy = <<EOT
path "secrets/data/certificates/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOT
}

output "role_id_approle_approle_certbot" {
  description = "The role ID of the certbot approle"
  value       = vault_approle_auth_backend_role.approle_certbot.role_id
}

resource "vault_kv_secret_v2" "approle_certbot_secret" {
  mount               = vault_mount.secrets_approles.path
  name                = vault_approle_auth_backend_role.approle_certbot.role_name
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      role_id   = vault_approle_auth_backend_role.approle_certbot.role_id,
      secret_id = vault_approle_auth_backend_role_secret_id.approle_certbot_secret.secret_id
    }
  )
  custom_metadata {
    data = {
      Source      = "https://github.com/jrnijboer/vaultpkihomelab/blob/master/tf/approle-certbot.tf"
      Description = "AppRole login for certbot"
      Policies    = join(",", [for s in vault_approle_auth_backend_role.approle_certbot.token_policies : s])
    }
  }
}
