terraform {
  cloud {
    organization = "gitlab-poc"

    workspaces {
      name = "lamnda-layer"
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
  region = "us-east-1"
}



resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = "yum install zip -y ; apt install zip -y; chmod +x test.sh; ./test.sh"
    interpreter = ["bash", "-c"] 

  }
}