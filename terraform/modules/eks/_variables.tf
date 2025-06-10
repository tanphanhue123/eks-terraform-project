#modules/eks/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#eks
variable "eks" {
  description = "All configurations to eks cluster"
  type = object({
    name                      = string
    role_arn                  = string
    version                   = string
    enabled_cluster_log_types = optional(list(string), [])
    vpc_config = object({
      endpoint_private_access = optional(bool, false)
      endpoint_public_access  = optional(bool, true)
      public_access_cidrs     = optional(list(string), [])
      security_group_ids      = optional(list(string), [])
      subnet_ids              = list(string)
    })
    encryption_config = optional(object({
      provider = object({
        key_arn = string
      })
      resources = list(string)
    }), null)
    kubernetes_network_config = optional(object({
      service_ipv4_cidr = optional(string, null)
      ip_family         = optional(string, "ipv4")
    }), {})
    timeouts = optional(map(string), {
      create = "30m"
      update = "60m"
      delete = "15m"
    })
  })
}

variable "eks_log_group_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  default     = 30
  type        = number
}

variable "fargate_profiles" {
  description = "All configurations to eks fargate profile"
  default     = []
  type = list(object({
    fargate_profile_name   = string
    pod_execution_role_arn = string
    subnet_ids             = list(string)
    selectors = list(object({
      namespace = string
      labels    = optional(map(string))
    }))
    timeouts = optional(map(string), {
      create = "10m"
      delete = "15m"
    })
  }))
}

variable "eks_addons" {
  description = "All configurations to eks addons"
  default     = []
  type = list(object({
    addon_name                  = string
    addon_version               = optional(string, null)
    configuration_values        = optional(string, null)
    resolve_conflicts_on_create = optional(string, "OVERWRITE")
    resolve_conflicts_on_update = optional(string, "NONE")
    preserve                    = optional(string, null)
    service_account_role_arn    = optional(string, null)
    pod_identity_association = optional(object({
      role_arn        = string
      service_account = string
    }), null)
    timeouts = optional(map(string), {
      create = "15m"
      update = "15m"
      delete = "30m"
    })
  }))
}

variable "eks_node_group" {
  description = "All configurations to eks node group"
  default     = []
  type = list(object({
    node_group_name = string
    node_role_arn   = string
    subnet_ids      = list(string)
    scaling_config = optional(object({
      desired_size = optional(number, 1)
      min_size     = optional(number, 1)
      max_size     = optional(number, 2)
    }), {})
    update_config = optional(object({
      max_unavailable            = optional(number, null)
      max_unavailable_percentage = optional(number, null)
    }), null)
    ami_type             = optional(string, null)
    capacity_type        = optional(string, null)
    disk_size            = optional(number, 20)
    force_update_version = optional(bool, false)
    instance_types       = optional(list(string), ["t3.medium"])
    labels               = optional(map(string))
    version              = optional(string, null)
    release_version      = optional(string, null)
    launch_template = optional(object({
      name    = string
      version = optional(any, "$Latest")
    }), null)
    remote_access = optional(object({
      ec2_ssh_key               = optional(string, null)
      source_security_group_ids = optional(list(string), [])
    }), null)
    taint = optional(list(object({
      key    = string
      value  = optional(string, null)
      effect = optional(string, "NO_SCHEDULE")
    })), [])
    timeouts = optional(map(string), {
      create = "30m"
      update = "60m"
      delete = "30m"
    })
  }))
}

variable "pod_identity_association" {
  default = []
  type = list(object({
    namespace       = string
    service_account = string
    role_arn        = string
  }))
}

variable "eks_access_entry" {
  default = []
  type = list(object({
    principal_arn     = string
    type              = string
    tags              = optional(map(string), null)
    kubernetes_groups = optional(list(string), null)
    user_name         = optional(string, null)
  }))
}

variable "eks_access_policy_association" {
  default = []
  type = list(object({
    policy_arn    = string
    principal_arn = string
    access_scope = object({
      type       = string
      namespaces = optional(list(string))
    })
  }))
}