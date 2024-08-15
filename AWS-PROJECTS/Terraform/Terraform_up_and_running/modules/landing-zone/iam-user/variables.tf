variable "user_names" {
    type = list(string)
  
}
variable "iam_user_tag" {
    type = string
  
}
variable "give_cy_cloudwatch_full_access" {
  description = "If true, neo gets full access to CloudWatch"
  type        = bool
}