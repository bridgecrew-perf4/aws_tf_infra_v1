# User management

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names) #toset converts the list into a set
  name = each.value
}

terraform {
  # Partial config; pulls data from backend.hcl
  backend "s3" {
    key = "global/iam/terraform.tfstate"
  }

  # Allow any 3.x version of the AWS provider
  version = "~> 3.0"

  # Allow any 0.14.x version of Terraform
  required_version = ">= 0.14, < 0.15"
}

output "all_users" {
  value = values(aws_iam_user.example)[*].arn
}
