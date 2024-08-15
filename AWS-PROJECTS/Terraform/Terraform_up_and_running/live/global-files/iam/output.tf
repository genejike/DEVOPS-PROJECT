output "all_users" {
    value = module.users.all_users
  
}

output "user_arns"{
    value = values(module.users.all_users)[*].arn
    description = "the arn for the created IAM  user"
  
}
# output "upper_names"{
#     value = [for name in var.user_names: upper(name)]
  
# }