resource "vault_pki_secret_backend_role" "postgresql_server_cert_role" {
  backend = vault_mount.pki_intermediate.path
  name    = "postgresql_server_cert_request"

  ttl     = 2592000
  max_ttl = 7776000

  key_type = "ec"
  key_bits = 256

  allowed_domains    = ["ig11", "ig11.home"]
  allow_bare_domains = true
  allow_subdomains   = false
  allow_glob_domains = false
  allow_localhost    = false
  allow_ip_sans      = false
  allow_any_name     = false

  server_flag = true
  client_flag = false

  key_usage     = ["DigitalSignature"]
  ext_key_usage = ["ServerAuth"]
}