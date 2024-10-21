variable "data_processing_script_location" {
  description = "Specifies the S3 path to a script that executes a job."
  type        = string
}

variable "zillow_glue_job_name" {
  description = "The name of the job command."
  type        = string
}

variable "zillow_glue_timeout" {
  description = "The job timeout in minutes."
  type        = string
}

variable "zillow_glue_role_arn" {
  description = "The ARN of the IAM role associated with this job."
  type        = string
}

variable "zillow_glue_version" {
  description = "The version of glue to use, for example '1.0'. Ray jobs should set this to 4.0 or greater."
  type        = string
}

variable "class" {
  description = "The Scala class that serves as the entry point for your Scala script."
  type        = string
}

variable "enable-job-insights" {
  description = "Enables additional error analysis monitoring with AWS Glue job run insights."
  type        = string
}

variable "enable-auto-scaling" {
  description = "Turns on auto scaling and per-worker billing when you set the value to true."
  type        = string
}

variable "enable-glue-datacatalog" {
  description = "Enables you to use the AWS Glue Data Catalog as an Apache Spark Hive metastore. To enable this feature, set the value to true."
  type        = string
}

variable "job-language" {
  description = "The script programming language. This value must be either scala or python. If this parameter is not present, the default is python."
  type        = string
}

variable "job-bookmark-option" {
  description = "Controls the behavior of a job bookmark. The following option values can be set."
  type        = string
}

variable "datalake-formats" {
  description = "Specifies the data lake framework to use. AWS Glue adds the required JAR files for the frameworks that you specify into the classpath."
  type        = string
}

variable "conf" {
  description = "Controls Spark config parameters. It is for advanced use cases."
  type        = string
}