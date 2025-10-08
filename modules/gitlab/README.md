# terraform-gitlab-mgmt

## Description 

Terraform to manage a Gitlab.com Account and Projects.

## Files

* [main.tf](main.tf)
* [provider.tf](provider.tf)
* [variables.tf](variables.tf)


## terraform.tfvars

```
gitlab_personal_access_token = "1234567890abcdefghij"
gitlab_feed_token = "1234567890abcdefghij"
gitlab_incoming_email_token = "987654321abcdefghijklmnop"
gitlab_projects = ["test0","test1","test2","test4"] 
```
