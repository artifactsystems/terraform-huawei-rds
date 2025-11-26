output "id" {
  description = "Parameter group ID"
  value       = huaweicloud_rds_parametergroup.this.id
}

output "name" {
  description = "Parameter group name"
  value       = huaweicloud_rds_parametergroup.this.name
}

output "datastore" {
  description = "Datastore type and version"
  value = {
    type    = var.datastore_type
    version = var.datastore_version
  }
}
