
# -------------------------
# Attach Firewall Rules to allow inbound traffic to tagged instances
# -------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/tkam8/robin_cis_modules//gcp_network_firewall?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../terragrunt.hcl"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    network                  = "networkName"
    public_subnetwork        = "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-apcj-japan/regions/asia-northeast1/subnetworks/mock-subnet1"
    private_subnetwork       = "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-apcj-japan/regions/asia-northeast1/subnetworks/mock-subnet2"
    public_subnetwork_cidr_block             = "10.1.10.0/24"
    public_subnetwork_secondary_cidr_block   = "10.1.12.0/24"
    private_subnetwork_cidr_block            = "192.168.10.0/24"
    private_subnetwork_secondary_cidr_block  = "192.168.11.0/24"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  #skip_outputs = true
}

dependency "vpc2" {
  config_path = "../vpc2"

  mock_outputs = {
    network                  = "networkName"
    public_subnetwork        = "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-apcj-japan/regions/asia-northeast1/subnetworks/mock-subnet3"
    private_subnetwork       = "https://www.googleapis.com/compute/v1/projects/f5-gcs-4261-sales-apcj-japan/regions/asia-northeast1/subnetworks/mock-subnet4"
    public_subnetwork_cidr_block             = "10.2.10.0/24"
    public_subnetwork_secondary_cidr_block   = "10.2.12.0/24"
    private_subnetwork_cidr_block            = "192.168.12.0/24"
    private_subnetwork_secondary_cidr_block  = "192.168.13.0/24"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  #skip_outputs = true
}



# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix             = "robin-cluster1"
  project                 = "f5-gcs-4261-sales-apcj-japan"
  region                  = "asia-northeast1"
  network                 = dependency.vpc.outputs.network
  network2                = dependency.vpc2.outputs.network
  allowed_networks        = ["210.226.41.0/24"]

  public_subnetwork       = dependency.vpc.outputs.public_subnetwork
  private_subnetwork      = dependency.vpc.outputs.private_subnetwork
  private_subnetwork2     = dependency.vpc2.outputs.private_subnetwork

  pub_subnw_range         = dependency.vpc.outputs.public_subnetwork_cidr_block
  pub_subnw_range_scndry  = dependency.vpc.outputs.public_subnetwork_secondary_cidr_block
  priv_subnw_range        = dependency.vpc.outputs.private_subnetwork_cidr_block
  priv_subnw_range_scndry = dependency.vpc.outputs.private_subnetwork_secondary_cidr_block

  priv_subnw_range2        = dependency.vpc2.outputs.private_subnetwork_cidr_block
  priv_subnw_range_scndry2 = dependency.vpc2.outputs.private_subnetwork_secondary_cidr_block

}