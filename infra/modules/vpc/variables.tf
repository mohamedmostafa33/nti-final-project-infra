variable "vpc_cidr_block" {
  description = "The cidr for the vpc"
  type = string
}

variable "public_subnet_cidr_block_a" {
  description = "The cidr for the public subnet"
  type = string
}

variable "public_subnet_cidr_block_b" {
  description = "The cidr for the second public subnet"
  type = string
}

variable "private_subnet_cidr_block_a" {
  description = "The cidr for the private subnet"
  type = string
}

variable "private_subnet_cidr_block_b" {
  description = "The cidr for the second private subnet"
  type = string
}