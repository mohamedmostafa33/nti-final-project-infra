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