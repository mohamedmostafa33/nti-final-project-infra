resource "aws_ecr_repository" "reddit_clone_app_ecr_repo" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
  
}