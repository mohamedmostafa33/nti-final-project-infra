output "ecr_repository_url" {
  value = module.ecr.ecr_repository_url
}

output "s3_bucket_name" {
  value = module.s3.s3_bucket_name
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = module.rds.db_endpoint
}

output "db_port" {
  description = "Database port"
  value       = module.rds.db_port
}

output "db_instance_id" {
  description = "Database instance ID"
  value       = module.rds.db_instance_id
}