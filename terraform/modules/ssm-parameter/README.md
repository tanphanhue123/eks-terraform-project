# ssm-parameter

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.37 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.61.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_id"></a> [key\_id](#input\_key\_id) | KMS key ID or ARN for encrypting a SecureString | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the SSM parameter | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Type of the parameter | `string` | `"SecureString"` | no |
| <a name="input_value"></a> [value](#input\_value) | Value of the SSM parameter | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ssm_parameter_name"></a> [ssm\_parameter\_name](#output\_ssm\_parameter\_name) | Name of the SSM parameter |
| <a name="output_ssm_parameter_value"></a> [ssm\_parameter\_value](#output\_ssm\_parameter\_value) | Value of the SSM parameter |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
