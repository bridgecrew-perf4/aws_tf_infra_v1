#STAGING

provider "aws" {
  region = "us-east-1"
}

module "web_cluster" {
  # This cluster will host a simple app
  source = "github.com/smokentar/aws_tf_modules//services/simple-app?ref=staging"

  # Pass in staging-specific variables
  cluster_name = "web-staging"
  live_ami = "ami-013f17f36f8b1fefb"

  db_remote_state_bucket = "terraform-state-<number>" # Replace with S3 bucket output
  db_remote_state_key = "staging/services/data_stores/mysql/terraform.tfstate"

  min_size_asg = 2
  max_size_asg = 2
  instance_type  = "t2.micro"

  scheduled_actions = false

  custom_tags = {
    Environment = "Staging"
    Type = "immutable"
  }
}

# Test any inbound traffic to the ALB fronting the initial web servers here
# To apply to prod - implement in the web_cluster module
/*
resource "aws_security_group_rule" "allow_test_inbound" {
  type = "ingress"
  security_group_id = module.web_cluster.alb_sg_id

  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
*/

terraform {
  # Partial config; pulls data from backend.hcl
  backend "s3" {
    key = "staging/services/web-cluster/terraform.tfstate"
  }

  # Allow any 3.x version of the AWS provider
  version = "~> 3.0"

  # Allow any 0.14.x version of Terraform
  required_version = ">= 0.14, < 0.15"
}

# Ensure that outputs from the module are exported to the remote tfstate file
# Post v12 outputs from child modules must be exported in the root module
output "web_cluster_export" {
  value = module.web_cluster
}
