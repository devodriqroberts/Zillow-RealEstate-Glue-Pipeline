resource "aws_glue_crawler" "zillow_glue_crawler" {
  database_name = var.glue_catalog_database_name
  name          = var.zillow_glue_crawler_name
  role          = var.zillow_glue_crawler_iam_role
  classifiers   = var.zillow_glue_crawler_classifiers
  table_prefix  = "immo_"

  s3_target {
    path = "${var.s3_target_path}/${var.city}"
  }
}