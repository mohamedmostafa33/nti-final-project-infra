resource "aws_s3_bucket" "reddit_clone_bucket" {
  bucket = var.s3_bucket_name
  tags = {
    Name        = "reddit-clone-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "reddit_clone_bucket_ownership_controls" {
  bucket = aws_s3_bucket.reddit_clone_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "reddit_clone_bucket_public_access_block" {
  bucket = aws_s3_bucket.reddit_clone_bucket.id

  block_public_acls       = true  
  ignore_public_acls      = true  
  block_public_policy     = false   
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read_static_and_media" {
  bucket = aws_s3_bucket.reddit_clone_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.reddit_clone_bucket.bucket}/static/*",
          "arn:aws:s3:::${aws_s3_bucket.reddit_clone_bucket.bucket}/media/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.reddit_clone_bucket_public_access_block]
}

resource "aws_s3_bucket_versioning" "reddit_clone_bucket_versioning" {
  bucket = aws_s3_bucket.reddit_clone_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "reddit_clone_bucket_sse" {
  bucket = aws_s3_bucket.reddit_clone_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}