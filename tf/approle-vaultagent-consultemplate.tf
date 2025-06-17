resource "vault_approle_auth_backend_role" "approle_vaultagent_consultemplate" {
  backend        = vault_auth_backend.approle.path
  role_name      = "vaultagent-consultemplate"
  token_policies = ["policy-vaultagent-consultemplate"]
}

resource "vault_approle_auth_backend_role_secret_id" "approle_vaultagent_consultemplate_secret" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.approle_vaultagent_consultemplate.role_name
}

resource "vault_policy" "policy_vaultagent_consultemplate" {
  name   = "policy-vaultagent-consultemplate"
  policy = <<EOT
path "pki-intermediate/issue/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOT
}

output "role_id_approle_consulcontent" {
  description = "The role ID of consulcontent approle"
  value       = vault_approle_auth_backend_role.approle_vaultagent_consultemplate.role_id
}

resource "vault_kv_secret_v2" "consulcontent_secret" {
  mount               = vault_mount.secrets_approles.path
  name                = vault_approle_auth_backend_role.approle_vaultagent_consultemplate.role_name
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      role_id   = vault_approle_auth_backend_role.approle_vaultagent_consultemplate.role_id,
      secret_id = vault_approle_auth_backend_role_secret_id.approle_vaultagent_consultemplate_secret.secret_id
    }
  )
  custom_metadata {
    data = {
      Source      = "Terraform: magister.vault.content"
      Description = "AppRole login for consulcontent"
      Policies    = join(",", [for s in vault_approle_auth_backend_role.approle_vaultagent_consultemplate.token_policies : s])
    }
  }
}
