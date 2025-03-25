resource "vault_mount" "pki_root" {
  path        = "pki-root"
  type        = "pki"
  description = "Root ca for homelab"

  default_lease_ttl_seconds = 86400     # 24h
  max_lease_ttl_seconds     = 315360000 # 10y
}

resource "vault_pki_secret_backend_root_cert" "root_cert" {
  depends_on         = [vault_mount.pki_root]
  backend            = vault_mount.pki_root.path
  type               = "internal"
  common_name        = "nijboer.home Root CA"
  ttl                = "915360000" # 30 years
  format             = "pem"
  private_key_format = "der" # pragma: allowlist secret
  # key_type           = "rsa"
  # key_bits           = 4096
  key_type             = "ec"
  key_bits             = 256
  exclude_cn_from_sans = true
  ou                   = "homelab"
  organization         = "nijboer homelab"
}
