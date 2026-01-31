variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "reddit-clone-app-repo"
}

variable "s3_bucket_name" {
  description = "Name of the s3 bucket"
  type        = string
  default     = "reddit-clone-s3-media"
}

variable "db_name" {
  description = "RDS instance identifier"
  type        = string
  default     = "reddit-clone-db"
}

variable "db_database_name" {
  description = "Database name to create in RDS instance"
  type        = string
  default     = "redditclone"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "redditadmin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "RedditClone123!"
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "17.6"
}