
resource "vault_pki_secret_backend_role" "cert_role" {
  backend          = vault_mount.pki_intermediate.path
  name             = "home_cert_request"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["home"]
  allow_subdomains = true
  allow_localhost  = true
}

resource "vault_pki_secret_backend_role" "nomad_cert_role" {
  backend          = vault_mount.pki_intermediate.path
  name             = "nomad_cert_request"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["global.nomad","home"]
  allow_subdomains = true
  allow_localhost  = true
}

resource "vault_pki_secret_backend_role" "consul_cert_role" { #todo: edit to only allow consul server cert role, make new consul client cert role
  backend          = vault_mount.pki_intermediate.path
  name             = "consul_cert_request"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["dc1.consul","home"]
  allow_subdomains = true
  allow_localhost  = true
  #key_usage = ["KeyUsageDigitalSignature ","KeyUsageKeyEncipherment", ]
  #key_usage - (Optional) Specify the allowed key usage constraint on issued certificates
  #https://pkg.go.dev/crypto/x509#KeyUsage

  #ext_key_usage - (Optional) Specify the allowed extended key usage constraint on issued certificates
  #https://pkg.go.dev/crypto/x509#ExtKeyUsage

  #https://valentevidal.medium.com/setting-up-a-pki-using-vault-explained-c8c9a12b882f
}

# resource "vault_pki_secret_backend_role" "test_cert_role" { #todo: edit to only allow consul server cert role, make new consul client cert role
#   backend          = vault_mount.pki_intermediate.path
#   name             = "client_cert_request"
#   ttl              = 3600
#   allow_ip_sans    = true
#   key_type         = "rsa"
#   key_bits         = 4096
#   allowed_domains  = ["dc1.consul","home"]
#   allow_subdomains = true
#   allow_localhost  = true
#   #key_usage          = tolist(["DigitalSignature","KeyAgreement"])
#   #ext_key_usage = tolist(["ClientAuth","CodeSigning"])
#   #key_usage - (Optional) Specify the allowed key usage constraint on issued certificates
#   #https://pkg.go.dev/crypto/x509#KeyUsage

#   #ext_key_usage - (Optional) Specify the allowed extended key usage constraint on issued certificates
#   #https://pkg.go.dev/crypto/x509#ExtKeyUsage

#   #https://valentevidal.medium.com/setting-up-a-pki-using-vault-explained-c8c9a12b882f
# }