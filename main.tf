terraform {
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
}

variable "tfe_hostname" {
  description = "The hostname of the Terraform Enterprise instance"
  type        = string
}

variable "tfe_organization" {
  description = "The organization to create the workspaces in."
  type        = string
}

variable "upstream_workspaces" {
  description = "The number of upstream to create."
  type        = number
  default     = 5
}

variable "downstream_workspaces" {
  description = "The number of workspaces to create."
  type        = number
  default     = 5
}

module "upstream" {
  source = "github.com/benjamin-lykins/terraform-tfe-workspacer.git"

  count = var.upstream_workspaces

  workspace_name    = "upstream-${count.index}"
  organization      = var.tfe_organization
  working_directory = "./workspace-random"
  auto_apply        = true

  tfvars = {
    resource_count = 6
  }

  vcs_repo = {
    identifier     = "benjamin-lykins/workspace-resource-generator-9000"
    branch         = "main"
    oauth_token_id = "ot-hcFMM5ZhpaNrj4TH"
  }
}

module "downstream" {
  source = "github.com/benjamin-lykins/terraform-tfe-workspacer.git"
  
  count             = var.downstream_workspaces

  workspace_name    = "downstream-${count.index}"
  organization      = var.tfe_organization
  working_directory = "./workspace-random"
  auto_apply        = true

  run_trigger_source_workspaces = tolist([for i in module.upstream : i.workspace_name])
  run_trigger_auto_apply        = true

  tfvars = {
    resource_count = 6
  }

  vcs_repo = {
    identifier     = "benjamin-lykins/workspace-resource-generator-9000"
    branch         = "main"
    oauth_token_id = "ot-hcFMM5ZhpaNrj4TH"
  }
  
  depends_on = [ module.upstream ]
}

output "upstream_workspace_names" {
  value = [for i in module.upstream : i.workspace_name]
}

output "downstream_workspace_names" {
  value = [for i in module.downstream : i.workspace_name]
}