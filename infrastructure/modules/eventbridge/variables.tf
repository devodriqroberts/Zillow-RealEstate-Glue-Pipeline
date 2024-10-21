variable "schedule_name" {
  description = "Name of the schedule."
  type        = string
}

variable "schedule_expression" {
  description = "Defines when the schedule runs."
  type        = string
}

variable "processing_lambda_arn" {
  description = "Processing lambda ARN"
  type        = string
}

variable "processing_lambda_function_name" {
  description = "Processing lambda function name"
  type        = string
}

