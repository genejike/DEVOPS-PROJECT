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
    dynamodb_table = "value"
    bucket = "value"
    
  }
}
provider "aws"{
    region = "us-east-1"
}