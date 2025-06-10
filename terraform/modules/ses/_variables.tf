#modules/ses/_variables.tf
#basic
variable "region" {
  description = "Region of environment"
  type        = string
}

#ses
variable "ses_domain_identity" {
  description = "The domain name to assign to SES"
  type        = string
}
variable "route53_zone_id" {
  description = "ID of Route53 Hostedzone"
  type        = string
}
variable "ses_email_identities" {
  description = "List of emails to Provides an SES email identity resource"
  type        = list(string)
  default     = []
}
variable "ses_smtp_user" {
  description = "The user's name and policy of smtp user"
  type = object({
    name   = string
    policy = string
  })
  default = null
}
variable "ses_identity_notification" {
  description = "The type of notifications that will be published to the specified Amazon SNS topic and The Amazon Resource Name (ARN) of the Amazon SNS topic"
  type = object({
    topic_arn = string
    type      = list(string)
  })
  default = null
}
variable "ses_email_receiving" {
  description = "All configurations about SES Email Receiving"
  type = object({
    receipt_rule_set_name = string
    receipt_rule = object({
      name       = string
      recipients = list(string)
      s3_actions = optional(list(object(
        {
          position          = number
          bucket_name       = string
          object_key_prefix = optional(string, null)
          kms_key_arn       = optional(string, null)
          topic_arn         = optional(string, null)
        }
      )), [])
      sns_actions = optional(list(object(
        {
          position  = number
          topic_arn = string
          encoding  = optional(string, null)
        }
      )), [])
      lambda_actions = optional(list(object(
        {
          position        = number
          function_arn    = string
          invocation_type = optional(string, null)
          topic_arn       = optional(string, null)
        }
      )), [])
    })
  })
  default = null
}
