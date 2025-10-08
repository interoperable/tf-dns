# providers.tf
terraform {
  required_providers {
    tls =  {
      source = "hashicorp/tls"
      version = "~>4.1.0"
    }
    local =  {
      source = "hashicorp/local"
      version = "~>2.5.3"
    }
    gitlab =  {
      source = "gitlabhq/gitlab"
      version = "~>18.4.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }
  }
}



# GitHub Provider
provider "github" {
  # Github Personal Access Token
  token = var.github_personal_access_token
  # Github Owner
  #owner = var.github_organization
}
provider "gitlab" {
  token = var.gitlab_personal_access_token
  base_url = "https://gitlab.com"
}
