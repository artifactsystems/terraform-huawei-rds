# HuaweiCloud RDS Terraform Module

Terraform module which creates RDS (Relational Database Service) resources on HuaweiCloud.

## Features

This module supports the following RDS features:

### Core Features
- ✅ **RDS Instance**: Create and manage RDS database instances (MySQL, PostgreSQL, SQL Server)
- ✅ **Parameter Groups**: Custom database parameter groups with versioning support
- ✅ **Read Replicas**: Create read replicas for read-heavy workloads (MySQL and PostgreSQL)
- ✅ **MySQL Complete Support**: Databases, accounts, and privileges management
- ✅ **PostgreSQL Complete Support**: Databases, accounts, privileges, schemas, role management, and plugin management
- ✅ **Storage Autoscaling**: Automatic storage expansion with configurable thresholds
- ✅ **Backup Configuration**: Automated backups with retention and scheduling
- ✅ **Maintenance Window**: Configurable maintenance schedules

### Monitoring & Logging
- ✅ **LTS Logging**: Integration with Log Tank Service for error logs, slow query logs, and audit logs
- ✅ **SQL Audit**: SQL audit logging with configurable retention periods
- ✅ **Enhanced Monitoring**: Second-level monitoring intervals (1-5 seconds)

### Maintenance & Operations
- ✅ **Auto Minor Version Upgrade**: Automatic minor version upgrades during maintenance windows

### Network & Access
- ✅ **Public Access (EIP)**: Associate Elastic IP for public internet access to RDS instances

### Security
- ✅ **SSL/TLS**: Encrypted database connections
- ✅ **TDE (Transparent Data Encryption)**: Data-at-rest encryption with KMS integration
- ✅ **Tag Management**: Comprehensive tagging support for all resources
- ✅ **Enterprise Project Integration**: Support for HuaweiCloud Enterprise Projects

## Examples

- [complete-mysql](./examples/complete-mysql) - Complete MySQL RDS instance with LTS logging, SQL audit, database management, and auto minor version upgrade
- [complete-mysql-ha](./examples/complete-mysql-ha) - Complete MySQL Primary/Standby (HA) RDS instance with disk encryption, LTS logging, SQL audit, and public access
- [complete-postgres](./examples/complete-postgres) - Complete PostgreSQL RDS instance with SQL audit, schemas, role privileges, and auto minor version upgrade. Shows how to enable public access (EIP) for development/testing
- [complete-postgres-ha](./examples/complete-postgres-ha) - Complete PostgreSQL Primary/Standby (HA) RDS instance with disk encryption, plugins, and public access
- [replica-mysql](./examples/replica-mysql) - MySQL instance with read replica
- [replica-postgres](./examples/replica-postgres) - PostgreSQL instance with read replica

## Planned Features

The following features may be added based on user demand:

- [ ] **SQL Server Database Management** - Account, database, and privilege management for SQL Server (similar to MySQL/PostgreSQL support)
- [ ] **MySQL Proxy** (`huaweicloud_rds_mysql_proxy`) - Connection pooling and read/write splitting for high-traffic scenarios

## Contributing

Report issues/questions/feature requests in the [issues](https://github.com/artifactsystems/terraform-huawei-rds/issues/new) section.

Full contributing [guidelines are covered here](.github/CONTRIBUTING.md).
