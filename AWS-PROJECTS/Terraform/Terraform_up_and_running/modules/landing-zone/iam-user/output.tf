output "first_arn"{
    value = aws_iam_user.eg[0].arn
    description = "the arn for the first user"
  
}
output "iam_user_arns" {
    value = aws_iam_user.eg[*].arn
    description = "THe Arns for all users"

  
}