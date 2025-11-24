output "id" {
  description = "The RDS instance ID"
  value       = huaweicloud_rds_instance.this.id
}

output "name" {
  description = "The RDS instance name"
  value       = huaweicloud_rds_instance.this.name
}

output "status" {
  description = "The RDS instance status"
  value       = huaweicloud_rds_instance.this.status
}

output "port" {
  description = "The database port"
  value       = huaweicloud_rds_instance.this.db[0].port
}

output "engine" {
  description = "The database engine"
  value       = huaweicloud_rds_instance.this.db[0].type
}

output "engine_version" {
  description = "The database engine version"
  value       = var.engine_version
}

output "private_ips" {
  description = "List of private IP addresses of the RDS instance"
  value       = huaweicloud_rds_instance.this.private_ips
}

output "private_dns_names" {
  description = "List of private DNS names of the RDS instance"
  value       = huaweicloud_rds_instance.this.private_dns_names
}

output "vpc_id" {
  description = "The VPC ID where the instance is located"
  value       = var.vpc_id
}

output "subnet_id" {
  description = "The subnet ID where the instance is located"
  value       = var.subnet_id
}

output "security_group_id" {
  description = "The security group ID associated with the instance"
  value       = var.security_group_id
}

output "param_group_id" {
  description = "The parameter group ID used by the instance"
  value       = var.param_group_id
}

################################################################################
# LTS (Log Tank Service) Outputs
################################################################################

output "lts_configs" {
  description = "Map of LTS log configurations created and their attributes"
  value = {
    for log_type, config in huaweicloud_rds_lts_config.this : log_type => {
      id            = config.id
      instance_id   = config.instance_id
      log_type      = config.log_type
      lts_group_id  = config.lts_group_id
      lts_stream_id = config.lts_stream_id
    }
  }
}

################################################################################
# SQL Audit Outputs
################################################################################

output "sql_audit_id" {
  description = "The SQL audit configuration ID"
  value       = try(huaweicloud_rds_sql_audit.this[0].id, null)
}

output "sql_audit_enabled" {
  description = "Whether SQL audit is enabled"
  value       = var.enable_sql_audit
}

output "sql_audit_keep_days" {
  description = "SQL audit log retention period in days"
  value       = var.enable_sql_audit ? var.sql_audit_keep_days : null
}

