# Backend configuration for main.tf
# Introduced to avoid manual work
# Pass in with -backend-config=backend.hcl

bucket = "terraform-state-20210409171444659800000001" # Replace with S3 bucket output
region = "us-east-1"
dynamodb_table = "terraform-state-lock"
encrypt = true
