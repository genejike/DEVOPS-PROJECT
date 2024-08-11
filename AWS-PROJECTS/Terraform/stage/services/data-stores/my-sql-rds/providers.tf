terraform {
  backend "s3" {
    bucket = "terraform-${ }"
    
  }
}
provider "aws" {
    region = "us-east-1"
}
