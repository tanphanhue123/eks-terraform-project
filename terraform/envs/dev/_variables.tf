variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}
variable "region" {
  description = "Region of environment"
  type        = string
}
variable "cidr" {
  description = "CIDR of VPC"
  type = object({
    vpc      = string
    publics  = list(string)
    privates = list(string)
  })
}
variable "service_ipv4_cidr" {
  description = "Service ipv4 cidr"
  type        = string
}
variable "global_ips" {
  description = "All Public IPs are allowed on AWS ALB"
  type        = map(any)
}

