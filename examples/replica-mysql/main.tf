provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "replica-mysql"
  region = "tr-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.huaweicloud_availability_zones.available.names, 0, 1)

  tags = {
    Name    = local.name
    Example = local.name
  }

  engine         = "mysql"
  engine_version = "8.0"
  family         = "8.0"
  instance_class = "rds.mysql.n1.large.2"
  port           = 3306
}

################################################################################
# Master DB
################################################################################

module "master" {
  source = "../../"

  identifier = "${local.name}-master"

  engine         = local.engine
  engine_version = local.engine_version
  family         = local.family
  instance_class = local.instance_class

  allocated_storage     = 40
  max_allocated_storage = 100
  storage_type          = "CLOUDSSD"

  db_name  = "replicamysql"
  username = "replica_mysql"
  password = "YourPassword123!"
  port     = local.port

  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.database_subnets[0]
  security_group_id  = module.security_group.security_group_id
  availability_zones = local.azs

  maintenance_window      = "22:00-02:00"
  backup_window           = "03:00-04:00"
  backup_retention_period = 1

  storage_autoscaling_threshold = 15

  parameters = {
    max_connections = "200"
  }

  tags = local.tags
}

################################################################################
# Replica DB
################################################################################

module "replica" {
  source = "../../"

  create_db_instance        = false
  create_db_parameter_group = false
  create_read_replica       = true

  identifier         = local.name
  replica_identifier = "${local.name}-replica"

  replicate_source_db = module.master.db_instance_id

  engine             = local.engine
  engine_version     = local.engine_version
  instance_class     = local.instance_class
  availability_zones = local.azs
  allocated_storage  = 40
  storage_type       = "CLOUDSSD"
  password           = "YourReplicaPassword123!"
  port               = local.port

  replica_instance_class                = "rds.mysql.n1.large.2.rr"
  replica_availability_zones            = [local.azs[0]]
  replica_max_allocated_storage         = 100
  replica_maintenance_window            = "02:00-06:00"
  replica_storage_autoscaling_threshold = 15

  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.database_subnets[0]
  security_group_id = module.security_group.security_group_id

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source = "../../../terraform-huawei-vpc"

  name = local.name
  cidr = local.vpc_cidr

  azs = local.azs

  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)]

  tags = local.tags
}

module "security_group" {
  source = "../../../terraform-huawei-security-group"

  name        = local.name
  description = "Security group for ${local.name} RDS replica example"

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
