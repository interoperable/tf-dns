# 
# Cloudflare Variables
#
variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}
variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}
variable "cloudflare_zone_name" {
  description = "Name of the Cloudflare DNS Zone"
  type        = string
}
variable "cloudflare_email" {
  description = "The email adress used for your Cloudflare account"
  type        = string
}
variable "cloudflare_global_api_key" {
  description = "Cloudflare Global API Key"
  type        = string
}
variable "cloudflare_origin_ca_key" {
  description = "Cloudflare Origin CA Key"
  type        = string
}
variable "cloudflare_zone_dns_api_token" {
  description = "Cloudflare Zone DNS API token"
  type        = string
}
#
# Github Variables
#
variable "github_personal_access_token" {
  description = "Github Personal Access Token"
  type        = string
}
#
# GitLab Variables
#
variable "gitlab_personal_access_token" {
  description = "GitLab Personal Access Token"
  type        = string
}
#variable "feed_token" {
#  description = "The RSS feed token"
#}
#variable "incoming_email_token"  {
#  description = "The incoming email token"
#}
variable "projects" {
  description = "A list of projects you want automatically created"
  default = []
}
