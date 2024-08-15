# output "first_arn"{
#     value = aws_iam_user.eg[0].arn
#     description = "the arn for the first user"
  
# }
# output "iam_user_arns" {
#     value = aws_iam_user.eg[*].arn
#     description = "THe Arns for all users"

  
# }
output "all_users" {
    value = aws_iam_user.eg
  
}

# output "all_arns" {
#   value = [for user in values(module.users) : user.arn]
# }
output "upper_names"{
    value = [for name in var.user_names: upper(name)]
  
}

# output "cy_cloudwatch_policy_arn" {
#   value = (
#     var.give_cy_cloudwatch_full_access
#     ? aws_iam_user_policy_attachment.neo_cloudwatch_full_access[0].policy_arn
#     : aws_iam_user_policy_attachment.neo_cloudwatch_read_only[0].policy_arn
#   )
# }

output "cy_cloudwatch_policy_arn" {
  value = one(concat(
    aws_iam_user_policy_attachment.neo_cloudwatch_full_access[*].policy_arn,
    aws_iam_user_policy_attachment.neo_cloudwatch_read_only[*].policy_arn
  ))
}
