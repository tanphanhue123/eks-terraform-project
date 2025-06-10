<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.91.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.91.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance_bastion"></a> [ec2\_instance\_bastion](#module\_ec2\_instance\_bastion) | ../../../modules/ec2-instance | n/a |
| <a name="module_iam_role_ec2_bastion"></a> [iam\_role\_ec2\_bastion](#module\_iam\_role\_ec2\_bastion) | ../../../modules/iam-role | n/a |
| <a name="module_security_group_ec2_bastion"></a> [security\_group\_ec2\_bastion](#module\_security\_group\_ec2\_bastion) | ../../../modules/sg | n/a |
| <a name="module_vpc-eks"></a> [vpc-eks](#module\_vpc-eks) | ../../../modules/vpc-eks | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR of VPC | <pre>object({<br/>    vpc      = string<br/>    publics  = list(string)<br/>    privates = list(string)<br/>  })</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_global_ips"></a> [global\_ips](#input\_global\_ips) | All Public IPs are allowed on AWS ALB | `map(any)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region of environment | `string` | n/a | yes |
| <a name="input_service_ipv4_cidr"></a> [service\_ipv4\_cidr](#input\_service\_ipv4\_cidr) | Service ipv4 cidr | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_account_id"></a> [aws\_account\_id](#output\_aws\_account\_id) | Show information about project, environment and account |
| <a name="output_subnet_private_id"></a> [subnet\_private\_id](#output\_subnet\_private\_id) | ID of Private Subnet |
| <a name="output_subnet_public_id"></a> [subnet\_public\_id](#output\_subnet\_public\_id) | ID of Public Subnet |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of VPC |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
