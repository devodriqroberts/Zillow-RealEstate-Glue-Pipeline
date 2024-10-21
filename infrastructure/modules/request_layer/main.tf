# create zip file from requirements.txt. Triggers only when the file is updated
# first method 
resource "null_resource" "lambda_layer" {
  provisioner "local-exec" {
    command = <<EOT
      set -e
      rm -rf python
      mkdir python
      pip3 install requests -t python/
      zip -r ${var.requests_layer_zip_path} python/
      rm -rf python
    EOT
  }
}

resource "aws_s3_bucket" "lambda_layer_bucket" {
  bucket = var.lambda_layer_bucket_name
}

resource "aws_s3_object" "lambda_layer_zip" {
    bucket      = aws_s3_bucket.lambda_layer_bucket.id
    key         =  "${var.requests_layer_name}/${var.requests_layer_zip_path}"
    source      = var.requests_layer_zip_path
    depends_on  = [null_resource.lambda_layer]   
}

resource "aws_lambda_layer_version" "requests_layer" {
  s3_bucket             = aws_s3_bucket.lambda_layer_bucket.id
  s3_key                = aws_s3_object.lambda_layer_zip.key
  layer_name            = var.requests_layer_name
  compatible_runtimes   = var.compatible_layer_runtimes
  depends_on            = [aws_s3_object.lambda_layer_zip]
}