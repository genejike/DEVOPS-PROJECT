

provider "aws" {
    region = "us-east-1"
  
}
module "webservercluster" {
    source = "../../../../modules/services/webservercluster"
    cluster_name = "websevers-prod"
   db_remote_state_bucket = "ketbuc678989797"
   db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
   instance_type = "t2.micro"
   min_size = 2
   max_size = 10 
   enable_autoscaling = true
   custom_tags = {
    owner ="team-mary"
    ManagedBY = "terraform"
   }
   
  
}

