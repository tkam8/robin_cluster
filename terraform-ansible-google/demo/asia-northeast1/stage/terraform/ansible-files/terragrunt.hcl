# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------


# Use below code as backup to dependency block as last resort
// data "terraform_remote_state" "vpc" {
//     backend = "gcs"
//   config = {
//     bucket         = "tky-drone-demo-stage"
//     prefix         = "terraform/state"
//     region         = "asia-northeast1"
//   }
// }

terraform {
  source = "github.com/tkam8/robin_cis_modules//ansible_files?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../terragrunt.hcl"
}

dependency "bigip1" {
  config_path = "../functions/bigip_ecmp"

  mock_outputs = {
    f5_public_ip        = "2.2.2.3"
    f5_private_ip       = "2.2.2.4"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  skip_outputs = true
}

dependency "robin1" {
  config_path = "../functions/robin_master1"

  mock_outputs = {
    centos_public_ip     = "3.3.3.1"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  #skip_outputs = true
}

dependency "robin2" {
  config_path = "../functions/robin_worker1"

  mock_outputs = {
    centos_public_ip     = "3.3.3.2"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  #skip_outputs = true
}

dependency "robin3" {
  config_path = "../functions/robin_worker2"

  mock_outputs = {
    centos_public_ip     = "3.3.3.3"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  #skip_outputs = true
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  terragrunt_path                 = "${get_terragrunt_dir()}"
  app_tag_value                   = "terryrobincluster"
  robin1_endpoint                 = dependency.robin1.outputs.centos_public_ip
  robin2_endpoint                 = dependency.robin2.outputs.centos_public_ip
  robin3_endpoint                 = dependency.robin3.outputs.centos_public_ip
  // cluster1_username            = dependency.gke1.outputs.cluster_username
  // cluster2_username            = dependency.gke2.outputs.cluster_username
  // cluster3_username            = dependency.gke3.outputs.cluster_username
  // cluster1_password            = dependency.gke1.outputs.cluster_password
  // cluster2_password            = dependency.gke2.outputs.cluster_password
  // cluster3_password            = dependency.gke3.outputs.cluster_password
  bigip1_public_ip                = dependency.bigip1.outputs.f5_public_ip
  bigip1_private_ip               = dependency.bigip1.outputs.f5_private_ip
}
