output "bucket_id" {
    description = "this is the bucket name"
    value = aws_s3_bucket.terraform_state.bucket
  
}
output "s3_bucket_arn" {
    value = aws_s3_bucket.terraform_state.arn
    description = "s3 bucket arn"
  
}
output "dynamodb_table_name" {
    value = aws_dynamodb_table.terraform_locks.name
    description = "dynamodb table"
  
}
output "public_ip" {
    description = "public ipv4 address"
    value = aws_instance.example.public_ip
    sensitive = false
  
}