module "webservercluster" {
    source = "../../../../modules/services/webservercluster"
   ami         = "ami-04a81a99f5ec58529"
   server_text = "HY_bby"
   cluster_name = "websevers-stage"
   db_remote_state_bucket = "ketbuc678989797"
   db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
   instance_type = "t2.micro"
   min_size = "1"
   max_size = "2"
   enable_autoscaling = false
    custom_tags = {
    owner ="team-mary"
    ManagedBY = "terraform"
   }
   
}
