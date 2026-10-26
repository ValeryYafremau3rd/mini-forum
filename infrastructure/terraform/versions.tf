
terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "v_test_org"

    workspaces {
      name = "mini-forum-dev"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "cloudflare" {}
