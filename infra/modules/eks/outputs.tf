output "eks_cluster_name" {
  value       = aws_eks_cluster.reddit_clone_eks_cluster.name
  description = "Name of the EKS cluster"
}

output "eks_cluster_endpoint" {
  value       = aws_eks_cluster.reddit_clone_eks_cluster.endpoint
  description = "Cluster API server endpoint"
}

output "eks_cluster_arn" {
  value       = aws_eks_cluster.reddit_clone_eks_cluster.arn
  description = "ARN of the EKS cluster"
}

output "eks_node_group_name" {
  value       = aws_eks_node_group.reddit_clone_eks_node_group.node_group_name
  description = "Name of the EKS node group"
}

output "eks_node_group_arn" {
  value       = aws_eks_node_group.reddit_clone_eks_node_group.arn
  description = "ARN of the EKS node group"
}

output "eks_cluster_sg_id" {
  value       = aws_security_group.reddit_clone_eks_cluster_sg.id
  description = "Security group ID of EKS cluster"
}

output "eks_node_group_sg_id" {
  value       = aws_security_group.reddit_clone_eks_node_group_sg.id
  description = "Security group ID of EKS nodes"
}

output "eks_cluster_managed_sg_id" {
  value       = aws_eks_cluster.reddit_clone_eks_cluster.vpc_config[0].cluster_security_group_id
  description = "Cluster-managed security group ID automatically created by EKS"
}
