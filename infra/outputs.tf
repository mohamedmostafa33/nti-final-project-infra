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

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.internet_gateway_id
}

output "nat_eip_id" {
  description = "Elastic IP"
  value       = module.vpc.nat_eip_id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.vpc.nat_gateway_id
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = module.vpc.private_route_table_id
}

output "eks_cluster_name" {
  value       = module.eks.eks_cluster_name
  description = "Name of the EKS cluster"
}

output "eks_cluster_endpoint" {
  value       = module.eks.eks_cluster_endpoint
  description = "Cluster API server endpoint"
}

output "eks_cluster_arn" {
  value       = module.eks.eks_cluster_arn
  description = "ARN of the EKS cluster"
}

output "eks_node_group_name" {
  value       = module.eks.eks_node_group_name
  description = "Name of the EKS node group"
}

output "eks_node_group_arn" {
  value       = module.eks.eks_node_group_arn
  description = "ARN of the EKS node group"
}

output "eks_cluster_sg_id" {
  value       = module.eks.eks_cluster_sg_id
  description = "Security group ID of EKS cluster"
}

output "eks_node_group_sg_id" {
  value       = module.eks.eks_node_group_sg_id
  description = "Security group ID of EKS nodes"
}

output "eks_cluster_managed_sg_id" {
  value       = module.eks.eks_cluster_managed_sg_id
  description = "Cluster-managed security group ID automatically created by EKS"
}