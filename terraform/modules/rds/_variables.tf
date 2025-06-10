#modules/rds-aurora/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#rds-aurora
variable "name" {
  description = "Name of all resources of this RDS Aurora module"
  type        = string
}

variable "aurora_parameter_group" {
  description = "Provides an RDS Cluster & DB parameter group resources."
  type = object({
    family = string
    cluster_parameters = optional(list(object({
      name         = string
      value        = string
      apply_method = optional(string, null)
    })), [])
    parameters = optional(list(object({
      name         = string
      value        = string
      apply_method = optional(string, null)
    })), [])
  })
}

variable "aurora_subnet_ids" {
  description = "Provides an RDS DB subnet group resource."
  type        = list(string)
}

variable "aurora_cluster" {
  description = "Provides an RDS Aurora Cluster resource."
  type = object({
    engine                       = string
    engine_version               = string
    database_name                = string
    master_username              = string
    master_password              = string
    skip_final_snapshot          = optional(bool, true)
    copy_tags_to_snapshot        = optional(bool, true)
    backup_retention_period      = optional(number, 7)
    preferred_backup_window      = optional(string, "17:01-17:31")
    preferred_maintenance_window = optional(string, "sun:16:00-sun:17:00")
    security_group_ids           = list(string)
    port                         = optional(number, null)
    apply_immediately            = optional(bool, true)
    enable_cloudwatch_logs       = optional(list(string), ["audit", "error", "slowquery"])
    storage_encrypted            = optional(bool, true)
    kms_key_id                   = optional(string, null)
    allow_major_version_upgrade  = optional(bool, false)
  })
}

variable "aurora_instance" {
  description = "Provides an RDS Aurora Instance resources."
  type = object({
    number                       = number
    instance_class               = string
    copy_tags_to_snapshot        = optional(bool, true)
    apply_immediately            = optional(bool, true)
    auto_minor_version_upgrade   = optional(bool, false)
    publicly_accessible          = optional(bool, false)
    performance_insights_enabled = optional(bool, false)
    monitoring_interval          = optional(number, 0)
    monitoring_role_arn          = optional(string, null)
  })
}

variable "aurora_event" {
  description = "(Optional) The variable provides a DB event subscription resource."
  default     = null
  type = object({
    source_type = optional(string, "db-cluster")
    event_categories = optional(list(string), [
      "failover",
      "failure",
      "maintenance",
      "notification",
    ])
    sns_topic_arn = string
  })
}

variable "aurora_log_group_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  default     = 30
  type        = number
}
