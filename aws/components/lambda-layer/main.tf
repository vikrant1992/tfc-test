
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





resource "null_resource" "lambda_exporter" {
  provisioner "local-exec" {
    command = "chmod +x ${path.module}/lambda-files/test.sh; ${path.module}/lambda-files/test.sh"
    interpreter = ["bash", "-c"] 
  }
  triggers = {
    index = "${base64sha256(file("${path.module}/lambda-files/test.sh"))}"
  }
}



data "null_data_source" "wait_for_lambda_exporter" {
  inputs = {
    # This ensures that this data resource will not be evaluated until
    # after the null_resource has been created.
    lambda_exporter_id = "${null_resource.lambda_exporter.id}"

    # This value gives us something to implicitly depend on
    # in the archive_file below.
    source_dir = "${path.module}/panda-layer/"
  }
}

data "archive_file" "lambda_exporter" {
  output_path = "${path.module}/lambda-files.zip"
  source_dir  = "${data.null_data_source.wait_for_lambda_exporter.outputs["source_dir"]}"
  type        = "zip"
}


resource "aws_lambda_layer_version" "lambda_layer" {
    depends_on = [data.archive_file.lambda_exporter]
  filename   =  "${path.module}/lambda-files.zip"
  layer_name = "lambda_layer_name"

  compatible_runtimes = ["python3.8"]
}

