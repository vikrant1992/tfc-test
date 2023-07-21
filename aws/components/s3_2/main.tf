terraform {
  cloud {
    organization = "gitlab-poc"

    workspaces {
      name = "testing-aws-oidc"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
 
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-plplplplplp"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
