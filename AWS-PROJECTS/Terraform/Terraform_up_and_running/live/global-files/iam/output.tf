output "iam_user_arns"{
    value = module.users[*].iam_user_arns
    description = "the arn for the created IAM  user"
  
}

  
