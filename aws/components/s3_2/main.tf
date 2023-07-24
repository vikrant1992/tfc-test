terraform {
  cloud {
    organization = "gitlab-poc"

    workspaces {
      name = "erie-test-vikrant-2"
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


resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = "pip install pandas"
  }
}