terraform {
  backend "s3" {
    bucket = "name_of_bucket"
    
  }
}
provider "aws" {
    region = "us-east-1"
}
