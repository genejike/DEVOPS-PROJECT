terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.62.0"
    }
  }

  backend "s3" {
    key = "workspaces-example/terraform.tfstate"
    bucket = "terraform-43d63"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
    
    
  }
}
provider "aws" {
    region = "us-east-1"
  
}