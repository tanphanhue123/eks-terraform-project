# switch-role

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.62.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.iam_custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.aws_managed_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | Assume role policy of IAM Role | `string` | n/a | yes |
| <a name="input_aws_managed_policy_arn"></a> [aws\_managed\_policy\_arn](#input\_aws\_managed\_policy\_arn) | ARN of IAM Default Policies managed by AWS | `list(string)` | `[]` | no |
| <a name="input_iam_custom_policy"></a> [iam\_custom\_policy](#input\_iam\_custom\_policy) | Custom Policy of IAM Role | <pre>object({<br>    template = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_switch_role_name"></a> [switch\_role\_name](#input\_switch\_role\_name) | Name of IAM Role/IAM Policy/IAM Instance Profile | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM Role |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
