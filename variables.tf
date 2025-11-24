################################################################################
# General
################################################################################

variable "create" {
  description = "Whether to create RDS resources"
  type        = bool
  default     = true
}

variable "region" {
  description = "The Huawei Cloud region where resources will be created. If not specified, the region configured in the provider will be used"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "db_instance_tags" {
  description = "Additional tags for the DB instance"
  type        = map(string)
  default     = {}
}

variable "db_parameter_group_tags" {
  description = "Additional tags for the DB parameter group"
  type        = map(string)
  default     = {}
}

################################################################################
# DB Instance
################################################################################

variable "create_db_instance" {
  description = "Whether to create a database instance"
  type        = bool
  default     = true
}

variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}

variable "use_identifier_prefix" {
  description = "Determines whether to use `identifier` as is or create a unique identifier beginning with `identifier` as the specified prefix"
  type        = bool
  default     = false
}

variable "engine" {
  description = "The database engine to use. Currently supported: mysql, postgres, sqlserver"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The engine version to use. For MySQL: 5.7, 8.0; For PostgreSQL: 12, 13, 14; For SQL Server: 2017_SE, 2019_SE"
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance. Example: rds.mysql.n1.large.2, rds.pg.n1.large.2. See Huawei Cloud documentation for available flavors"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the DB instance will be created"
  type        = string
}

variable "subnet_id" {
  description = "The network ID of a subnet. The subnet must belong to the VPC specified by vpc_id"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to associate with the DB instance"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones for the DB instance. Single element for single instance, two elements for primary/standby configuration"
  type        = list(string)
}

variable "ha_replication_mode" {
  description = "Specifies the replication mode for the standby DB instance. Valid values: 'async' (asynchronous replication), 'semisync' (semi-synchronous replication). Only applicable when availability_zones has 2 elements"
  type        = string
  default     = null
}

################################################################################
# DB Authentication & Access
################################################################################

variable "password" {
  description = "Password for the master DB user. Must be 8-32 characters long and contain at least three types: uppercase letters, lowercase letters, digits, and special characters"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "The port on which the DB accepts connections. If not specified, defaults to engine default (MySQL: 3306, PostgreSQL: 5432, SQL Server: 1433)"
  type        = number
  default     = null
}

variable "publicly_accessible" {
  description = "Whether the DB instance is publicly accessible. Currently not supported by Huawei Cloud RDS, included for future compatibility"
  type        = bool
  default     = false
}

################################################################################
# Storage
################################################################################

variable "storage_type" {
  description = "Specifies the storage type of the DB instance. Valid values: 'ULTRAHIGH' (ultra-high I/O SSD, recommended for high performance), 'LOCALSSD' (local SSD, ultra-low latency), 'CLOUDSSD' (cloud SSD, general purpose), 'ESSD' (extreme SSD, highest performance)"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes. Must be a multiple of 10. Minimum: 40 GB for MySQL/PostgreSQL, 20 GB for SQL Server. Maximum: 4000 GB"
  type        = number
}

variable "max_allocated_storage" {
  description = "Specifies the upper limit for storage autoscaling in GB. When set, storage will automatically expand when usage exceeds threshold. Must be greater than allocated_storage"
  type        = number
  default     = null
}

variable "storage_autoscaling_threshold" {
  description = "The threshold percentage to trigger automatic storage expansion. Valid values: 10, 15, 20. When available storage drops to this threshold or 10 GB (whichever is reached first), autoscaling triggers"
  type        = number
  default     = null
}

variable "kms_key_id" {
  description = "The KMS key ID for disk encryption. If not specified, encryption is disabled. Changing this parameter will create a new resource"
  type        = string
  default     = null
}

################################################################################
# Backup & Maintenance
################################################################################

variable "backup_retention_period" {
  description = "The days to retain automated backups. Valid values: 0-732. Setting to 0 disables automated backups"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created. Format: 'hh:mm-HH:MM'. Example: '08:00-09:00'. Must be a 1-hour window"
  type        = string
  default     = "08:00-09:00"
}

variable "backup_period" {
  description = "The backup cycle for automated backups. Comma-separated day numbers where 1=Monday, 7=Sunday. Example: '1,2,3,4,5' for weekdays. If not specified, provider default is used"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true, no snapshot is created. If false, a snapshot is created before deletion"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix for the final snapshot name when the instance is destroyed. Final snapshot will be named as '{prefix}-{identifier}-{timestamp}'"
  type        = string
  default     = "final"
}

variable "maintenance_window" {
  description = "The maintenance window for the DB instance. Format: 'HH:MM-HH:MM'. Example: '02:00-06:00'. If not specified, Huawei Cloud assigns a default window"
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately or during the next maintenance window"
  type        = bool
  default     = false
}

################################################################################
# DB Parameter Group
################################################################################

variable "create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
  default     = true
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate or create. If not specified, defaults to '{identifier}-pg'"
  type        = string
  default     = null
}

variable "parameter_group_use_name_prefix" {
  description = "Determines whether to use `parameter_group_name` as is or create a unique name beginning with the `parameter_group_name` as the prefix"
  type        = bool
  default     = false
}

variable "parameter_group_description" {
  description = "Description of the DB parameter group to create"
  type        = string
  default     = null
}

variable "parameters" {
  description = "A map of DB parameters to apply. Key is parameter name, value is parameter value. Example: { character_set_server = 'utf8mb4', max_connections = '1000' }"
  type        = map(string)
  default     = {}
}

variable "family" {
  description = "The family/version of the DB parameter group. For MySQL: '5.7' or '8.0'. For PostgreSQL: '12', '13', '14'. For SQL Server: '2017_SE', '2019_SE'"
  type        = string
  default     = null
}

variable "parameter_group_id" {
  description = "The ID of an existing parameter group to associate with the DB instance. If specified, create_db_parameter_group will be ignored"
  type        = string
  default     = null
}

variable "parameter_group_skip_destroy" {
  description = "Set to true if you do not wish the parameter group to be deleted at destroy time, and instead just remove the parameter group from the Terraform state"
  type        = bool
  default     = false
}

################################################################################
# MySQL-specific Settings
################################################################################

variable "character_set_name" {
  description = "The character set name to use for DB encoding in MySQL instances. Common values: 'utf8', 'utf8mb4'. This can only be set on creation"
  type        = string
  default     = null
}

variable "lower_case_table_names" {
  description = "MySQL lower_case_table_names parameter. Valid values: '0' (case-sensitive), '1' (case-insensitive, default). This is a ForceNew parameter and requires instance recreation if changed"
  type        = string
  default     = null
}

variable "ssl_enable" {
  description = "Whether to enable SSL encryption for MySQL connections. When enabled, clients must use SSL to connect"
  type        = bool
  default     = null
}

variable "binlog_retention_hours" {
  description = "Specifies the binlog retention period in hours for MySQL databases. Valid range: 0-168 (7 days). This parameter is critical for point-in-time recovery and replication"
  type        = number
  default     = null
}

################################################################################
# Advanced Instance Settings
################################################################################

variable "enterprise_project_id" {
  description = "The enterprise project ID for the RDS instance. Used for project-based resource management in large organizations"
  type        = string
  default     = null
}

variable "fixed_ip" {
  description = "Specifies a fixed intranet floating IP address for the RDS instance. The IP will remain unchanged across restarts and maintenance"
  type        = string
  default     = null
}

variable "monitoring_interval" {
  description = "Specifies the seconds-level monitoring interval. Valid values: 0 (disabled), 1, 5. When set to 1 or 5, detailed metrics are collected at the specified interval. May incur additional costs"
  type        = number
  default     = 0
}

variable "auto_minor_version_upgrade" {
  description = "Specifies whether to enable automatic minor version upgrades during the maintenance window. Minor version upgrades include security patches and bug fixes"
  type        = bool
  default     = false
}

variable "private_dns_name_prefix" {
  description = "Specifies the prefix of the private domain name. The value contains 8 to 64 characters. Only uppercase letters, lowercase letters, and digits are allowed. This is a ForceNew parameter"
  type        = string
  default     = null
}

variable "slow_log_show_original_status" {
  description = "Specifies whether to show the original SQL statement in slow logs. Only MySQL and PostgreSQL are supported. Valid values: 'on', 'off'. Default is 'off'"
  type        = string
  default     = null
}

variable "read_write_permissions" {
  description = "Specifies the read-write permissions of the RDS instance. Valid values: 'readwrite' (default, allows both read and write operations), 'readonly' (only allows read operations)"
  type        = string
  default     = null
}

variable "switch_strategy" {
  description = "Specifies the database switchover strategy for HA instances. Valid values: 'reliability' (prioritizes data consistency, default), 'availability' (prioritizes service availability, faster failover)"
  type        = string
  default     = null
}

################################################################################
# Transparent Data Encryption (TDE)
################################################################################

variable "tde_enabled" {
  description = "Specifies whether to enable TDE (Transparent Data Encryption) for the instance. WARNING: TDE cannot be disabled after being enabled. Only supported for MySQL 5.7 and 8.0"
  type        = bool
  default     = null
}

variable "tde_rotate_day" {
  description = "Specifies the key rotation interval for TDE in days. Required when tde_enabled is true. Valid range: 1-365 days"
  type        = number
  default     = null
}

variable "tde_secret_id" {
  description = "Specifies the ID of the key in KMS for TDE. Required when tde_enabled is true"
  type        = string
  default     = null
}

variable "tde_secret_name" {
  description = "Specifies the name of the key in KMS for TDE. Required when tde_enabled is true"
  type        = string
  default     = null
}

variable "tde_secret_version" {
  description = "Specifies the version of the key in KMS for TDE. Required when tde_enabled is true"
  type        = string
  default     = null
}

################################################################################
# Billing Configuration
################################################################################

variable "charging_mode" {
  description = "Specifies the charging mode of the RDS instance. Valid values: 'prePaid' (yearly/monthly subscription), 'postPaid' (pay-per-use, default). This is a ForceNew parameter"
  type        = string
  default     = "postPaid"
}

variable "period_unit" {
  description = "Specifies the charging period unit. Required when charging_mode is 'prePaid'. Valid values: 'month', 'year'"
  type        = string
  default     = null
}

variable "period" {
  description = "Specifies the charging period. Required when charging_mode is 'prePaid'. Valid values: 1-9 (when period_unit is 'month'), 1-3 (when period_unit is 'year')"
  type        = number
  default     = null
}

variable "auto_renew" {
  description = "Specifies whether to automatically renew the prepaid instance. Only valid when charging_mode is 'prePaid'. Valid values: 'true', 'false'"
  type        = string
  default     = null
}

################################################################################
# MySQL Database & User Management (Optional)
################################################################################

variable "create_mysql_objects" {
  description = "Whether to create MySQL database, user account, and privileges. Only supported for MySQL engine"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "The name of the database to create. Required when create_db_objects is true. For MySQL: 1-64 characters, alphanumeric and underscores only"
  type        = string
  default     = null
}

variable "db_character_set" {
  description = "The character set for the database. For MySQL: 'utf8', 'utf8mb4', 'gbk'. For PostgreSQL: 'UTF8', 'SQL_ASCII', etc. If not specified, defaults to 'utf8mb4' for MySQL and 'UTF8' for PostgreSQL"
  type        = string
  default     = null
}

variable "db_description" {
  description = "The description of the database"
  type        = string
  default     = null
}

variable "username" {
  description = "The username for the database account to create. Required when create_db_objects is true. For MySQL: 1-32 characters, must start with a letter"
  type        = string
  default     = null
}

variable "user_password" {
  description = "The password for the database user account. Required when create_db_objects is true. Must meet the same requirements as the master password"
  type        = string
  default     = null
  sensitive   = true
}

variable "user_description" {
  description = "The description of the database user account. 1-512 characters"
  type        = string
  default     = null
}

variable "user_readonly" {
  description = "Whether to grant read-only privileges to the user on the created database. If false, full read/write privileges are granted"
  type        = bool
  default     = false
}

variable "mysql_user_hosts" {
  description = "List of allowed host patterns for the MySQL user. Examples: ['%'] (any host), ['10.0.0.%'] (specific subnet). Default: ['%']. MySQL-specific parameter"
  type        = list(string)
  default     = ["%"]
}

################################################################################
# PostgreSQL Database & User Management (Optional)
################################################################################

variable "create_pg_objects" {
  description = "Whether to create PostgreSQL database, user account, and privileges. Only supported for PostgreSQL engine"
  type        = bool
  default     = false
}

variable "postgres_db_owner" {
  description = "The database user that owns the PostgreSQL database. Must be an existing username and different from system usernames. If not specified, uses the username variable. PostgreSQL-specific parameter"
  type        = string
  default     = null
}

variable "postgres_db_template" {
  description = "The name of the database template. Valid values: template0, template1. Defaults to template1. PostgreSQL-specific parameter"
  type        = string
  default     = "template1"
}

variable "postgres_db_lc_collate" {
  description = "The database collation. Defaults to en_US.UTF-8. PostgreSQL-specific parameter"
  type        = string
  default     = "en_US.UTF-8"
}

variable "postgres_db_lc_ctype" {
  description = "The database classification. Defaults to en_US.UTF-8. PostgreSQL-specific parameter"
  type        = string
  default     = "en_US.UTF-8"
}

variable "postgres_db_is_revoke_public_privilege" {
  description = "Whether to revoke the PUBLIC CREATE permission of the public schema. Defaults to false. PostgreSQL-specific parameter"
  type        = bool
  default     = false
}

variable "postgres_user_schema_name" {
  description = "The name of the schema for the PostgreSQL database privilege. Defaults to 'public'. PostgreSQL-specific parameter"
  type        = string
  default     = "public"
}

variable "postgres_schemas" {
  description = <<-EOF
    List of PostgreSQL schemas to create in the database. Each schema can have an owner.

    Example:
    [
      {
        name  = "app_schema"
        owner = "appuser"
      },
      {
        name  = "reporting_schema"
        owner = "reportuser"
      }
    ]
  EOF
  type = list(object({
    name  = string
    owner = optional(string)
  }))
  default = []
}

variable "postgres_account_roles" {
  description = <<-EOF
    List of role assignments for PostgreSQL accounts. Assigns user roles to accounts.
    For example, you can grant one user the role of another user.

    Example:
    [
      {
        user  = "appuser"
        roles = ["readonly_role", "reporting_role"]
      },
      {
        user  = "adminuser"
        roles = ["superadmin"]
      }
    ]
  EOF
  type = list(object({
    user  = string
    roles = list(string)
  }))
  default = []
}

variable "postgres_account_privileges" {
  description = <<-EOF
    List of privilege configurations for PostgreSQL accounts.
    Grants role privileges like CREATEDB, CREATEROLE, LOGIN, REPLICATION
    and system role privileges like pg_monitor, pg_signal_backend, root.

    Example:
    [
      {
        user                   = "appuser"
        role_privileges        = ["LOGIN", "CREATEDB"]
        system_role_privileges = ["pg_monitor"]
      },
      {
        user                   = "replicauser"
        role_privileges        = ["LOGIN", "REPLICATION"]
        system_role_privileges = ["pg_signal_backend"]
      }
    ]
  EOF
  type = list(object({
    user                   = string
    role_privileges        = optional(list(string), [])
    system_role_privileges = optional(list(string), [])
  }))
  default = []
}

variable "postgres_plugins" {
  description = <<-EOF
    List of PostgreSQL plugins to enable on databases. Each plugin must be enabled on a specific database.

    Example:
    [
      {
        database_name = "mydb"
        name          = "pgaudit"
      },
      {
        database_name = "mydb"
        name          = "pg_stat_statements"
      }
    ]

    Note: The database must exist before plugins can be added. If using create_pg_objects,
    you can reference var.db_name for the database created by this module.
  EOF
  type = list(object({
    database_name = string
    name          = string
  }))
  default = []
}

variable "postgres_plugin_parameters" {
  description = <<-EOF
    List of PostgreSQL plugin parameters to configure at the instance level.
    These are instance-level parameters that affect plugin behavior.

    Example:
    [
      {
        name   = "shared_preload_libraries"
        values = ["pg_stat_kcache", "pg_stat_statements"]
      }
    ]

    Note: Plugin parameters are configured at the instance level, not per database.
    Some plugins may require specific parameters to be set before they can be enabled.
  EOF
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []
}

variable "enable_public_access" {
  description = <<-EOF
    Whether to enable public access to the RDS instance by associating an EIP.
    When enabled, an EIP will be created and associated with the RDS instance.
  EOF
  type        = bool
  default     = false
}

variable "eip_type" {
  description = "The EIP type. Possible values are 5_bgp (dynamic BGP) and 5_sbgp (static BGP)"
  type        = string
  default     = "5_bgp"
}

variable "eip_bandwidth_name" {
  description = "The bandwidth name for the EIP. Required when enable_public_access is true"
  type        = string
  default     = null
}

variable "eip_bandwidth_size" {
  description = "The bandwidth size in Mbit/s. Value ranges from 1 to 300"
  type        = number
  default     = 10
}

variable "eip_bandwidth_charge_mode" {
  description = "Specifies whether the bandwidth is billed by traffic or bandwidth. Valid values are traffic and bandwidth"
  type        = string
  default     = "traffic"
}

################################################################################
# Read Replica Configuration
################################################################################

variable "create_read_replica" {
  description = "Whether to create a read replica instance. Requires a primary instance to be created first"
  type        = bool
  default     = false
}

variable "replicate_source_db" {
  description = "Specifies the identifier of the source DB instance from which to create the read replica. If not specified, uses the primary instance created by this module"
  type        = string
  default     = null
}

variable "replica_identifier" {
  description = "The identifier for the read replica instance. If not provided, defaults to '{identifier}-replica'"
  type        = string
  default     = null
}

variable "replica_instance_class" {
  description = "The instance class (flavor) for the read replica. Must use .rr suffix for read replicas (e.g., rds.mysql.n1.large.2.rr). If not specified, uses the same as primary instance with .rr suffix"
  type        = string
  default     = null
}

variable "replica_allocated_storage" {
  description = "The allocated storage size for the read replica in GB. Must be >= primary instance size. If not specified, uses primary instance size"
  type        = number
  default     = null
}

variable "replica_max_allocated_storage" {
  description = "Upper limit for automatic storage expansion for the read replica in GB"
  type        = number
  default     = null
}

variable "replica_storage_autoscaling_threshold" {
  description = "Storage autoscaling threshold for the read replica. Valid values: 10, 15, 20"
  type        = number
  default     = null
}

variable "replica_availability_zones" {
  description = "List of availability zones for the read replica. If not specified, uses the same as primary instance"
  type        = list(string)
  default     = null
}

variable "replica_security_group_id" {
  description = "Security group ID for the read replica. If not specified, uses the same as primary instance"
  type        = string
  default     = null
}

variable "replica_fixed_ip" {
  description = "Fixed intranet floating IP address for the read replica"
  type        = string
  default     = null
}

variable "replica_maintenance_window" {
  description = "Maintenance window for the read replica in format 'HH:mm-HH:mm'. If not specified, uses a different window than primary to avoid conflicts"
  type        = string
  default     = null
}

variable "replica_parameters" {
  description = "A map of parameters to apply to the read replica instance"
  type        = map(string)
  default     = {}
}

variable "replica_tags" {
  description = "A map of tags to assign to the read replica instance (merged with var.tags)"
  type        = map(string)
  default     = {}
}

################################################################################
# Timeouts
################################################################################

variable "timeouts" {
  description = "Updated Terraform resource management timeouts. Applies to `huaweicloud_rds_instance` in particular to permit resource management times"
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

