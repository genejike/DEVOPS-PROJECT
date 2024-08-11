terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.62.0"
    }
  }

  backend "s3" {
    key = "workspaces-example/terraform.tfstate"
    
    
  }
}
provider "aws" {
    region = "us-east-1"
  
}