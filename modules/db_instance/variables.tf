variable "name" {
  description = "The name of the RDS instance"
  type        = string
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix"
  type        = bool
  default     = false
}

variable "flavor" {
  description = "The instance type of the RDS instance (e.g., rds.mysql.n1.large.2)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones. 1=Single, 2=Primary/Standby"
  type        = list(string)
}

variable "engine" {
  description = "Database engine type. Valid values: mysql, postgres, sqlserver"
  type        = string
}

variable "engine_version" {
  description = "Database engine version (e.g., MySQL: 5.7, 8.0; PostgreSQL: 12, 13, 14)"
  type        = string
}

variable "db_password" {
  description = "Default database password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Database port (optional, defaults to engine default)"
  type        = number
  default     = null
}

variable "volume_type" {
  description = "Volume type: ULTRAHIGH | LOCALSSD | CLOUDSSD | ESSD"
  type        = string
}

variable "volume_size" {
  description = "Volume size in GB (multiple of 10)"
  type        = number
}

variable "volume_limit_size" {
  description = "Upper limit for automatic storage expansion in GB (optional)"
  type        = number
  default     = null
}

variable "volume_trigger_threshold" {
  description = "Threshold to trigger automatic storage expansion. Valid values: 10, 15, 20"
  type        = number
  default     = null
}

variable "disk_encryption_id" {
  description = "KMS key ID for disk encryption. If not specified, encryption is disabled. Changing this parameter will create a new resource"
  type        = string
  default     = null
}

variable "backup_keep_days" {
  description = "Automated backup retention days (0-732)"
  type        = number
  default     = 7
}

variable "backup_start_time" {
  description = "Backup time window (hh:mm-HH:MM, UTC)"
  type        = string
  default     = "08:00-09:00"
}

variable "backup_period" {
  description = "Backup cycle (comma-separated numbers 1-7)"
  type        = string
  default     = null
}

variable "ha_replication_mode" {
  description = "MySQL HA replication mode: null | async | semisync"
  type        = string
  default     = null
}

variable "param_group_id" {
  description = "Existing parameter group ID (optional)"
  type        = string
  default     = null
}

variable "maintain_begin" {
  description = "Maintenance window begin time (HH:MM)"
  type        = string
  default     = null
}

variable "maintain_end" {
  description = "Maintenance window end time (HH:MM)"
  type        = string
  default     = null
}

variable "lower_case_table_names" {
  description = "MySQL lower_case_table_names (ForceNew). 0 or 1; default 1"
  type        = string
  default     = null
}

variable "ssl_enable" {
  description = "Enable SSL for MySQL"
  type        = bool
  default     = null
}

variable "binlog_retention_hours" {
  description = "Binlog retention period in hours for MySQL (0-168)"
  type        = number
  default     = null
}

variable "enterprise_project_id" {
  description = "Enterprise project ID"
  type        = string
  default     = null
}

variable "fixed_ip" {
  description = "Fixed intranet floating IP address"
  type        = string
  default     = null
}

variable "seconds_level_monitoring_enabled" {
  description = "Whether to enable seconds level monitoring"
  type        = bool
  default     = null
}

variable "seconds_level_monitoring_interval" {
  description = "Seconds level monitoring interval. Valid values: 1, 5"
  type        = number
  default     = null
}

variable "minor_version_auto_upgrade_enabled" {
  description = "Whether to enable minor version auto upgrade"
  type        = bool
  default     = null
}

variable "private_dns_name_prefix" {
  description = "Prefix of the private domain name (8-64 characters)"
  type        = string
  default     = null
}

variable "slow_log_show_original_status" {
  description = "Show original SQL statement in slow logs. Valid values: on, off"
  type        = string
  default     = null
}

variable "read_write_permissions" {
  description = "Read-write permissions. Valid values: readwrite, readonly"
  type        = string
  default     = null
}

variable "switch_strategy" {
  description = "Database switchover strategy. Valid values: reliability, availability"
  type        = string
  default     = null
}

variable "tde_enabled" {
  description = "Whether to enable TDE"
  type        = bool
  default     = null
}

variable "tde_rotate_day" {
  description = "TDE key rotation interval in days (1-365)"
  type        = number
  default     = null
}

variable "tde_secret_id" {
  description = "KMS key ID for TDE"
  type        = string
  default     = null
}

variable "tde_secret_name" {
  description = "KMS key name for TDE"
  type        = string
  default     = null
}

variable "tde_secret_version" {
  description = "KMS key version for TDE"
  type        = string
  default     = null
}

variable "charging_mode" {
  description = "Charging mode. Valid values: prePaid, postPaid"
  type        = string
  default     = "postPaid"
}

variable "period_unit" {
  description = "Charging period unit. Valid values: month, year"
  type        = string
  default     = null
}

variable "period" {
  description = "Charging period (1-9 for month, 1-3 for year)"
  type        = number
  default     = null
}

variable "auto_renew" {
  description = "Whether to auto renew prepaid instance"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the RDS instance"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Updated Terraform resource management timeouts"
  type        = map(string)
  default     = {}
}

################################################################################
# LTS (Log Tank Service) Configuration
################################################################################

variable "enable_lts_logs" {
  description = "Enable LTS (Log Tank Service) logging for RDS instance. Equivalent to AWS enabled_cloudwatch_logs_exports"
  type        = bool
  default     = false
}

variable "lts_log_configs" {
  description = <<-EOF
    List of LTS log configurations. Each log type (error_log, slow_log, audit_log)
    requires a separate LTS group and stream.

    Example:
    [
      {
        log_type      = "error_log"
        lts_group_id  = "log-group-id-1"
        lts_stream_id = "log-stream-id-1"
      },
      {
        log_type      = "slow_log"
        lts_group_id  = "log-group-id-2"
        lts_stream_id = "log-stream-id-2"
      }
    ]
  EOF
  type = list(object({
    log_type      = string
    lts_group_id  = string
    lts_stream_id = string
  }))
  default = []
}

variable "lts_timeouts" {
  description = "Timeout configuration for LTS resources"
  type        = map(string)
  default     = {}
}

################################################################################
# SQL Audit Configuration
################################################################################

variable "enable_sql_audit" {
  description = "Enable SQL audit logging. Equivalent to AWS audit option in option_group"
  type        = bool
  default     = false
}

variable "sql_audit_keep_days" {
  description = "Number of days to retain SQL audit logs. Valid range: 7-732 days"
  type        = number
  default     = 7
}

variable "sql_audit_reserve_auditlogs" {
  description = "Whether to reserve audit logs when SQL audit is disabled"
  type        = bool
  default     = false
}

