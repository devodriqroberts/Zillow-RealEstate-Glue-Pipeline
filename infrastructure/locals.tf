data "aws_caller_identity" "current" {}

variable "rapid_api_host" {
  description = "Host to Zillow RapidAPI endpoint"
  type        = string
  default = "zillow-com1.p.rapidapi.com"
}

variable "rapid_api_key" {
  description = "API key to Zillow RapidAPI endpoint"
  type        = string
}

variable "terraform_role_arn" {
  description = "Terraform ARN role for github actions"
  type        = string
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  aws_region               = "us-east-1"

  lambda_layer_bucket_name = "droberts-lambda-layer-bucket"
  lambda_layer             = "lambda_layer"
  rapid_api_host           = var.rapid_api_host
  rapid_api_key            = var.rapid_api_key
  terraform_role_arn       = var.terraform_role_arn

  # buckets 
  etl_bucket_name          = "droberts-real-estate-etl"
  etl_utils_bucket_name    = "droberts-real-estate-etl-utils"
  data_loading_zone_key    = "raw-data/"
  data_processed_zone_key  = "processed-data/"

  # scripts
  etl_script_key                        = "script/glue_etl_script.py"
  local_etl_data_processing_script_path = "../etl/glue_job/transform_data.py"

  # requests lambda layer
  requests_layer_zip_path   = "requests.zip"
  requests_layer_name       = "zillow_requests_layer"

  path_to_system_folder     = "../etl/extract/System"

  compatible_layer_runtimes = ["python3.10", "python3.11", "python3.12"]
  compatible_architectures  = ["x86_64"]

  # lambda 
  path_to_source_folder = "../etl/extract"
  path_to_output        = "lambda_function_extract_data.zip"
  function_name         = "lambda_extract_fromAPI"
  function_handler      = "extract_data.lambda_handler"
  memory_size           = 512
  timeout               = 300
  runtime               = "python3.12"

  # Glue catalog
  glue_catalog_database_name = "zillow_real_estate_database"

  # iam

  # Glue Crawler
  crawler_name        = "zillow_real_estate_crawler"
  city                = "atlanta"

  # Glue Classifier
  classifier_name = "zillow_real_estate_classifier"
  json_path       = "$[*]"

  # Glue Job
  glue_job_name           = "real_estate_job"
  glue_version            = "4.0"
  worker_type             = "G.1X"
  number_of_workers       = 2
  time_out                = 2880
  script_location         = ""
  class                   = "GlueApp"
  enable-job-insights     = "true"
  enable-auto-scaling     = "false"
  enable-glue-datacatalog = "true"
  job-language            = "python"
  job-bookmark-option     = "job-bookmark-disable"
  datalake-formats        = "iceberg"
  conf                    = "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions  --conf spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog  --conf spark.sql.catalog.glue_catalog.warehouse=s3://tnt-erp-sql/ --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog  --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO"

  # cloudwatch
  schedule_name  = "schedule"
  schedule_expression = "cron(0 8 ? * MON-FRI *)"

  # Glue Trigger 
  glue_trigger_name           = "zillow-real-estate-glue-job-trigger"
  glue_trigger_schedule_value = "cron(15 12 * * ? *)"

}