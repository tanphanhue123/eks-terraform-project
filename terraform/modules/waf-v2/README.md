# waf-v2

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.59.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_ip_set.wafv2_ip_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.wafv2_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.wafv2_web_acl_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.wafv2_web_acl_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | n/a | `any` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | modules/wafv2/variables.tf base | `any` | n/a | yes |
| <a name="input_wafv2_scope"></a> [wafv2\_scope](#input\_wafv2\_scope) | wafv2 | `string` | `"REGIONAL"` | no |
| <a name="input_wafv2_web_acl_association"></a> [wafv2\_web\_acl\_association](#input\_wafv2\_web\_acl\_association) | n/a | `list` | `[]` | no |
| <a name="input_wafv2_web_acl_default_action"></a> [wafv2\_web\_acl\_default\_action](#input\_wafv2\_web\_acl\_default\_action) | n/a | `string` | `"allow"` | no |
| <a name="input_wafv2_web_acl_logging"></a> [wafv2\_web\_acl\_logging](#input\_wafv2\_web\_acl\_logging) | n/a | `map` | `{}` | no |
| <a name="input_wafv2_web_acl_name"></a> [wafv2\_web\_acl\_name](#input\_wafv2\_web\_acl\_name) | n/a | `any` | n/a | yes |
| <a name="input_wafv2_web_acl_rules"></a> [wafv2\_web\_acl\_rules](#input\_wafv2\_web\_acl\_rules) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_wafv2_web_acl_arn"></a> [wafv2\_web\_acl\_arn](#output\_wafv2\_web\_acl\_arn) | modules/wafv2-app/outputs.tf |
| <a name="output_wafv2_web_acl_name"></a> [wafv2\_web\_acl\_name](#output\_wafv2\_web\_acl\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
