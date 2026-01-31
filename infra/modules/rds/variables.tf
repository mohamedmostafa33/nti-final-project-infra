variable "vpc_id" {
  description = "VPC ID where RDS will located"
  type = string
}

variable "eks_node_group_sg_id" {
  description = "EKS node group security group ID"
  type = string
}

variable "eks_cluster_sg_id" {
  description = "EKS cluster security group ID"
  type = string
}

variable "eks_cluster_managed_sg_id" {
  description = "EKS cluster-managed security group ID (automatically created by EKS)"
  type = string
}

variable "db_name" {
  description = "RDS instance identifier"
  type = string
}

variable "db_database_name" {
  description = "Database name to create in RDS instance"
  type = string
}

variable "db_username" {
  description = "Database username"
  type = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance type"
  type = string
}

variable "db_engine" {
  description = "Database engine"
  type        = string
}

variable "db_engine_version" {
  description = "Database engine version"
  type = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}