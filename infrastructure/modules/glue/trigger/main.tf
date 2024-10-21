resource "aws_glue_trigger" "glue_job_trigger" {
  name     = var.zillow_glue_job_trigger_name
  schedule = var.zillow_glue_job_trigger_schedule
  type     = "SCHEDULED"

  actions {
    job_name = var.zillow_glue_job_name
  }
}