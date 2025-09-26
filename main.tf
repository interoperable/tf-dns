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
## Add A records for  GitHub Pages to Host the APEX Domain
resource "cloudflare_record" "gh_pages_http_servers" {
  count = "${length(var.gh_pages_http_servers) * var.gh_pages_apex_domain_enable}"
  domain = "${var.domain_name}"
  name = "@"
  value = "${var.gh_pages_http_servers[count.index]}"
  type  = "A"
  ttl = 3600
}data "github_ip_ranges" "default" {
}

output "github_ip_ranges-hooks_ipv4" {
  value = data.github_ip_ranges.default.hooks_ipv4
}
output "github_webhook_cidr" {
  value = local.github_pages_cidr
}
