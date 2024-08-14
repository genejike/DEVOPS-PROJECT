output "address" {
  value       = aws_db_instance.rdsexample.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.rdsexample.port
  description = "The port the database is listening on"
}