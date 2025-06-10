
#modules/cloudtrail/_variables.tf
#basic
variable "env" {
  description = "Name of project environment"
  type        = string
}
variable "project" {
  description = "Name of project"
  type        = string
}

#cloudtrail
variable "cloudtrail" {
  description = "(Required) Env for cloudtrail"
  type = object({
    s3_bucket_name = string
    s3_key_prefix  = optional(string, null)
    kms_key_arn    = optional(string, null)
  })
}
