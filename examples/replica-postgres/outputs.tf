################################################################################
# Master DB
################################################################################

output "master_db_instance_id" {
  description = "The master database instance ID"
  value       = module.master.db_instance_id
}

output "master_db_instance_endpoint" {
  description = "The connection endpoint for the master database"
  value       = module.master.db_instance_endpoint
}

output "master_db_instance_status" {
  description = "The status of the master database instance"
  value       = module.master.db_instance_status
}

################################################################################
# Replica DB
################################################################################

output "replica_db_instance_id" {
  description = "The replica database instance ID"
  value       = module.replica.db_read_replica_id
}

output "replica_db_instance_endpoint" {
  description = "The connection endpoint for the replica database"
  value       = module.replica.db_read_replica_endpoint
}

output "replica_db_instance_status" {
  description = "The status of the replica database instance"
  value       = module.replica.db_read_replica_status
}

################################################################################
# Supporting Resources
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.security_group_id
}
