locals {
  create_db_parameter_group = var.create_db_parameter_group && var.parameter_group_id == null && var.create
  create_db_instance        = var.create_db_instance && var.create
  create_mysql_objects      = var.create_mysql_objects && local.create_db_instance && var.engine == "mysql"
  create_pg_objects         = var.create_pg_objects && local.create_db_instance && var.engine == "postgres"
  create_read_replica       = var.create_read_replica && var.create

  # Conditional names
  parameter_group_name = local.create_db_parameter_group ? module.db_parameter_group[0].id : var.parameter_group_id
  family               = coalesce(var.family, var.engine_version)

  # Maintenance window parsing (if maintenance_window is provided, parse it; otherwise use null)
  maintenance_begin = var.maintenance_window != null ? split("-", var.maintenance_window)[0] : null
  maintenance_end   = var.maintenance_window != null ? split("-", var.maintenance_window)[1] : null

  # Read replica configuration
  replica_maintenance_begin = var.replica_maintenance_window != null ? split("-", var.replica_maintenance_window)[0] : null
  replica_maintenance_end   = var.replica_maintenance_window != null ? split("-", var.replica_maintenance_window)[1] : null

  # Primary instance ID for replica (use provided source or this module's instance)
  replica_source_db = coalesce(var.replicate_source_db, try(module.db_instance[0].id, null))

  # Replica flavor - add .rr suffix if not present
  replica_flavor_base = coalesce(var.replica_instance_class, var.instance_class)
  replica_flavor      = can(regex("\\.rr$", local.replica_flavor_base)) ? local.replica_flavor_base : "${local.replica_flavor_base}.rr"

  # Map engine names to Huawei Cloud parameter group datastore type
  parameter_group_datastore_type_map = {
    "mysql"     = "mysql"
    "postgres"  = "postgresql"
    "sqlserver" = "sqlserver"
  }

  parameter_group_datastore_type = lookup(local.parameter_group_datastore_type_map, lower(var.engine), "mysql")
}

################################################################################
# DB Parameter Group
################################################################################

module "db_parameter_group" {
  count  = local.create_db_parameter_group ? 1 : 0
  source = "./modules/db_parameter_group"

  name              = coalesce(var.parameter_group_name, "${var.identifier}-pg")
  use_name_prefix   = var.parameter_group_use_name_prefix
  description       = var.parameter_group_description
  values            = var.parameters
  datastore_type    = local.parameter_group_datastore_type
  datastore_version = local.family
}

################################################################################
# DB Instance
################################################################################

module "db_instance" {
  count  = local.create_db_instance ? 1 : 0
  source = "./modules/db_instance"

  name               = var.identifier
  use_name_prefix    = var.use_identifier_prefix
  flavor             = var.instance_class
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id
  security_group_id  = var.security_group_id
  availability_zones = var.availability_zones

  engine         = var.engine
  engine_version = var.engine_version
  db_password    = var.password
  db_port        = var.port

  volume_type              = var.storage_type
  volume_size              = var.allocated_storage
  volume_limit_size        = var.max_allocated_storage
  volume_trigger_threshold = var.storage_autoscaling_threshold
  disk_encryption_id       = var.kms_key_id

  backup_keep_days  = var.backup_retention_period
  backup_start_time = var.backup_window
  backup_period     = var.backup_period

  ha_replication_mode = var.ha_replication_mode

  param_group_id = local.parameter_group_name

  maintain_begin = local.maintenance_begin
  maintain_end   = local.maintenance_end

  lower_case_table_names = var.lower_case_table_names
  ssl_enable             = var.ssl_enable
  binlog_retention_hours = var.binlog_retention_hours

  enterprise_project_id              = var.enterprise_project_id
  fixed_ip                           = var.fixed_ip
  seconds_level_monitoring_enabled   = var.monitoring_interval > 0 ? true : null
  seconds_level_monitoring_interval  = var.monitoring_interval > 0 ? var.monitoring_interval : null
  minor_version_auto_upgrade_enabled = var.auto_minor_version_upgrade

  private_dns_name_prefix       = var.private_dns_name_prefix
  slow_log_show_original_status = var.slow_log_show_original_status
  read_write_permissions        = var.read_write_permissions
  switch_strategy               = var.switch_strategy

  tde_enabled        = var.tde_enabled
  tde_rotate_day     = var.tde_rotate_day
  tde_secret_id      = var.tde_secret_id
  tde_secret_name    = var.tde_secret_name
  tde_secret_version = var.tde_secret_version

  charging_mode = var.charging_mode
  period_unit   = var.period_unit
  period        = var.period
  auto_renew    = var.auto_renew

  tags = merge(var.tags, var.db_instance_tags)

  timeouts = var.timeouts

  # Monitoring and Logging
  enable_lts_logs             = var.enable_lts_logs
  lts_log_configs             = var.lts_log_configs
  lts_timeouts                = var.lts_timeouts
  enable_sql_audit            = var.enable_sql_audit
  sql_audit_keep_days         = var.sql_audit_keep_days
  sql_audit_reserve_auditlogs = var.sql_audit_reserve_auditlogs
}

################################################################################
# MySQL Database Objects
################################################################################

resource "huaweicloud_rds_mysql_database" "this" {
  count         = local.create_mysql_objects ? 1 : 0
  instance_id   = module.db_instance[0].id
  name          = var.db_name
  character_set = coalesce(var.db_character_set, "utf8mb4")
  description   = var.db_description

  lifecycle {
    precondition {
      condition     = var.db_name != null && trimspace(var.db_name) != ""
      error_message = "db_name must be provided when create_mysql_objects is true"
    }
  }
}

resource "huaweicloud_rds_mysql_account" "this" {
  count       = local.create_mysql_objects ? 1 : 0
  instance_id = module.db_instance[0].id
  name        = var.username
  password    = var.user_password
  hosts       = var.mysql_user_hosts
  description = var.user_description

  lifecycle {
    precondition {
      condition     = var.username != null && var.user_password != null
      error_message = "username and user_password must be provided when create_mysql_objects is true"
    }
  }
}

resource "huaweicloud_rds_mysql_database_privilege" "this" {
  count       = local.create_mysql_objects ? 1 : 0
  instance_id = module.db_instance[0].id
  db_name     = var.db_name

  users {
    name     = var.username
    readonly = var.user_readonly
  }

  depends_on = [
    huaweicloud_rds_mysql_database.this,
    huaweicloud_rds_mysql_account.this
  ]
}

################################################################################
# PostgreSQL Database Objects
################################################################################

resource "huaweicloud_rds_pg_database" "this" {
  count                      = local.create_pg_objects ? 1 : 0
  instance_id                = module.db_instance[0].id
  name                       = var.db_name
  owner                      = coalesce(var.postgres_db_owner, var.username)
  template                   = var.postgres_db_template
  character_set              = coalesce(var.db_character_set, "UTF8")
  lc_collate                 = var.postgres_db_lc_collate
  lc_ctype                   = var.postgres_db_lc_ctype
  is_revoke_public_privilege = var.postgres_db_is_revoke_public_privilege
  description                = var.db_description

  lifecycle {
    precondition {
      condition     = var.db_name != null && trimspace(var.db_name) != ""
      error_message = "db_name must be provided when create_pg_objects is true"
    }
  }

  depends_on = [huaweicloud_rds_pg_account.this]
}

resource "huaweicloud_rds_pg_account" "this" {
  count       = local.create_pg_objects ? 1 : 0
  instance_id = module.db_instance[0].id
  name        = var.username
  password    = var.user_password
  description = var.user_description

  lifecycle {
    precondition {
      condition     = var.username != null && var.user_password != null
      error_message = "username and user_password must be provided when create_pg_objects is true"
    }
  }
}

resource "huaweicloud_rds_pg_database_privilege" "this" {
  count       = local.create_pg_objects ? 1 : 0
  instance_id = module.db_instance[0].id
  db_name     = var.db_name

  users {
    name        = var.username
    readonly    = var.user_readonly
    schema_name = var.postgres_user_schema_name
  }

  depends_on = [
    huaweicloud_rds_pg_database.this,
    huaweicloud_rds_pg_account.this
  ]
}

# PostgreSQL Schema Management
resource "huaweicloud_rds_pg_schema" "this" {
  for_each = var.engine == "postgres" ? { for schema in var.postgres_schemas : schema.name => schema } : {}

  instance_id = module.db_instance[0].id
  db_name     = var.db_name
  schema_name = each.value.name
  owner       = each.value.owner

  depends_on = [
    huaweicloud_rds_pg_database.this,
    huaweicloud_rds_pg_account.this
  ]
}

resource "huaweicloud_rds_pg_account_roles" "this" {
  for_each = var.engine == "postgres" ? { for role_config in var.postgres_account_roles : role_config.user => role_config } : {}

  instance_id = module.db_instance[0].id
  user        = each.value.user
  roles       = each.value.roles

  depends_on = [huaweicloud_rds_pg_account.this]
}

resource "huaweicloud_rds_pg_account_privileges" "this" {
  for_each = var.engine == "postgres" ? { for priv in var.postgres_account_privileges : priv.user => priv } : {}

  instance_id            = module.db_instance[0].id
  user_name              = each.value.user
  role_privileges        = each.value.role_privileges
  system_role_privileges = each.value.system_role_privileges

  depends_on = [huaweicloud_rds_pg_account.this]
}

# PostgreSQL Plugin Management
resource "huaweicloud_rds_pg_plugin" "this" {
  for_each = var.engine == "postgres" ? {
    for plugin in var.postgres_plugins : "${plugin.database_name}/${plugin.name}" => plugin
  } : {}

  instance_id   = module.db_instance[0].id
  database_name = each.value.database_name
  name          = each.value.name

  # Plugin requires database to exist. Wait for database creation if create_pg_objects is true.
  # If create_pg_objects is false, user must ensure database exists before applying plugins.
  depends_on = [
    module.db_instance,
    huaweicloud_rds_pg_database.this
  ]
}

# PostgreSQL Plugin Parameters (Instance Level)
resource "huaweicloud_rds_pg_plugin_parameter" "this" {
  for_each = var.engine == "postgres" ? { for param in var.postgres_plugin_parameters : param.name => param } : {}

  instance_id = module.db_instance[0].id
  name        = each.value.name
  values      = each.value.values

  depends_on = [module.db_instance]
}

################################################################################
# EIP and Public Access
################################################################################

resource "huaweicloud_vpc_eip" "this" {
  count = var.enable_public_access ? 1 : 0

  publicip {
    type = var.eip_type
  }

  bandwidth {
    share_type  = "PER"
    name        = var.eip_bandwidth_name != null ? var.eip_bandwidth_name : "${var.identifier}-eip"
    size        = var.eip_bandwidth_size
    charge_mode = var.eip_bandwidth_charge_mode
  }

  tags = var.tags
}

resource "huaweicloud_rds_instance_eip_associate" "this" {
  count = var.enable_public_access ? 1 : 0

  instance_id  = module.db_instance[0].id
  public_ip    = huaweicloud_vpc_eip.this[0].address
  public_ip_id = huaweicloud_vpc_eip.this[0].id

  depends_on = [module.db_instance]
}

################################################################################
# Read Replica Instance (Optional)
################################################################################

module "db_read_replica" {
  count  = local.create_read_replica ? 1 : 0
  source = "./modules/db_read_replica"

  name                  = coalesce(var.replica_identifier, "${var.identifier}-replica")
  primary_instance_id   = local.replica_source_db
  flavor                = local.replica_flavor
  availability_zone     = try(coalesce(var.replica_availability_zones, var.availability_zones)[0], var.availability_zones[0])
  security_group_id     = coalesce(var.replica_security_group_id, var.security_group_id)
  enterprise_project_id = var.enterprise_project_id
  fixed_ip              = var.replica_fixed_ip
  ssl_enable            = var.ssl_enable

  db_port = var.port

  volume_type              = var.storage_type
  volume_size              = coalesce(var.replica_allocated_storage, var.allocated_storage)
  volume_limit_size        = var.replica_max_allocated_storage
  volume_trigger_threshold = var.replica_storage_autoscaling_threshold

  parameters = var.replica_parameters

  maintain_begin = local.replica_maintenance_begin
  maintain_end   = local.replica_maintenance_end

  charging_mode = var.charging_mode
  period_unit   = var.period_unit
  period        = var.period
  auto_renew    = var.auto_renew

  tags = merge(var.tags, var.replica_tags)

  timeouts = var.timeouts

  depends_on = [module.db_instance]
}
