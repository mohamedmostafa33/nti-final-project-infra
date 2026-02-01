terraform {
  backend "s3" {
    bucket         = "reddit-nti-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"

    dynamodb_table = "reddit-nti-tfstate-lock"
    encrypt        = true
  }
}
