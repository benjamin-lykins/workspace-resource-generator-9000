terraform {
  cloud {
    hostname = "tfe-failover.benjamin-lykins.sbx.hashidemos.io"
    organization = "failover"
    workspaces {
      name = "demo-workspace-tfe"
    }
  }

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "random" {}


variable "resource_count" {
  type    = number
  default = 7

}

resource "random_pet" "this" {
  count = var.resource_count

}