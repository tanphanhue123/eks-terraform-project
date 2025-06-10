# eks-fargate

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.25.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.eks_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_addon.eks_addon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_fargate_profile.eks_fargate_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_eks_node_group.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [tls_certificate.eks_cluster](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks"></a> [eks](#input\_eks) | All configurations to eks cluster | <pre>object({<br>    name                      = string<br>    role_arn                  = string<br>    version                   = string<br>    enabled_cluster_log_types = optional(list(string), [])<br>    vpc_config = object({<br>      endpoint_private_access = optional(bool, false)<br>      endpoint_public_access  = optional(bool, true)<br>      public_access_cidrs     = optional(list(string), [])<br>      security_group_ids      = optional(list(string), [])<br>      subnet_ids              = list(string)<br>    })<br>    encryption_config = optional(object({<br>      provider = object({<br>        key_arn = string<br>      })<br>      resources = list(string)<br>    }), null)<br>    kubernetes_network_config = optional(object({<br>      service_ipv4_cidr = optional(string, null)<br>      ip_family         = optional(string, "ipv4")<br>    }), {})<br>    timeouts = optional(map(string), {<br>      create = "30m"<br>      update = "60m"<br>      delete = "15m"<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_eks_addons"></a> [eks\_addons](#input\_eks\_addons) | All configurations to eks addons | <pre>list(object({<br>    addon_name                  = string<br>    addon_version               = optional(string, null)<br>    configuration_values        = optional(string, null)<br>    resolve_conflicts_on_create = optional(string, "OVERWRITE")<br>    resolve_conflicts_on_update = optional(string, "NONE")<br>    preserve                    = optional(string, null)<br>    service_account_role_arn    = optional(string, null)<br>    timeouts = optional(map(string), {<br>      create = "15m"<br>      update = "15m"<br>      delete = "30m"<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_eks_log_group_retention"></a> [eks\_log\_group\_retention](#input\_eks\_log\_group\_retention) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `30` | no |
| <a name="input_eks_node_group"></a> [eks\_node\_group](#input\_eks\_node\_group) | All configurations to eks node group | <pre>list(object({<br>    node_group_name = string<br>    node_role_arn   = string<br>    subnet_ids      = list(string)<br>    scaling_config = optional(object({<br>      desired_size = optional(number, 1)<br>      min_size     = optional(number, 1)<br>      max_size     = optional(number, 2)<br>    }), {})<br>    update_config = optional(object({<br>      max_unavailable            = optional(number, null)<br>      max_unavailable_percentage = optional(number, null)<br>    }), null)<br>    ami_type             = optional(string, null)<br>    capacity_type        = optional(string, null)<br>    disk_size            = optional(number, 20)<br>    force_update_version = optional(bool, false)<br>    instance_types       = optional(list(string), ["t3.medium"])<br>    labels               = optional(map(string))<br>    version              = optional(string, null)<br>    release_version      = optional(string, null)<br>    launch_template = optional(object({<br>      name    = string<br>      version = optional(any, "$Latest")<br>    }), null)<br>    remote_access = optional(object({<br>      ec2_ssh_key               = optional(string, null)<br>      source_security_group_ids = optional(list(string), [])<br>    }), null)<br>    taint = optional(list(object({<br>      key    = string<br>      value  = optional(string, null)<br>      effect = optional(string, "NO_SCHEDULE")<br>    })), [])<br>    timeouts = optional(map(string), {<br>      create = "30m"<br>      update = "60m"<br>      delete = "30m"<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_fargate_profiles"></a> [fargate\_profiles](#input\_fargate\_profiles) | All configurations to eks fargate profile | <pre>list(object({<br>    fargate_profile_name   = string<br>    pod_execution_role_arn = string<br>    subnet_ids             = list(string)<br>    selectors = list(object({<br>      namespace = string<br>      labels    = optional(map(string))<br>    }))<br>    timeouts = optional(map(string), {<br>      create = "10m"<br>      delete = "15m"<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_openid_connect_provider_eks_cluster_arn"></a> [aws\_iam\_openid\_connect\_provider\_eks\_cluster\_arn](#output\_aws\_iam\_openid\_connect\_provider\_eks\_cluster\_arn) | The arn OIDC of the EKS cluster |
| <a name="output_aws_iam_openid_connect_provider_eks_cluster_url"></a> [aws\_iam\_openid\_connect\_provider\_eks\_cluster\_url](#output\_aws\_iam\_openid\_connect\_provider\_eks\_cluster\_url) | The url OIDC of the EKS cluster |
| <a name="output_eks_cluster_addons_arn"></a> [eks\_cluster\_addons\_arn](#output\_eks\_cluster\_addons\_arn) | Amazon Resource Name (ARN) identifying your addons eks |
| <a name="output_eks_cluster_addons_id"></a> [eks\_cluster\_addons\_id](#output\_eks\_cluster\_addons\_id) | Amazon Resource Name (ARN) identifying your addons eks |
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | ARN of the EKS cluster |
| <a name="output_eks_cluster_certificate_authority"></a> [eks\_cluster\_certificate\_authority](#output\_eks\_cluster\_certificate\_authority) | The Cert of the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | The endpoint of the EKS cluster |
| <a name="output_eks_cluster_fargate_profile_arn"></a> [eks\_cluster\_fargate\_profile\_arn](#output\_eks\_cluster\_fargate\_profile\_arn) | Amazon Resource Name (ARN) identifying fargate profile eks |
| <a name="output_eks_cluster_fargate_profile_id"></a> [eks\_cluster\_fargate\_profile\_id](#output\_eks\_cluster\_fargate\_profile\_id) | Name identifying fargate profile eks |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | The ID of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | The name of the EKS cluster |
| <a name="output_eks_cluster_node_group_arn"></a> [eks\_cluster\_node\_group\_arn](#output\_eks\_cluster\_node\_group\_arn) | Amazon Resource Name (ARN) identifying node group eks |
| <a name="output_eks_cluster_node_group_id"></a> [eks\_cluster\_node\_group\_id](#output\_eks\_cluster\_node\_group\_id) | Name identifying node group eks |
| <a name="output_eks_cluster_node_group_resources"></a> [eks\_cluster\_node\_group\_resources](#output\_eks\_cluster\_node\_group\_resources) | Resource identifying node group eks |
| <a name="output_eks_cluster_security_group_id"></a> [eks\_cluster\_security\_group\_id](#output\_eks\_cluster\_security\_group\_id) | Amazon Resource Name (ARN) identifying fargate profile eks |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
