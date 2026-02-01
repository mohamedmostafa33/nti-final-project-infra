terraform {
  backend "s3" {
    bucket         = "reddit-clone-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"

    dynamodb_table = "reddit-terraform-locks"
    encrypt        = true
  }
}
