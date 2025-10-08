# Terraform Variables

# Github Organization
#variable "github_organization" {
#  description = "Name of the GitHub organization"
#}

# Github Personal Access Token
variable "github_personal_access_token" {
  description = "Github Personal Access Token"
}

# Gitlab Variables
variable "gitlab_personal_access_token" {
  description  =  "Your Gitlab personal acces token"
}
#variable "gitlab_feed_token" {
#  description = "The RSS feed token"
#}
#variable "gitlab_incoming_email_token"  {
#  description = "The incoming email token"
#}

variable "target_repository_name"  {
  description = "The name of the target repositories"
  default = "puppet-maas"
}

variable "source_repository"  {
  description = "The name of the target repository you wish to clone"
  # default = "https://github.com/puppetlabs/control-repo"
  default = "https://github.com/ppouliot/puppet-maas"
}
