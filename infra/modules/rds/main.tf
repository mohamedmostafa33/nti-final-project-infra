resource "aws_security_group" "reddit_clone_rds_sg" {
  name        = "reddit-clone-rds-sg"
  description = "Security group for Reddit Clone RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.eks_node_group_sg_id]
    description = "Allow EKS node group to access RDS"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.eks_cluster_sg_id]
    description = "Allow EKS cluster security group to access RDS"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.eks_cluster_managed_sg_id]
    description = "Allow EKS cluster-managed security group to access RDS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "reddit-clone-rds-sg"
  }
}

resource "aws_db_subnet_group" "reddit_clone_rds_subnet_group" {
  name       = "reddit-clone-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "reddit-clone-rds-subnet-group"
  }
}

resource "aws_db_instance" "reddit_clone_rds_instance" {
  identifier              = var.db_name
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  db_name                 = var.db_database_name
  username                = var.db_username
  password                = var.db_password
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_subnet_group_name    = aws_db_subnet_group.reddit_clone_rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.reddit_clone_rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  deletion_protection     = false
  multi_az                = false
  backup_retention_period = 0

  tags = {
    Name = "reddit-clone-rds"
 }
}