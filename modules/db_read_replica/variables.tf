variable "name" {
  description = "Name of the read replica instance"
  type        = string
}

variable "primary_instance_id" {
  description = "The ID of the primary DB instance"
  type        = string
}

variable "flavor" {
  description = "Flavor (instance class) of the read replica. Must use .rr suffix for read replicas"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the read replica"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the read replica"
  type        = string
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

variable "ssl_enable" {
  description = "Whether to enable SSL"
  type        = bool
  default     = null
}

variable "description" {
  description = "Description of the read replica instance (0-64 characters)"
  type        = string
  default     = null
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = null
}

variable "volume_type" {
  description = "Volume type (must match primary instance). Valid: ULTRAHIGH, LOCALSSD, CLOUDSSD, ESSD"
  type        = string
}

variable "volume_size" {
  description = "Volume size in GB (40-4000, multiple of 10, must be >= primary instance)"
  type        = number
  default     = null
}

variable "volume_limit_size" {
  description = "Upper limit for automatic storage expansion in GB"
  type        = number
  default     = null
}

variable "volume_trigger_threshold" {
  description = "Threshold to trigger automatic expansion. Valid values: 10, 15, 20"
  type        = number
  default     = null
}

variable "parameters" {
  description = "Map of parameters to set on the read replica after launch"
  type        = map(string)
  default     = {}
}

variable "maintain_begin" {
  description = "Maintenance window start time (HH:mm format)"
  type        = string
  default     = null
}

variable "maintain_end" {
  description = "Maintenance window end time (HH:mm format)"
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
  description = "A mapping of tags to assign to the read replica"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Updated Terraform resource management timeouts"
  type        = map(string)
  default     = {}
}
