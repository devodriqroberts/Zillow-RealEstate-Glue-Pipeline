variable "zillow_glue_job_trigger_name" {
  description = "The name of the trigger."
  type        = string
}

variable "zillow_glue_job_trigger_schedule" {
  description = "A cron expression used to specify the schedule. "
  type        = string
}

variable "zillow_glue_job_name" {
  description = "The name of a job to be executed."
  type        = string
}
