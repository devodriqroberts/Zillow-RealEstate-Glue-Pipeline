variable "rapid_api_key" {
  description = "Rapid API Key"
  type        = string
}

variable "rapid_api_host" {
  description = "Rapid API Host"
  type        = string
  default     = "zillow-com1.p.rapidapi.com"
}

variable "aws_region" {
  description = "AWS Region to deploy to"
  type        = string
  default = "us-east-1"
}

variable "zillow_etl_data_bucket" {
  description = "landing zone bucket name"
  type        = string
}

variable "zillow_etl_data_bucket_arn" {
  description = "landing zone bucket ARN"
  type        = string
}

variable "data_loading_zone_key" {
  description = "raws data repository"
  type        = string
  default     = "raw_data"
}

variable "lambda_layer_arn" {
  description = "lambda_layer_arns"
  type        = string
}

variable "runtime" {
  description = "Lambda Runtime"
  type        = string
}

variable "function_handler" {
  description = "Name of Lambda Function Handler"
  type        = string
}

variable "function_name" {
  description = "Name of Lambda Function"
  type        = string
}

variable "path_to_source_folder" {
  description = "Path to Lambda Fucntion Source Code"
  type        = string
}

variable "path_to_output" {
  description = "Path to ZIP artifact"
  type        = string
}

variable "memory_size" {
  description = "Lambda Memory"
  type        = number
}

variable "timeout" {
  description = "Lambda Timeout"
  type        = number
}

variable "s3_bucket_arn" {
  description = "lambda_layer_arns"
  type        = string
}