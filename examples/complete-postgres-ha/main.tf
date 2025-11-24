
provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "tr-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.huaweicloud_availability_zones.available.names, 0, 2) # 2 AZs for Primary/Standby

  tags = {
    Name    = local.name
    Example = local.name
  }
}

################################################################################
# RDS Module - Primary/Standby (HA) Configuration
################################################################################

module "db" {
  source = "../../"

  identifier = local.name

  engine         = "postgres"
  engine_version = "14"
  family         = "14"                      # DB parameter group
  instance_class = "rds.pg.n1.large.2.ha"    # HA flavor with .ha suffix
  # Note: For Primary/Standby, flavor must end with .ha

  allocated_storage = 40
  storage_type      = "CLOUDSSD"

  # Disk Encryption with KMS
  kms_key_id = module.dew.key_id

  password = "YourPassword123!"
  port     = 5432

  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.database_subnets[0] # Primary subnet
  security_group_id  = module.security_group.security_group_id
  availability_zones  = local.azs # 2 AZs: [az1, az2] for Primary/Standby

  # HA Replication Mode
  # For PostgreSQL: async (asynchronous) or sync (synchronous)
  # async: Better performance, slight data loss risk during failover
  # sync: Zero data loss, slightly lower performance
  ha_replication_mode = "async"

  maintenance_window      = "22:00-02:00"
  backup_window           = "03:00-04:00"
  backup_retention_period = 7

  skip_final_snapshot = true

  create_pg_objects = true
  db_name           = "completedb"
  db_description    = "Complete PostgreSQL HA example database"
  username          = "dbuser"
  user_password     = "YourPassword123!"

  # DB Parameter Group parameters (instance-level PostgreSQL configuration)
  # Note: shared_preload_libraries is added here instead of postgres_plugin_parameters
  # due to provider issues with plugin parameter resource.
  parameters = {
    max_connections        = "200"
    shared_preload_libraries = "pgaudit" # Required for pgaudit plugin
  }

  # PostgreSQL Plugins (enable plugins on databases)
  # Note: Plugins are enabled per database. The database must exist before plugins can be added.
  postgres_plugins = [
    {
      database_name = "completedb" # Uses var.db_name from create_pg_objects
      name          = "pgaudit"    # Example: PostgreSQL audit logging plugin
    }
  ]

  enable_lts_logs = false # LTS logging is not supported for PostgreSQL in some regions

  enable_sql_audit            = false
  sql_audit_keep_days         = 7
  sql_audit_reserve_auditlogs = false

  auto_minor_version_upgrade = true

  # Public Access (EIP) - Set to true for development/testing environments
  # Note: Also update security group ingress rules to allow access from your IP
  enable_public_access      = true
  eip_bandwidth_name        = "complete-postgres-ha-eip"
  eip_bandwidth_size        = 10
  eip_bandwidth_charge_mode = "traffic"

  tags = local.tags
  db_instance_tags = {
    Sensitive  = "high"
    Monitoring = "enabled"
    HA         = "primary-standby"
  }
  db_parameter_group_tags = {
    Sensitive = "low"
  }
}

################################################################################
# Supporting Resources
################################################################################

# KMS Key for Disk Encryption
module "dew" {
  source = "github.com/artifactsystems/terraform-huawei-dew?ref=v1.0.0"

  key_alias   = "${local.name}-disk-encryption"
  description = "KMS key for RDS disk encryption"
  key_spec    = "AES_256"
  key_usage   = "ENCRYPT_DECRYPT"
  is_enabled  = true

  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 7

  tags = local.tags
}
module "vpc" {
  source = "github.com/artifactsystems/terraform-huawei-vpc?ref=v1.0.0"

  name = local.name
  cidr = local.vpc_cidr

  azs = local.azs

  # Create subnets for each AZ
  # Primary/Standby requires subnets in both AZs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)]

  tags = local.tags
}

module "security_group" {
  source = "github.com/artifactsystems/terraform-huawei-security-group?ref=v1.0.0"

  name        = local.name
  description = "Complete PostgreSQL HA example security group"

  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}

