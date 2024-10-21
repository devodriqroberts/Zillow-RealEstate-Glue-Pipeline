output "terraform_state_bucket_id" {
  value         = aws_s3_bucket.terraform_state.id
  description   = "The NAME of the S3 bucket"
}

output "terraform_state_bucket_arn" {
  value         = aws_s3_bucket.terraform_state.arn
  description   = "The ARN of the S3 bucket"
}

output "terraform_state_bucket_region" {
  value         = aws_s3_bucket.terraform_state.region
  description   = "The REGION of the S3 bucket"
}

output "dynamodb_table_name" {
  value         = aws_dynamodb_table.terraform_lock.name
  description   = "The ARN of the DynamoDB table"
}

output "dynamodb_table_arn" {
  value         = aws_dynamodb_table.terraform_lock.arn
  description   = "The ARN of the DynamoDB table"
}