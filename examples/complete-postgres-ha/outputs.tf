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
  description = "HA replication mode (async or sync)"
  value       = "async" # Set in main.tf
}

################################################################################
# KMS / Disk Encryption
################################################################################

output "kms_key_id" {
  description = "The KMS key ID used for disk encryption"
  value       = module.dew.key_id
}

