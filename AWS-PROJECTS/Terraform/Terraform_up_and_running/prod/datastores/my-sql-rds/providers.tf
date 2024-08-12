terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "prod-bucket"
    key            = "prod/data-stores/mysql/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "prod-lock"
    encrypt        = true
  }
 
 
}
provider "aws" {
    region = "us-east-1"
}
