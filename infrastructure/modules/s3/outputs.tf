output "zilliow_etl_bucket_arn"{
    value = aws_s3_bucket.zillow_etl_bucket.arn
}

output "zilliow_etl_utils_bucket_arn"{
    value = aws_s3_bucket.zillow_etl_utils_bucket.arn
}

output "zilliow_etl_loading_zone_uri" {
  value = "${aws_s3_bucket.zillow_etl_bucket.bucket}/${aws_s3_object.data_loading_zone.key}"
}

output "zilliow_etl_processed_zone_uri" {
  value = "${aws_s3_bucket.zillow_etl_bucket.bucket}/${aws_s3_object.data_processed_zone.key}"
}

output "zilliow_etl_data_processing_script_uri" {
  value = "${aws_s3_bucket.zillow_etl_utils_bucket.bucket}/${aws_s3_object.etl_data_processing_script.key}"
}