variable "env" {
  description = "Name of project environment"
  type        = string
}
variable "project" {
  description = "Name of project"
  type        = string
}

variable "name" {
  description = "Name of all resources of this"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID resource."
  type        = string
}

variable "ingress" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = optional(string, "tcp")
    security_groups = optional(list(string), null)
    cidr_blocks     = optional(list(string), null)
    prefix_list_ids = optional(list(string), null)
    description     = optional(string, null)
    self            = optional(bool, false)
  }))
  default = []
}

variable "tags" {
  default     = {}
  description = "Tags attach to SG"
  type        = map(string)
}