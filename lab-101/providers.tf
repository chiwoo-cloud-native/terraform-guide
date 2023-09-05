terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

# export AWS_PROFILE=terra
# export AWS_REGION=ap-northeast-2

provider "aws" {
  # profile = "terra"
  region  = "ap-northeast-2"
}
