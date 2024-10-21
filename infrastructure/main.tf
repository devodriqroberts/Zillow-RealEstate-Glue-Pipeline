terraform {
    backend "s3" {
        bucket          = "172431101814-terraform-states"
        key             = "zillow-api-glue-pipeline-tf-infra/terraform.tfstate"
        region          = "us-east-1"
        dynamodb_table  = "terraform-lock"
        encrypt         = true
        profile         = "terraform"
    }

    required_providers {
        aws = {
        source    = "hashicorp/aws"
        version   = "5.72.0"
    }
  }
}

provider "aws" {
    region    = "us-east-1"
    profile   = "terraform"
}

module "remote_backend" {
    source      = "./backend"

    account_id = local.account_id
}

# S3 Storage Buckets
module "etl_data_buckets" {
  source                                = "./modules/s3"

  etl_bucket_name                       = local.etl_bucket_name
  etl_utils_bucket_name                 = local.etl_utils_bucket_name
  data_loading_zone_key                 = local.data_loading_zone_key
  data_processed_zone_key               = local.data_processed_zone_key
  etl_script_key                        = local.etl_script_key
  local_etl_data_processing_script_path = local.local_etl_data_processing_script_path
}

module "lambda_layer" {
  source                    = "./modules/request_layer"

  compatible_architectures  = local.compatible_architectures
  compatible_layer_runtimes = local.compatible_layer_runtimes
  lambda_layer              = local.lambda_layer
  lambda_layer_bucket_name  = local.lambda_layer_bucket_name
  requests_layer_name       = local.requests_layer_name
  requests_layer_zip_path   = local.requests_layer_zip_path
}

module "lambda_function" {
  source                    = "./modules/lambda"

  aws_region                    = local.aws_region
  data_loading_zone_key         = local.data_loading_zone_key
  function_handler              = local.function_handler
  function_name                 = local.function_name
  lambda_layer_arn              = module.lambda_layer.lambda_layer_arn
  memory_size                   = local.memory_size
  path_to_output                = local.path_to_output
  path_to_source_folder         = local.path_to_source_folder
  rapid_api_host                = local.rapid_api_host
  rapid_api_key                 = local.rapid_api_key
  runtime                       = local.runtime
  s3_bucket_arn                 = module.etl_data_buckets.zilliow_etl_bucket_arn
  zillow_etl_data_bucket        = local.etl_bucket_name
  timeout                       = local.timeout
  zillow_etl_data_bucket_arn    = module.etl_data_buckets.zilliow_etl_bucket_arn
}

module "lambda_schedule" {
  source                            = "./modules/eventbridge"

  processing_lambda_arn             = module.lambda_function.lambda_function_arn
  processing_lambda_function_name   = module.lambda_function.lambda_function_name
  schedule_expression               = local.schedule_expression
  schedule_name                     = local.schedule_name
}

module "zillow_glue_catalog_database" {
  source                        = "./modules/glue/catalog_database"

  glue_catalog_database_name    = local.glue_catalog_database_name
}

module "zillow_glue_iam_role" {
  source ="./modules/glue/iam_role"
}

module "zillow_glue_classifier" {
  source          = "./modules/glue/classifier"

  classifier_name = local.classifier_name
  json_path       = local.json_path
}

module "zillow_glue_crawler" {
  source                            = "./modules/glue/crawler"

  city                              = local.city
  glue_catalog_database_name        = module.zillow_glue_catalog_database.glue_catalog_database_name
  s3_target_path                    = module.etl_data_buckets.zilliow_etl_loading_zone_uri
  zillow_glue_crawler_classifiers   = [module.zillow_glue_classifier.aws_glue_classifier_id]
  zillow_glue_crawler_iam_role      = module.zillow_glue_iam_role.glue_iam_arn
  zillow_glue_crawler_name          = local.crawler_name
}

module "zillow_glue_job" {
  source                            = "./modules/glue/job"

  class                             = local.class
  conf                              = local.conf
  data_processing_script_location   = module.etl_data_buckets.zilliow_etl_data_processing_script_uri
  datalake-formats                  = local.datalake-formats
  enable-auto-scaling               = local.enable-auto-scaling
  enable-glue-datacatalog           = local.enable-glue-datacatalog
  enable-job-insights               = local.enable-job-insights
  job-bookmark-option               = local.job-bookmark-option
  job-language                      = local.job-language
  zillow_glue_job_name              = local.glue_job_name
  zillow_glue_role_arn              = module.zillow_glue_iam_role.glue_iam_arn
  zillow_glue_timeout               = local.timeout
  zillow_glue_version               = local.glue_version
}

module "zillow_glue_trigger" {
  source                            = "./modules/glue/trigger"

  zillow_glue_job_name              = module.zillow_glue_job.aws_glue_job_name
  zillow_glue_job_trigger_name      = local.glue_trigger_name
  zillow_glue_job_trigger_schedule  = local.glue_trigger_schedule_value
}