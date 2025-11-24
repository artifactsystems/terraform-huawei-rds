variable "name" {
  description = "The name of the DB parameter group"
  type        = string
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix"
  type        = bool
  default     = false
}

variable "description" {
  description = "The description of the DB parameter group"
  type        = string
  default     = null
}

variable "values" {
  description = "Parameter group key/value pairs (e.g., max_connections = \"200\")"
  type        = map(string)
  default     = {}
}

variable "datastore_type" {
  description = "Database engine type (mysql|postgresql|sqlserver|mariadb), case-insensitive"
  type        = string
  default     = "mysql"
}

variable "datastore_version" {
  description = "Database engine version (e.g., 5.7 or 8.0 for MySQL)"
  type        = string
  default     = "8.0"
}


