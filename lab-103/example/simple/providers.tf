terraform {
  required_version = ">= 1.2.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.4.0"
    }
  }

  backend "s3" {
    dynamodb_table = "symple-terraform-lock"
    key            = "symple-dev/terraform.tfstate"
    acl            = "bucket-owner-full-control"
    bucket         = "symple-terraform-repo"
    encrypt        = true
    region         = "ap-northeast-2"
  }
}

provider "aws" {
  profile = "terra"
  region  = "ap-northeast-2"
}