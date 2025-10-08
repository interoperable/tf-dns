terraform {
  required_providers {
    docker = {
      source  = "docker/docker"
      version = "~> 0.2"
    }
  }
}
 
# Initialize provider
provider "docker" {}

varable "docker_namespace" {}
varable "docker_repo" {}
varable "docker_org" {}
varable "docker_team" {}
varable "docker_team_users" {}
varable "docker_peronsal_access_token" {}
 
# Define local variables for customization
locals {
  namespace        = "var.docker_namespace"
  repo_name        = "var.docker_repo"
  org_name         = "var.docker_org"
  team_name        = "var.docker_team"
  team_users        = "var.docker_team_team_users"
  token_label      = "var.docker_personal_access_token"
  token_scopes     = ["repo:read", "repo:write"]
  permission       = "admin"
}
 
# Create repository
resource "docker_hub_repository" "org_hub_repo" {
  namespace        = local.namespace
  name             = local.repo_name
  description      = "This is a generic Docker repository."
  full_description = "Full description for the repository."
}
 
# Create team
resource "docker_org_team" "team" {
  org_name         = local.org_name
  team_name        = local.team_name
  team_description = "Team description goes here."
}
 
# Team association
resource "docker_org_team_member" "team_membership" {
  for_each = toset(local.my_team_users)
 
  org_name  = local.org_name
  team_name = docker_org_team.team.team_name
  user_name = each.value
}
 
# Create repository team permission
resource "docker_hub_repository_team_permission" "repo_permission" {
  repo_id    = docker_hub_repository.org_hub_repo.id
  team_id    = docker_org_team.team.id
  permission = local.permission
}
 
# Create access token
resource "docker_access_token" "access_token" {
  token_label = local.token_label
  scopes      = local.token_scopes
}
