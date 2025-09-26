# mx-gsuite.tf

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
# Uses GSuite TXT Record for Verification and adds Googles MX Servers and Zone MX Records

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
