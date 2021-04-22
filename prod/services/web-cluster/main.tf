# PROD

provider "aws" {
  region = "us-east-1"
}

# Allow any 3.x version of the AWS provider
version = "~> 3.0"

# Allow any 0.14.x version of Terraform
required_version = ">= 0.14, < 0.15"

module "web-cluster" {
  source = "github.com/smokentar/aws_tf_modules//services/simple-app?ref=master"

  # Pass in prod-specific variables
  cluster_name = "web-prod"
  live_ami = "ami-013f17f36f8b1fefb"

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
