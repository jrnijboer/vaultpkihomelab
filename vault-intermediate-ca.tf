resource "vault_mount" "pki_intermediate" {
  path        = "pki-intermediate"
  type        = "pki"
  description = "Intermediate ca for homelab"

  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds = 2592000 # 30d
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate_csr" {
  depends_on  = [vault_mount.pki_intermediate, vault_pki_secret_backend_root_cert.root_cert]
  backend     = vault_mount.pki_intermediate.path
  type        = "internal"
  common_name = "nijboer.home Intermediate Authority"
  #   organization = "nijboer homelab"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "root_signed_intermediate" {
  depends_on           = [vault_pki_secret_backend_intermediate_cert_request.intermediate_csr]
  backend              = vault_mount.pki_root.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.intermediate_csr.csr
  common_name          = "nijboer.home Intermediate Authority"
  exclude_cn_from_sans = true
  ou                   = "homelab"
  organization         = "nijboer homelab"
  ttl                  = "157680000" # 5y
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate_signed_cert" {
  backend     = vault_mount.pki_intermediate.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.root_signed_intermediate.certificate
}
