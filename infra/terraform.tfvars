ecr_name = "reddit-clone-app-repo"

s3_bucket_name = "reddit-clone-s3-media"

db_name = "reddit-clone-db"

db_database_name = "redditclone"

db_username = "redditadmin"

db_password = "RedditClone123!"

db_instance_class = "db.t3.micro"

db_engine = "postgres"

db_engine_version = "17.6"

vpc_cidr_block = "10.0.0.0/16"

public_subnet_cidr_block_a = "10.0.1.0/24"

public_subnet_cidr_block_b = "10.0.3.0/24"

private_subnet_cidr_block_a = "10.0.2.0/24"

private_subnet_cidr_block_b = "10.0.4.0/24"

cluster_name = "reddit-clone-eks-cluster"

eks_version = "1.33"

node_instance_type = "t3.small"

node_min_size = 3

node_max_size = 3

tags = {
  Environment = "Dev"
  Project     = "RedditClone"
}
