terraform {
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
  default = 5

}

resource "random_pet" "this" {
  count = var.resource_count

}
