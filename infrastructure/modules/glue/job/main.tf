resource "aws_glue_job" "immo-glue-job" {
  name     = var.zillow_glue_job_name
  role_arn = var.zillow_glue_role_arn
  glue_version = var.zillow_glue_version
  timeout = var.zillow_glue_timeout

  command {
    script_location = "s3://${var.data_processing_script_location}"
  }

  default_arguments = {
    "--class"                   = var.class
    "--enable-job-insights"     = var.enable-job-insights
    "--enable-auto-scaling"     = var.enable-auto-scaling
    "--enable-glue-datacatalog" = var.enable-glue-datacatalog
    "--job-language"            = var.job-language
    "--job-bookmark-option"     = var.job-bookmark-option
    "--datalake-formats"        = var.datalake-formats
    "--conf"                    = var.conf
  }
}