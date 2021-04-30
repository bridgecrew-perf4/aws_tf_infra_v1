### STAGING

provider "aws" {
  region = "us-east-1"
}

module "mysql" {
  source = "github.com/smokentar/aws_tf_modules//services/data_stores/mysql?ref=staging"

  db_instance_environment = "staging"

  custom_tags = {
    Environment = "Staging"
  }
}

terraform {
  # Partial config; pulls data from backend.hcl
  backend "s3" {
    key = "staging/services/data_stores/mysql/terraform.tfstate"
  }

  # Allow any 3.x version of the AWS provider
  version = "~> 3.0"

  # Allow any 0.14.x version of Terraform
  required_version = ">= 0.14, < 0.15"
}

# Ensure that outputs from the module are exported to the tfstate file
# Post v12 outputs from child modules must be exported in the root module
output "mysql_export" {
  value = module.mysql
}
