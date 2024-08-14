module "webservercluster" {
    source = "../../../../modules/services/webservercluster"
  
   cluster_name = "websevers-stage"
   db_remote_state_bucket = "ketbuc678989797"
   db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
   instance_type = "t2.micro"
   min_size = "1"
   max_size = "2"
}
