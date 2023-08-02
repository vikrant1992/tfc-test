


resource "null_resource" "lambda_exporter" {
  provisioner "local-exec" {
    command = "chmod +x ${var.script_path}; ${var.script_path}"
    interpreter = ["bash", "-c"] 
  }
  triggers = {
    index = "${base64sha256(file("${var.script_path}"))}"
  }
}



data "null_data_source" "wait_for_lambda_exporter" {
  inputs = {
    # This ensures that this data resource will not be evaluated until
    # after the null_resource has been created.
    lambda_exporter_id = "${null_resource.lambda_exporter.id}"

    # This value gives us something to implicitly depend on
    # in the archive_file below.
    source_dir = var.source_dir
  }
}

# locals {
#     lambda_exporter_id = "${null_resource.lambda_exporter.id}"
#     source_dir = "${path.module}/panda-layer/"

# }



data "archive_file" "lambda_exporter" {
  output_path = "${path.module}/lambda-files.zip"
  source_dir  = "${data.null_data_source.wait_for_lambda_exporter.outputs["source_dir"]}" #"${path.module}/panda-layer/" # local.source_dir  # 
  type        = "zip"

}


resource "aws_lambda_layer_version" "lambda_layer" {
    depends_on = [data.archive_file.lambda_exporter]
  filename   =  "${path.module}/lambda-files.zip"
  layer_name = "lambda_layer_name-2"

  compatible_runtimes = ["python3.8"]
  triggers = {
    index = "${base64sha256(file("${var.script_path}"))}"
  }
}

