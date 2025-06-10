# codestar

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.61.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codestarconnections_connection.codestar_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |
| <a name="input_provider_type"></a> [provider\_type](#input\_provider\_type) | The name of the external provider where your third-party code repository is configured. Valid values are Bitbucket, GitHub or GitHubEnterpriseServer. | `string` | `"GitHub"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codestar_connection_arn"></a> [codestar\_connection\_arn](#output\_codestar\_connection\_arn) | The codestar connection ARN. |
| <a name="output_codestar_connection_id"></a> [codestar\_connection\_id](#output\_codestar\_connection\_id) | The codestar connection ARN. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
