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

# Output: A randomly generated uuid
output "random_uuid" {# Uses GSuite TXT Record for Verification and adds Googles MX Servers and Zone MX Records

# TXT Record for GMail Verification
resource "cloudflare_dns_record" "google_site_verification" {
  count  = "${var.gmail_mx_enable}"
  domain = "${var.domain_name}"
  name   = "@"
  value = "${var.google_site_verification_token}"
  type   = "TXT"
  ttl    = 3600
}

# MX record for Zone
resource "cloudflare_dns_record" "google_mx" {
  count = "${length(var.gmail_mx_servers) * var.gmail_mx_enable}"
  domain = "${var.domain_name}"
  name = "mail"
  value = "${var.gmail_mx_servers[count.index]}"
  priority = "${count.index + 1}"
  type = "MX"
  ttl = 3600
  depends_on = [ "cloudflare_dns_record.google_site_verification" ]
}

# Add CNAME Records for GSuite Services
resource "cloudflare_dns_record" "gsuite_aliases" {
  count = "${length(var.gsuite_aliases) * var.gmail_mx_enable}"
  domain = "${var.domain_name}"
  name = "${var.gsuite_aliases[count.index]}"
  value = "ghs.google.com"
  type  = "CNAME"
  ttl = 3600
  depends_on = [
    "cloudflare_dns_record.google_site_verification",
    "cloudflare_dns_record.google_mx",
  ]
}  value = random_uuid.random_id.result
  sensitive = false
}
