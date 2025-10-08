# Create Managed Repo Infra with Webhooks and Deploy Keys

# Create Keypair
resource "tls_private_key" "deploy-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "Deploy_Key_Public_Key" {
  value = "${tls_private_key.deploy-key.public_key_openssh}"
}

resource "local_file" "deploy-key-rsa-pub" {
  content = "${tls_private_key.deploy-key.public_key_openssh}"
  filename = "${path.module}/deploy-key-rsa.pub"
}

output "Deploy_Key_Private_Key" {
  value = "${tls_private_key.deploy-key.private_key_pem}"
}

resource "local_file" "deploy-key-rsa" {
  content = "${tls_private_key.deploy-key.private_key_pem}"
  filename = "${path.module}/deploy-key-rsa"
}


# Repo Scaffolding
resource "github_repository" "project-repository" {
  name         = "${var.target_repository_name}"
  visibility   = "private"
  has_issues   = true
  has_projects = true
  has_wiki     = true
  auto_init    = false
}
output "Github_Project_SSH_Url" {
  value = "${github_repository.project-repository.ssh_clone_url}"
}

resource "gitlab_project" "project-repository" {
  name         = "${var.target_repository_name}"
  issues_enabled         = "true" 
  merge_requests_enabled = "true" 
  wiki_enabled           = "true" 
  snippets_enabled       = "true" 
  visibility_level       = "private"
}

output "Gitlab_Project_SSH_Url" {
  value = "${gitlab_project.project-repository.ssh_url_to_repo}"
}

# Add a deploy key to repository
resource "github_repository_deploy_key" "repository_deploy_key" {
  title = "project-repository-deploy-key"
  repository = "${var.target_repository_name}"
  key = "${tls_private_key.deploy-key.public_key_openssh}"
  read_only = "false"
  depends_on = [
    github_repository.project-repository,
  ]
}
resource "gitlab_deploy_key" "repository_deploy_key" {
  title = "project-repository-deploy-key"
  project = "${gitlab_project.project-repository.id}"
  key = "${tls_private_key.deploy-key.public_key_openssh}"
  can_push = "true"
  depends_on = [
    gitlab_project.project-repository,
  ]
}

resource "null_resource" "source-repo-to-targets" {
  provisioner "local-exec" {
    command = "sh clone_gh_repo_to_gh_and_gl.sh ${var.source_repository} ${github_repository.project-repository.ssh_clone_url} ${gitlab_project.project-repository.ssh_url_to_repo}"
  }
  depends_on = [
    gitlab_project.project-repository,
    github_repository.project-repository,
  ]
}
