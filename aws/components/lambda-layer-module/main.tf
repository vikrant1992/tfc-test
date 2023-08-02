


resource "null_resource" "lambda_exporter" {
  provisioner "local-exec" {
    command = "chmod +x ${var.script_path}; ${var.script_path}"
    interpreter = ["bash", "-c"] 
  }
  triggers = {
    index = "${base64sha256(file("${var.script_path}"))}"
  }
}





resource "random_uuid" "layer_key" {}


data "archive_file" "lambda_exporter" {
  depends_on = [null_resource.lambda_exporter]

  output_path = "${path.module}/lambda-files.zip"
  source_dir  = "${path.module}/panda-layer/" #"${data.null_data_source.wait_for_lambda_exporter.outputs["source_dir"]}" #"${path.module}/panda-layer/" # local.source_dir  # 
  type        = "zip"

}


# # Resource to create s3 bucket object
resource "aws_s3_object" "lambda_package_layer" {

  source = data.archive_file.lambda_exporter.*.output_path[0]
  bucket = "test-bucketvikrant"
  key    = "layer"
}




resource "aws_lambda_layer_version" "lambda_layer" {
    depends_on = [data.archive_file.lambda_exporter, aws_s3_object.lambda_package_layer]
 # filename   =  "${path.module}/lambda-files.zip"
  layer_name = "lambda_layer_name-2"
  s3_bucket  = "test-bucketvikrant"
  s3_key     = "layer"

  compatible_runtimes = ["python3.8"]
}

