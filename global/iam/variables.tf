variable "user_names" {
  description = "Create the IAM users with specified names"
  type = list(string)
  default = ["user_1", "user_2", "user_3"]
}
