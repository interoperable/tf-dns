# Gitlab Projects
resource "gitlab_project" "interop" {
  count       = "${length(var.projects)}"
  name        = "${var.projects[count.index]}"
  description = "Project: ${var.projects[count.index]}"
  visibility_level = "public"
}
