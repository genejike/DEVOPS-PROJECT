terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "ketbuc678989797"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
 
 
}
provider "aws" {
    region = "us-east-1"
}
