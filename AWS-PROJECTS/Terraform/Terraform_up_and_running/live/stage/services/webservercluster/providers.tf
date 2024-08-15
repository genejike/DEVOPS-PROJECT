terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.62.0"
    }
    
  }
  backend "s3" {
    key = "stage/services/webserver-cluster/terraform.tfstate"
    region = "us-east-1"
    bucket = "ketbuc678989797"
    dynamodb_table = "terraform-locks"
    
  }
  
}
provider "aws"{
    region = "us-east-1"
    default_tags {
      tags = {
        Owner = "team-mary"
        ManagedBY = "Terraform"
      }
    }
}
