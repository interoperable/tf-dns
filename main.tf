# main.tf

locals {
  zones = flatten(data.cloudflare_zones.default[*].result[*].name)
  zone_ids = flatten(data.cloudflare_zones.default[*].result[*].id)
  zone_count = length(local.zones)
  id_count = length(local.zone_ids)
  root_path = path.root
  github_pages_cidr = join(", ", data.github_ip_ranges.default.hooks_ipv4)
  application_fqdn = "${var.tunnel_name}.${var.cloudflare_zone_name}"
  application_fqdn_with_quotes = jsonencode(local.application_fqdn)
  github_firewall_rule = "not ip.src in {${local.github_webhook_cidr}} and http.host eq ${local.application_fqdn_with_quotes}"
}
data "github_ip_ranges" "default" {
}

output "github_ip_ranges-hooks_ipv4" {
  value = data.github_ip_ranges.default.hooks_ipv4
}
output "github_webhook_cidr" {
  value = local.github_pages_cidr
}

resource "cloudflare_record" "www_gh-pages" {
  count = "${var.gh_pages_apex_domain_enable}"
  domain = "${var.domain_name}"
  name = "www"
  value = "${var.domain_name}"
  type  = "CNAME"
  ttl = 3600
  depends_on = [ cloudflare_record.gh_pages_http_servers ]
}

## Add A records for  GitHub Pages to Host the APEX Domain
resource "cloudflare_record" "gh_pages_http_servers" {
  count = "${length(var.gh_pages_http_servers) * var.gh_pages_apex_domain_enable}"
  domain = "${var.domain_name}"
  name = "@"
  value = "${var.gh_pages_http_servers[count.index]}"
  type  = "A"
  ttl = 3600
}

# ssh keys
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "default-ssh-privkey" {
    content = tls_private_key.default.private_key_pem
    filename = "${path.cwd}/default-id_rsa"
    file_permission = "0600"
}

resource "local_file" "default-ssh-pubkey" {
    content  = tls_private_key.default.public_key_openssh
    filename = "${path.cwd}/default-id_rsa.pub"
    file_permission = "0644"
}

# Output: The dynamically created openssh public key
output "default_ssh_public_key" {
  value = tls_private_key.default.public_key_openssh
  sensitive = false
}

# Output: The dynamically created openssh private key
output "default_ssh_private_key" {
  value = tls_private_key.default.private_key_pem
  sensitive = true
}

resource "random_uuid" "random_id" { }

# Output: A randomly generated uuid
output "random_uuid" {
  value = random_uuid.random_id.result
  sensitive = false
}
