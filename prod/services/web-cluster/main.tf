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

  custom_tags = {
    Environment = "Production"
    Type = "immutable"
  }
}

# to go in a module based on environment condition
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"

  autoscaling_group_name = module.web-cluster.asg_name
}

# to go in a module based on environment condition
resource "aws_autoscaling_schedule" "scale_in_after_business_hours" {
  scheduled_action_name = "scale-in-after-business-hours"
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *"

  autoscaling_group_name = module.web-cluster.asg_name
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
