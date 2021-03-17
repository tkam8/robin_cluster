# -------------------------
# Create Peering for the two networks
# -------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/tkam8/robin_cis_modules//gcp_vpc_network?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../terragrunt.hcl"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    network                  = "networkName"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  #skip_outputs = true
}

dependency "vpc2" {
  config_path = "../vpc2"

  mock_outputs = {
    network                  = "networkName"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  #skip_outputs = true
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix           = "robin-cluster1"
  project               = "f5-gcs-4261-sales-apcj-japan"
  region                = "asia-northeast1"
  local_network         = dependency.vpc.outputs.network
  peer_network          = dependency.vpc2.outputs.network
}