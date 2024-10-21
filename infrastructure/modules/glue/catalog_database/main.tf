resource "aws_glue_catalog_database" "zillow_glue_catalog_database" {
  name = var.glue_catalog_database_name
}