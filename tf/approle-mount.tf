resource "vault_auth_backend" "approle" {
  type = "approle"

  tune {
    max_lease_ttl     = "3456000s" # 40 days
    default_lease_ttl = "86400s"   # 1 day
  }
}
