variable "etl_bucket_name" {
  type = string
  description = "Zillow ETL data bucket name"
}

variable "etl_utils_bucket_name" {
  type = string
  description = "Zillow ETL utils bucket name"
}

variable "data_loading_zone_key" {
  type = string
  description = "Key name of ETL data loading zone"
}

variable "data_processed_zone_key" {
  type = string
  description = "Key name of ETL data processed zone"
}

variable "etl_script_key" {
  type = string
  description = "Key name of ETL data processing script"
}

variable "local_etl_data_processing_script_path" {
  type = string
  description = "Path of ETL data processing script"
}