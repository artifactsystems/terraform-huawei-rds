resource "huaweicloud_rds_read_replica_instance" "this" {
  name                  = var.name
  primary_instance_id   = var.primary_instance_id
  flavor                = var.flavor
  availability_zone     = var.availability_zone
  security_group_id     = var.security_group_id
  enterprise_project_id = var.enterprise_project_id
  fixed_ip              = var.fixed_ip
  ssl_enable            = var.ssl_enable
  description           = var.description

  db {
    port = var.db_port
  }

  volume {
    type              = var.volume_type
    size              = var.volume_size
    limit_size        = var.volume_limit_size
    trigger_threshold = var.volume_trigger_threshold
  }

  dynamic "parameters" {
    for_each = var.parameters
    content {
      name  = parameters.key
      value = parameters.value
    }
  }

  maintain_begin = var.maintain_begin
  maintain_end   = var.maintain_end

  charging_mode = var.charging_mode
  period_unit   = var.period_unit
  period        = var.period
  auto_renew    = var.auto_renew

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
