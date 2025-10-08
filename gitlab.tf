# Gitlab Data
data "gitlab_current_user" "example" {}
data "gitlab_groups" "example" {
  sort     = "desc"
  order_by = "name"
}
data "gitlab_groups" "example-two" {
  search = "GitLab"
}
#data "gitlab_instance_deploy_keys" "example_private" {}
# only public deploy keys
#data "gitlab_instance_deploy_keys" "example_public" {
#  public = true
#}

# Lookup by user ID
data "gitlab_user_sshkeys" "example_by_id" {
  user_id = data.gitlab_current_user.example.id
}

# Lookup by username
data "gitlab_user_sshkeys" "example_by_username" {
  username = data.gitlab_current_user.example.username
}
