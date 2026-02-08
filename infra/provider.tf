provider "aws" {
  region     = "us-east-1"
  
  access_key = var.target_access_key
  secret_key = var.target_secret_key
}