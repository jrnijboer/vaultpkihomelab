# Notes

create new certs: vault write pki-intermediate/issue/home_cert_request/ common_name="consul.home" ttl="30d" ip_sans="127.0.0.1" sans="nomad.home"
openssl pkcs12 -export -out nomad-home.pfx -inkey cert.key -in cert.pem
