resource "huaweicloud_rds_parametergroup" "this" {
  name        = var.use_name_prefix ? null : var.name
  description = var.description
  values      = var.values

  datastore {
    type    = var.datastore_type
    version = var.datastore_version
  }

  lifecycle {
    create_before_destroy = true
  }
}
