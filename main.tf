terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.0"
    }
  }
}


provider "tfe" {
  hostname = var.tfe_hostname
}

variable "tfe_hostname" {
  description = "The hostname of the Terraform Enterprise instance"
  type        = string
}

variable "tfe_organization" {
  description = "The organization to create the workspaces in."
  type        = string
}

variable "workspace_count" {
  description = "The number of workspaces to create."
  type        = number
  default     = 5
}

module "workspacer" {
  source  = "alexbasista/workspacer/tfe"
  version = "~> 0.0"

  count             = var.workspace_count
  workspace_name    = "workspace-${count.index}"
  organization      = var.tfe_organization
  working_directory = "./workspace-random"
  auto_apply        = true

  tfvars = {
    resource_count = 8
  }

  vcs_repo = {
    identifier     = "benjamin-lykins/workspace-resource-generator-9000"
    branch         = "main"
    oauth_token_id = "ot-hcFMM5ZhpaNrj4TH"
  }
}

