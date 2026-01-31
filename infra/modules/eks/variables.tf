variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type = list(string)
}

variable "eks_version" {
  description = "The Kubernetes version for the EKS cluster"
  type = string
}

variable "node_instance_type" {
  description = "Instance type for the node group"
  type = string
}

variable "node_min_size" {
  description = "Minimum number of nodes"
  type = number
}

variable "node_max_size" {
  description = "Maximum number of nodes"
  type = number
}

variable "tags" {
  description = "Tags for all resources"
  type = map(string)
}