# User management

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names) #toset converts the list into a set
  name = each.value
}

output "all_users" {
  value = values(aws_iam_user.example)[*].arn
}
