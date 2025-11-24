output "id" {
  description = "The read replica instance ID"
  value       = huaweicloud_rds_read_replica_instance.this.id
}

output "status" {
  description = "The read replica instance status"
  value       = huaweicloud_rds_read_replica_instance.this.status
}

output "type" {
  description = "The type of the read replica instance"
  value       = huaweicloud_rds_read_replica_instance.this.type
}

output "private_ips" {
  description = "The private IP address list of the read replica"
  value       = huaweicloud_rds_read_replica_instance.this.private_ips
}

output "public_ips" {
  description = "The public IP address list of the read replica"
  value       = huaweicloud_rds_read_replica_instance.this.public_ips
}

output "subnet_id" {
  description = "The subnet ID of the read replica"
  value       = huaweicloud_rds_read_replica_instance.this.subnet_id
}

output "vpc_id" {
  description = "The VPC ID of the read replica"
  value       = huaweicloud_rds_read_replica_instance.this.vpc_id
}

output "db_type" {
  description = "The database engine type"
  value       = huaweicloud_rds_read_replica_instance.this.db[0].type
}

output "db_version" {
  description = "The database version"
  value       = huaweicloud_rds_read_replica_instance.this.db[0].version
}

output "db_user_name" {
  description = "The default username of the database"
  value       = huaweicloud_rds_read_replica_instance.this.db[0].user_name
}

output "port" {
  description = "The database port"
  value       = huaweicloud_rds_read_replica_instance.this.db[0].port
}

output "volume_disk_encryption_id" {
  description = "The key ID for disk encryption (same as primary instance)"
  value       = huaweicloud_rds_read_replica_instance.this.volume[0].disk_encryption_id
}
