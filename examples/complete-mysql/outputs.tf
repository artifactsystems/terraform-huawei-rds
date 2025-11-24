################################################################################
# DB Instance
################################################################################

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db.db_instance_address
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db.db_instance_endpoint
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db.db_instance_id
}

output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = module.db.db_instance_identifier
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.db.db_instance_status
}

output "db_instance_port" {
  description = "The database port"
  value       = module.db.db_instance_port
}

output "db_instance_engine" {
  description = "The database engine"
  value       = module.db.db_instance_engine
}

output "db_instance_engine_version" {
  description = "The running version of the database"
  value       = module.db.db_instance_engine_version
}

################################################################################
# DB Parameter Group
################################################################################

output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.db.db_parameter_group_id
}

output "db_parameter_group_name" {
  description = "The db parameter group name"
  value       = module.db.db_parameter_group_name
}

################################################################################
# MySQL Database Objects
################################################################################

output "db_database_id" {
  description = "The ID of the created MySQL database (format: instance_id/db_name)"
  value       = module.db.db_database_id
}

output "db_database_name" {
  description = "The name of the created MySQL database"
  value       = module.db.db_database_name
}

output "db_account_id" {
  description = "The ID of the created MySQL account (format: instance_id/username)"
  value       = module.db.db_account_id
}

output "db_account_name" {
  description = "The name of the created MySQL account"
  value       = module.db.db_account_name
}

################################################################################
# Supporting Resources
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}
