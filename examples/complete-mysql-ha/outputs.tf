################################################################################
# DB Instance
################################################################################

output "db_instance_id" {
  description = "The ID of the RDS instance"
  value       = module.db.db_instance_id
}

output "db_instance_identifier" {
  description = "The identifier (name) of the RDS instance"
  value       = module.db.db_instance_identifier
}

output "db_instance_endpoint" {
  description = "The connection endpoint for the database"
  value       = module.db.db_instance_endpoint
}

output "db_instance_port" {
  description = "The database port"
  value       = module.db.db_instance_port
}

output "db_instance_status" {
  description = "The status of the RDS instance"
  value       = module.db.db_instance_status
}

output "db_instance_private_ips" {
  description = "The private IP addresses of the RDS instance"
  value       = module.db.db_instance_private_ips
}

################################################################################
# DB Parameter Group
################################################################################

output "db_parameter_group_id" {
  description = "The ID of the DB parameter group"
  value       = module.db.db_parameter_group_id
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
# Security Group
################################################################################

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.security_group_id
}

################################################################################
# VPC
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
  description = "List of IDs of database subnets (one for each AZ)"
  value       = module.vpc.database_subnets
}

################################################################################
# EIP
################################################################################

output "eip_id" {
  description = "The EIP ID associated with the RDS instance"
  value       = module.db.eip_id
}

output "eip_address" {
  description = "The public IP address of the RDS instance"
  value       = module.db.eip_address
}

output "eip_status" {
  description = "The status of the EIP"
  value       = module.db.eip_status
}

################################################################################
# HA Specific Outputs
################################################################################

output "availability_zones" {
  description = "List of availability zones used for Primary/Standby configuration"
  value       = local.azs
}

output "ha_replication_mode" {
  description = "HA replication mode (async or semisync)"
  value       = "async" # Set in main.tf
}

################################################################################
# KMS / Disk Encryption
################################################################################

output "kms_key_id" {
  description = "The KMS key ID used for disk encryption"
  value       = module.dew.key_id
}

################################################################################
# LTS
################################################################################

output "lts_log_group_id" {
  description = "The LTS log group ID"
  value       = module.lts.log_group_id
}

output "lts_log_stream_ids" {
  description = "Map of LTS log stream IDs"
  value       = module.lts.log_stream_ids
}
