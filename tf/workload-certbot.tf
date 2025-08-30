resource "vault_jwt_auth_backend_role" "certbot-workload" {
  backend                 = vault_jwt_auth_backend.jwt-nomad.path
  role_name               = "certbot-workload"
  role_type               = "jwt"
  bound_audiences         = ["vault.io"]
  bound_claims            = {
    nomad_namespace = "default"
    nomad_job_id    = "mijnhost-certbot"
  }
  user_claim              = "/nomad_job_id"
  user_claim_json_pointer = true

  claim_mappings = {
    nomad_namespace = "nomad_namespace"
    nomad_job_id    = "nomad_job_id"
    nomad_task      = "nomad_task"
  }

  token_type             = "service"
  token_policies         = ["mijnhost-certbot-policy"]
  token_period           = 1800
  token_explicit_max_ttl = 0
}

resource "vault_policy" "mijnhost-certbot-policy" {
  name   = "mijnhost-certbot-policy"
  policy = <<EOT
# path "auth/token/*" {
#   capabilities = ["create", "read", "update", "delete", "list"]
# }

path "secrets/data/certificates/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOT
}
