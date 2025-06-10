#modules/wafv2/variables.tf
#base
variable "project" {}
variable "env" {}

#wafv2
variable "wafv2_scope" { default = "REGIONAL" }
variable "wafv2_web_acl_name" {}
variable "wafv2_web_acl_default_action" { default = "allow" }
variable "wafv2_web_acl_rules" {}
variable "wafv2_web_acl_association" { default = [] }
variable "wafv2_web_acl_logging" { default = {} }
