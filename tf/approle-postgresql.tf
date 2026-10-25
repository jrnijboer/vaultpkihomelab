resource "vault_policy" "policy_postgresql" {
  name   = "policy-postgresql"
  policy = <<EOT
path "${vault_mount.pki_intermediate.path}/issue/${vault_pki_secret_backend_role.postgresql_server_cert_role.name}" {
  capabilities = ["update"]
}
EOT
}

resource "vault_approle_auth_backend_role" "approle_postgresql" {
  backend        = vault_auth_backend.approle.path
  role_name      = "postgresql"
  token_policies = [vault_policy.policy_postgresql.name]
}

resource "vault_approle_auth_backend_role_secret_id" "approle_postgresql_secret" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.approle_postgresql.role_name
}

output "role_id_approle_postgresql" {
  description = "The role ID of the PostgreSQL Vault Agent AppRole"
  value       = vault_approle_auth_backend_role.approle_postgresql.role_id
}

resource "vault_kv_secret_v2" "postgresql_approle_secret" {
  mount               = vault_mount.secrets_approles.path
  name                = vault_approle_auth_backend_role.approle_postgresql.role_name
  delete_all_versions = true
  data_json = jsonencode(
    {
      role_id   = vault_approle_auth_backend_role.approle_postgresql.role_id,
      secret_id = vault_approle_auth_backend_role_secret_id.approle_postgresql_secret.secret_id
    }
  )

  custom_metadata {
    data = {
      Source      = "https://github.com/jrnijboer/vaultpkihomelab/blob/master/tf/approle-postgresql.tf"
      Description = "AppRole login for the PostgreSQL Vault Agent"
      Policies    = join(",", vault_approle_auth_backend_role.approle_postgresql.token_policies)
    }
  }
}