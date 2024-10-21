resource "aws_s3_bucket" "zillow_etl_bucket" {
  bucket        = var.etl_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket" "zillow_etl_utils_bucket" {
  bucket        = var.etl_utils_bucket_name
  force_destroy = true
}

resource "aws_s3_object" "data_loading_zone" {
  bucket        = aws_s3_bucket.zillow_etl_bucket.id
  key           = var.data_loading_zone_key
  acl           = "private"
  content_type  = "application/x-directory"
}

resource "aws_s3_object" "data_processed_zone" {
  bucket        = aws_s3_bucket.zillow_etl_bucket.id
  key           = var.data_processed_zone_key
  acl           = "private"
  content_type  = "application/x-directory"
}

resource "aws_s3_object" "etl_data_processing_script" {
  bucket    = aws_s3_bucket.zillow_etl_utils_bucket.id
  key       = var.etl_script_key
  source    = var.local_etl_data_processing_script_path
  etag      = filemd5(var.local_etl_data_processing_script_path)
}