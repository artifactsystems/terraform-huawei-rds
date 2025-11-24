
provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "tr-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.huaweicloud_availability_zones.available.names, 0, 1)

  tags = {
    Name    = local.name
    Example = local.name
  }
}

################################################################################
# RDS Module
################################################################################

module "db" {
  source = "../../"

  identifier = local.name

  engine         = "postgres"
  engine_version = "14"
  family         = "14"                # DB parameter group
  instance_class = "rds.pg.n1.large.2" # 2 vCPUs, 4 GB RAM

  allocated_storage = 40
  storage_type      = "CLOUDSSD"
  kms_key_id        = module.dew.key_id

  password = "YourPassword123!"
  port     = 5432

  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.database_subnets[0]
  security_group_id  = module.security_group.security_group_id
  availability_zones = local.azs

  maintenance_window      = "22:00-02:00"
  backup_window           = "03:00-04:00"
  backup_retention_period = 7

  skip_final_snapshot = true

  create_pg_objects = true
  db_name           = "completedb"
  db_description    = "Complete PostgreSQL example database"
  username          = "dbuser"
  user_password     = "YourPassword123!"

  parameters = {
    max_connections        = "200"
    shared_preload_libraries = "pgaudit"
  }

  postgres_plugins = [
    {
      database_name = "completedb"
      name          = "pgaudit"
    }
  ]

  enable_lts_logs = false

  enable_sql_audit            = false
  sql_audit_keep_days         = 7
  sql_audit_reserve_auditlogs = false

  auto_minor_version_upgrade = true

  enable_public_access = true
  eip_bandwidth_name        = "complete-postgres-eip"
  eip_bandwidth_size        = 10
  eip_bandwidth_charge_mode = "traffic"

  tags = local.tags
  db_instance_tags = {
    Sensitive  = "high"
    Monitoring = "enabled"
  }
  db_parameter_group_tags = {
    Sensitive = "low"
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
module "vpc" {
  source = "github.com/artifactsystems/terraform-huawei-vpc?ref=v1.0.0"

  name = local.name
  cidr = local.vpc_cidr

  azs = local.azs

  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)]

  tags = local.tags
}

module "security_group" {
  source = "github.com/artifactsystems/terraform-huawei-security-group?ref=v1.0.0"

  name        = local.name
  description = "Complete PostgreSQL example security group"

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
