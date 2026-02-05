output "ecr_repository_urls" {
  description = "Map of ECR repository URLs"
  value       = { for name, repo in aws_ecr_repository.repos : name => repo.repository_url }
}

output "ecr_registry_url" {
  description = "ECR registry URL (without repo name)"
  value       = length(aws_ecr_repository.repos) > 0 ? split("/", values(aws_ecr_repository.repos)[0].repository_url)[0] : ""
}
