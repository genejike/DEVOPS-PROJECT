resource "aws_db_instance" "rdsexample" {
    identifier_prefix = "terraform-up-and-running"
    engine = "mysql"
    engine_version  = "8.0.35"
    allocated_storage = 10
    instance_class = "db.t3.micro"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot = true
    db_name = "marydb"
    username = var.db_username
    password = var.db_password
    
  
}

