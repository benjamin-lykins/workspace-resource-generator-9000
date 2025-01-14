terraform {
    cloud {
        hostname = "tfe.benjamin-lykins.sbx.hashidemos.io"
        organization = "testingorg"
        workspaces {
            name = "workspace-resource-generator-9000"
        }
    }
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.0"
    }
  }
}


provider "tfe" {
  hostname     = var.tfe_hostname
  organization = var.tfe_organization
  token        = var.tfe_token
}

variable "tfe_hostname" {
  description = "The hostname of the Terraform Enterprise instance"
  type        = string
}

variable "tfe_organization" {
  description = "The organization to create the workspaces in."
  type        = string
}

variable "tfe_token" {
    description = "The token to authenticate with the Terraform Enterprise instance."
    type        = string
    sensitive = true  
}

variable "workspace_count" {
  description = "The number of workspaces to create."
  type        = number
  default     = 0
}

module "workspacer" {
  source = "github.com/benjamin-lykins/terraform-tfe-workspacer.git"


  count             = var.workspace_count
  workspace_name    = "workspace-${count.index}"
  organization      = var.tfe_organization
  working_directory = "./workspace-random"
  auto_apply        = true
  allow_destroy     = true

  run_trigger_source_workspaces = ["workspace-resource-generator-9000"]
  run_trigger_auto_apply        = true

  tfvars = {
    resource_count = 6
  }

  vcs_repo = {
    identifier     = "benjamin-lykins/workspace-resource-generator-9000"
    branch         = "main"
    oauth_token_id = "ot-hcFMM5ZhpaNrj4TH"
  }
}

