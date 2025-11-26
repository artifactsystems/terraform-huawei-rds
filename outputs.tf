################################################################################
# DB Instance
################################################################################

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = try(module.db_instance[0].id, null)
}

output "db_instance_identifier" {
  description = "The RDS instance identifier (name)"
  value       = try(module.db_instance[0].name, null)
}

output "db_instance_address" {
  description = "The hostname/address of the RDS instance. Use private_ips for connection"
  value       = try(module.db_instance[0].private_ips[0], null)
}

output "db_instance_endpoint" {
  description = "The connection endpoint in address:port format"
  value       = try("${module.db_instance[0].private_ips[0]}:${module.db_instance[0].port}", null)
}

output "db_instance_port" {
  description = "The database port"
  value       = try(module.db_instance[0].port, null)
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = try(module.db_instance[0].status, null)
}

output "db_instance_private_ips" {
  description = "List of private IP addresses assigned to the RDS instance"
  value       = try(module.db_instance[0].private_ips, [])
}

output "db_instance_private_dns_names" {
  description = "List of private DNS names assigned to the RDS instance"
  value       = try(module.db_instance[0].private_dns_names, [])
}

output "db_instance_engine" {
  description = "The database engine"
  value       = var.engine
}

output "db_instance_engine_version" {
  description = "The running version of the database"
  value       = var.engine_version
}

################################################################################
# DB Parameter Group
################################################################################

output "db_parameter_group_id" {
  description = "The ID of the DB parameter group"
  value       = try(module.db_parameter_group[0].id, var.parameter_group_id)
}

output "db_parameter_group_name" {
  description = "The name of the DB parameter group"
  value       = try(module.db_parameter_group[0].name, null)
}

################################################################################
# MySQL Database Objects
################################################################################

output "db_database_id" {
  description = "The ID of the created MySQL database (format: instance_id/db_name)"
  value       = try(huaweicloud_rds_mysql_database.this[0].id, null)
}

output "db_database_name" {
  description = "The name of the created MySQL database"
  value       = try(huaweicloud_rds_mysql_database.this[0].name, null)
}

output "db_account_id" {
  description = "The ID of the created MySQL account (format: instance_id/username)"
  value       = try(huaweicloud_rds_mysql_account.this[0].id, null)
}

output "db_account_name" {
  description = "The name of the created MySQL account"
  value       = try(huaweicloud_rds_mysql_account.this[0].name, null)
}

################################################################################
# PostgreSQL Database Objects
################################################################################

output "pg_database_id" {
  description = "The ID of the created PostgreSQL database (format: instance_id/db_name)"
  value       = try(huaweicloud_rds_pg_database.this[0].id, null)
}

output "pg_database_name" {
  description = "The name of the created PostgreSQL database"
  value       = try(huaweicloud_rds_pg_database.this[0].name, null)
}

output "pg_database_size" {
  description = "The size of the PostgreSQL database in bytes"
  value       = try(huaweicloud_rds_pg_database.this[0].size, null)
}

output "pg_account_id" {
  description = "The ID of the created PostgreSQL account (format: instance_id/username)"
  value       = try(huaweicloud_rds_pg_account.this[0].id, null)
}

output "pg_account_name" {
  description = "The name of the created PostgreSQL account"
  value       = try(huaweicloud_rds_pg_account.this[0].name, null)
}

output "pg_schemas" {
  description = "Map of PostgreSQL schemas created"
  value = {
    for name, schema in huaweicloud_rds_pg_schema.this : name => {
      id          = schema.id
      schema_name = schema.schema_name
      owner       = schema.owner
    }
  }
}

output "pg_account_roles" {
  description = "Map of PostgreSQL account role assignments"
  value = {
    for user, roles in huaweicloud_rds_pg_account_roles.this : user => {
      id    = roles.id
      user  = roles.user
      roles = roles.roles
    }
  }
}

output "pg_account_privileges" {
  description = "Map of PostgreSQL account privileges"
  value = {
    for user, priv in huaweicloud_rds_pg_account_privileges.this : user => {
      id                     = priv.id
      user_name              = priv.user_name
      role_privileges        = priv.role_privileges
      system_role_privileges = priv.system_role_privileges
    }
  }
}

output "pg_plugins" {
  description = "Map of PostgreSQL plugins created on databases"
  value = {
    for key, plugin in huaweicloud_rds_pg_plugin.this : key => {
      id                       = plugin.id
      name                     = plugin.name
      database_name            = plugin.database_name
      version                  = plugin.version
      description              = plugin.description
      shared_preload_libraries = plugin.shared_preload_libraries
    }
  }
}

output "pg_plugin_parameters" {
  description = "Map of PostgreSQL plugin parameters configured at instance level"
  value = {
    for name, param in huaweicloud_rds_pg_plugin_parameter.this : name => {
      id               = param.id
      name             = param.name
      values           = param.values
      default_values   = param.default_values
      restart_required = param.restart_required
    }
  }
}

################################################################################
# EIP and Public Access
################################################################################

output "eip_id" {
  description = "The EIP ID associated with the RDS instance"
  value       = try(huaweicloud_vpc_eip.this[0].id, null)
}

output "eip_address" {
  description = "The public IP address of the EIP"
  value       = try(huaweicloud_vpc_eip.this[0].address, null)
}

output "eip_status" {
  description = "The status of the EIP"
  value       = try(huaweicloud_vpc_eip.this[0].status, null)
}

################################################################################
# Read Replica Instance
################################################################################

output "db_read_replica_id" {
  description = "The read replica instance ID"
  value       = try(module.db_read_replica[0].id, null)
}

output "db_read_replica_identifier" {
  description = "The read replica instance identifier (name)"
  value       = try(module.db_read_replica[0].id, null)
}

output "db_read_replica_address" {
  description = "The hostname/address of the read replica. Use private_ips for connection"
  value       = try(module.db_read_replica[0].private_ips[0], null)
}

output "db_read_replica_endpoint" {
  description = "The connection endpoint in address:port format for read replica"
  value       = try("${module.db_read_replica[0].private_ips[0]}:${module.db_read_replica[0].port}", null)
}

output "db_read_replica_port" {
  description = "The database port of the read replica"
  value       = try(module.db_read_replica[0].port, null)
}

output "db_read_replica_status" {
  description = "The read replica instance status"
  value       = try(module.db_read_replica[0].status, null)
}

output "db_read_replica_private_ips" {
  description = "List of private IP addresses assigned to the read replica"
  value       = try(module.db_read_replica[0].private_ips, [])
}

output "db_read_replica_type" {
  description = "The type of the read replica instance"
  value       = try(module.db_read_replica[0].type, null)
}

output "db_read_replica_vpc_id" {
  description = "The VPC ID of the read replica"
  value       = try(module.db_read_replica[0].vpc_id, null)
}

output "db_read_replica_subnet_id" {
  description = "The subnet ID of the read replica"
  value       = try(module.db_read_replica[0].subnet_id, null)
}

################################################################################
# LTS (Log Tank Service) Outputs
################################################################################

output "db_instance_lts_configs" {
  description = "Map of LTS log configurations created for the instance and their attributes"
  value       = try(module.db_instance[0].lts_configs, {})
}

################################################################################
# SQL Audit Outputs
################################################################################

output "db_instance_sql_audit_id" {
  description = "The SQL audit configuration ID"
  value       = try(module.db_instance[0].sql_audit_id, null)
}

output "db_instance_sql_audit_enabled" {
  description = "Whether SQL audit is enabled for the instance"
  value       = try(module.db_instance[0].sql_audit_enabled, false)
}

output "db_instance_sql_audit_keep_days" {
  description = "SQL audit log retention period in days"
  value       = try(module.db_instance[0].sql_audit_keep_days, null)
}
