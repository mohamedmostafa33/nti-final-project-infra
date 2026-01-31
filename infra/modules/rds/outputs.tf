output "db_endpoint" {
  description = "Database endpoint"
  value = aws_db_instance.reddit_clone_rds_instance.endpoint
}

output "db_port" {
  description = "Database port"
  value = aws_db_instance.reddit_clone_rds_instance.port
}

output "db_instance_id" {
  description = "Database instance ID"
  value = aws_db_instance.reddit_clone_rds_instance.id
}
