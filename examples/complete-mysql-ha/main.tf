
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

  engine         = "mysql"
  engine_version = "8.0"
  family         = "8.0"                     # DB parameter group
  instance_class = "rds.mysql.n1.large.2.ha" # HA flavor with .ha suffix
  # Note: For Primary/Standby, flavor must end with .ha

  allocated_storage = 40
  storage_type      = "CLOUDSSD"

  # Disk Encryption with KMS
  kms_key_id = module.dew.key_id

  password = "YourPassword123!"
  port     = 3306

  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.database_subnets[0] # Primary subnet
  security_group_id  = module.security_group.security_group_id
  availability_zones = local.azs # 2 AZs: [az1, az2] for Primary/Standby

  # HA Replication Mode
  # For MySQL: async (asynchronous) or semisync (semi-synchronous)
  # async: Better performance, slight data loss risk during failover
  # semisync: Reduced data loss risk, slightly lower performance
  ha_replication_mode = "async"

  maintenance_window      = "22:00-02:00"
  backup_window           = "03:00-04:00"
  backup_retention_period = 7

  create_mysql_objects = true
  db_name              = "completemysql"
  db_description       = "Complete MySQL HA example database"
  username             = "mysqladmin"
  user_password        = "MysqlAdmin123!"

  parameters = {
    character_set_client = "utf8mb4"
    character_set_server = "utf8mb4"
    max_connections      = "200"
  }

  enable_lts_logs = true
  lts_log_configs = [
    {
      log_type      = "error_log"
      lts_group_id  = module.lts.log_group_id
      lts_stream_id = module.lts.log_stream_ids["${local.name}-error-log"]
    },
    {
      log_type      = "slow_log"
      lts_group_id  = module.lts.log_group_id
      lts_stream_id = module.lts.log_stream_ids["${local.name}-slow-log"]
    }
  ]

  enable_sql_audit            = true
  sql_audit_keep_days         = 7
  sql_audit_reserve_auditlogs = false

  auto_minor_version_upgrade = false

  # Public Access (EIP) - Set to true for development/testing environments
  # Note: Also update security group ingress rules to allow access from your IP
  enable_public_access      = true
  eip_bandwidth_name        = "${local.name}-eip"
  eip_bandwidth_size        = 10
  eip_bandwidth_charge_mode = "traffic"

  tags = local.tags
  db_instance_tags = {
    Sensitive  = "high"
    Monitoring = "enabled"
    HA         = "primary-standby"
  }
}

################################################################################
# Supporting Resources
################################################################################

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

module "lts" {
  source = "github.com/artifactsystems/terraform-huawei-lts?ref=v1.0.0"

  group_name  = "${local.name}-rds-logs"
  ttl_in_days = 7

  log_streams = [
    {
      name = "${local.name}-error-log"
    },
    {
      name = "${local.name}-slow-log"
    }
  ]

  tags = local.tags

  log_group_tags = {
    Purpose = "rds-logging"
  }
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
  description = "Complete MySQL HA example security group"

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}
