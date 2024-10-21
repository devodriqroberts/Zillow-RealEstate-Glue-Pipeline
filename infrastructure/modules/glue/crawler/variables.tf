variable "glue_catalog_database_name" {
  description = "Glue database where results are written."
  type        = string
}

variable "zillow_glue_crawler_name" {
  description = "Name of the crawler"
  type        = string
}

variable "city" {
  description = "City value"
  type        = string
}

variable "s3_target_path" {
  description = "The path to the Amazon S3 target."
  type        = string
}

variable "zillow_glue_crawler_iam_role" {
  description = "The IAM role friendly name (including path without leading slash), or ARN of an IAM role, used by the crawler to access other resources."
  type        = string
}

variable "zillow_glue_crawler_classifiers" {
  description = "List of custom classifiers. By default, all AWS classifiers are included in a crawl, but these custom classifiers always override the default classifiers for a given classification."
  type        = list(string)
}

