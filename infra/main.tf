module "ecr" {
  source = "./modules/ecr"
  ecr_name = var.ecr_name
}

module "s3" {
  source         = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
}