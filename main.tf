#variable "github_organization" {}
#variable "github_personal_access_token" {}
#variable "gitlab_personal_access_token" {}
#variable "user_ocid" {}
#variable "fingerprint" {}
#variable "private_key_path" {}
module "gh_gl_repo_from_clone" {
  source                       = "./modules/gh_gl_repo_from_clone"
# github_organization          = var.github_organization 
  github_personal_access_token = var.github_personal_access_token
  gitlab_personal_access_token = var.gitlab_personal_access_token
}
#output "oci_ampere_a1_private_ips" {
#  value     = module.oci-ampere-a1.ampere_a1_private_ips
#}
#output "oci_ampere_a1_public_ips" {
#  value     = module.oci-ampere-a1.ampere_a1_public_ips
#}
