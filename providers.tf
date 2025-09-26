# providers.tf
terraform {
  required_providers {
    tls =  {
      source = "hashicorp/tls"
      version = "~>4.1.0"
    }
    tls =  {
      source = "hashicorp/local"
      version = "~>2.5.3"
    }
  }
}

