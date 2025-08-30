resource "vault_jwt_auth_backend" "jwt-nomad" {
  type               = "jwt"
  path               = "jwt-nomad"
  description        = "JWT auth backend for Nomad"
  jwks_url           = "http://192.168.179.100:8888/.well-known/jwks.json"
  jwt_supported_algs = ["RS256", "EdDSA"]
  default_role       = "nomad-workloads"
}

resource "vault_jwt_auth_backend_role" "nomad-workloads" {
  backend                 = vault_jwt_auth_backend.jwt-nomad.path
  role_name               = "nomad-workloads"
  role_type               = "jwt"
  bound_audiences         = ["vault.io"]
  user_claim              = "/nomad_job_id"
  user_claim_json_pointer = true

  claim_mappings = {
    nomad_namespace = "nomad_namespace"
    nomad_job_id    = "nomad_job_id"
    nomad_task      = "nomad_task"
  }

  token_type             = "service"
  token_policies         = ["nomad-workloads-policy"]
  token_period           = 1800
  token_explicit_max_ttl = 0
}

resource "vault_policy" "nomad-workloads-policy" {
  name   = "nomad-workloads-policy"
  policy = <<EOT
path "secrets/data/{{identity.entity.aliases.AUTH_METHOD_ACCESSOR.metadata.nomad_namespace}}/{{identity.entity.aliases.AUTH_METHOD_ACCESSOR.metadata.nomad_job_id}}/*" {
  capabilities = ["read"]
}

path "secrets/data/{{identity.entity.aliases.AUTH_METHOD_ACCESSOR.metadata.nomad_namespace}}/{{identity.entity.aliases.AUTH_METHOD_ACCESSOR.metadata.nomad_job_id}}" {
  capabilities = ["read"]
}

path "secrets/metadata/{{identity.entity.aliases.AUTH_METHOD_ACCESSOR.metadata.nomad_namespace}}/*" {
  capabilities = ["list"]
}

path "secrets/metadata/*" {
  capabilities = ["list"]
}
path "secrets/data/*" {
  capabilities = ["list", "read"]
}
EOT
}
