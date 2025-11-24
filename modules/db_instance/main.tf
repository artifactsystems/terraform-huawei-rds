locals {
  use_backup_period = var.backup_period != null && trimspace(var.backup_period) != ""

  # Map engine names to Huawei Cloud RDS type values
  engine_type_map = {
    "mysql"     = "MySQL"
    "postgres"  = "PostgreSQL"
    "sqlserver" = "SQLServer"
  }

  db_type = lookup(local.engine_type_map, lower(var.engine), "MySQL")
}

resource "huaweicloud_rds_instance" "this" {
  name                               = var.use_name_prefix ? null : var.name
  flavor                             = var.flavor
  vpc_id                             = var.vpc_id
  subnet_id                          = var.subnet_id
  security_group_id                  = var.security_group_id
  availability_zone                  = var.availability_zones
  enterprise_project_id              = var.enterprise_project_id
  fixed_ip                           = var.fixed_ip
  binlog_retention_hours             = var.binlog_retention_hours
  seconds_level_monitoring_enabled   = var.seconds_level_monitoring_enabled
  seconds_level_monitoring_interval  = var.seconds_level_monitoring_interval
  minor_version_auto_upgrade_enabled = var.minor_version_auto_upgrade_enabled
  private_dns_name_prefix            = var.private_dns_name_prefix
  slow_log_show_original_status      = var.slow_log_show_original_status
  read_write_permissions             = var.read_write_permissions
  switch_strategy                    = var.switch_strategy
  charging_mode                      = var.charging_mode
  period_unit                        = var.period_unit
  period                             = var.period
  auto_renew                         = var.auto_renew

  db {
    type     = local.db_type
    version  = var.engine_version
    password = var.db_password
    port     = var.db_port
  }

  volume {
    type               = var.volume_type
    size               = var.volume_size
    limit_size         = var.volume_limit_size
    trigger_threshold  = var.volume_trigger_threshold
    disk_encryption_id = var.disk_encryption_id
  }

  backup_strategy {
    start_time = var.backup_start_time
    keep_days  = var.backup_keep_days
    period     = local.use_backup_period ? var.backup_period : null
  }

  ha_replication_mode = var.ha_replication_mode

  tde_enabled    = var.tde_enabled
  rotate_day     = var.tde_rotate_day
  secret_id      = var.tde_secret_id
  secret_name    = var.tde_secret_name
  secret_version = var.tde_secret_version

  param_group_id = var.param_group_id

  maintain_begin = var.maintain_begin
  maintain_end   = var.maintain_end

  lower_case_table_names = var.lower_case_table_names
  ssl_enable             = var.ssl_enable

  tags = var.tags

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
# LTS (Log Tank Service) Configuration
################################################################################

resource "huaweicloud_rds_lts_config" "this" {
  for_each = var.enable_lts_logs ? { for config in var.lts_log_configs : config.log_type => config } : {}

  instance_id   = huaweicloud_rds_instance.this.id
  engine        = var.engine
  log_type      = each.value.log_type
  lts_group_id  = each.value.lts_group_id
  lts_stream_id = each.value.lts_stream_id

  timeouts {
    create = try(var.lts_timeouts.create, null)
    delete = try(var.lts_timeouts.delete, null)
  }

  depends_on = [huaweicloud_rds_instance.this]
}

################################################################################
# SQL Audit Configuration
################################################################################

resource "huaweicloud_rds_sql_audit" "this" {
  count = var.enable_sql_audit ? 1 : 0

  instance_id       = huaweicloud_rds_instance.this.id
  keep_days         = var.sql_audit_keep_days
  reserve_auditlogs = var.sql_audit_reserve_auditlogs

  depends_on = [huaweicloud_rds_instance.this]
}

