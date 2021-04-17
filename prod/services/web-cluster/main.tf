# PROD

provider "aws" {
  region = "us-east-1"
}

module "web-cluster" {
  source = "github.com/smokentar/aws_tf_modules//services/web_cluster?ref=master"

  # Pass in prod-specific variables
  cluster_name = "web-prod"
  db_remote_state_bucket = "terraform-state-<number>"
  db_remote_state_key = "prod/services/data_stores/mysql/terraform.tfstate"

  min_size_asg = 4
  max_size_asg = 4
  instance_type  = "t3.medium"

  scheduled_actions = true

  custom_tags = {
    Environment = "Production"
    Type = "immutable"
  }
}

terraform {
  # Partial config; pulls data from backend.hcl
  backend "s3" {
    key = "prod/services/web-cluster/terraform.tfstate"
  }
}

# Ensure that outputs from the module are exported to the remote tfstate file
# Post v12 outputs from child modules must be exported in the root module
output "web_cluster_export" {
  value = module.web-cluster
}
