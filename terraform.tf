# Configure Terraform.

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      region = "us-east-1"
    }
  }
  required_version = ">= 0.13"
}
