terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.22.0"
    }
  }
}

provider "aws" {
  profile = "terra"
  region  = "ap-northeast-2"
}
