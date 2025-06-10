#modules/redis/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#redis
variable "redis_subnet_ids" {
  description = "Provides an Redis subnet group resource."
  type        = list(string)
}

variable "redis_replication_group" {
  description = "Provides an Redis resource."
  type = object({
    node_type                  = string
    automatic_failover_enabled = optional(bool, false)
    multi_az_enabled           = optional(bool, false)
    number_cache_clusters      = optional(number, 1)
    engine_version             = string
    security_group_ids         = list(string)
    maintenance_window         = optional(string, "sun:16:00-sun:17:00")
    snapshot_window            = optional(string, "17:01-18:31")
    snapshot_retention_limit   = optional(number, 7)
    sns_topic_arn              = optional(string, "")
  })
}

variable "redis_name" {
  description = "Name of all resources of this Redis module"
  type        = string
}

variable "redis_parameters" {
  description = "Provides an Redis parameter group resources."
  type = object({
    family = string
    parameters = optional(list(object({
      name  = string
      value = string
    })), [])
  })
}
