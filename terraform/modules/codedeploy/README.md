# codedeploy

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codedeploy_app.codedeploy_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.codedeploy_deployment_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codedeploy_app"></a> [codedeploy\_app](#input\_codedeploy\_app) | Provides a CodeDeploy application to be used as a basis for deployments | <pre>object({<br>    name             = string<br>    compute_platform = string<br>  })</pre> | `null` | no |
| <a name="input_codedeploy_app_name"></a> [codedeploy\_app\_name](#input\_codedeploy\_app\_name) | Name of the cluster | `string` | `null` | no |
| <a name="input_codedeploy_deployment_groups"></a> [codedeploy\_deployment\_groups](#input\_codedeploy\_deployment\_groups) | Provides a CodeDeploy Deployment Group for a CodeDeploy Application | <pre>list(object({<br>    deployment_group_name = string<br>    service_role_arn      = string<br>    autoscaling_groups    = optional(list(string), null)<br>    ecs_service = optional(object({<br>      cluster_name = string<br>      service_name = string<br>    }), null)<br>    deployment_style = object({<br>      type   = string<br>      option = optional(string, null)<br>    })<br>    auto_rollback_configuration = optional(bool, false)<br>    blue_green_deployment_config = optional(object({<br>      deployment_ready_option = object({<br>        action_on_timeout    = string<br>        wait_time_in_minutes = optional(number, null)<br>      })<br>      terminate_blue_instances_on_deployment_success = object({<br>        action                           = string<br>        termination_wait_time_in_minutes = optional(number, null)<br>      })<br>    }), null)<br>    load_balancer_info = optional(object({<br>      target_group_info = optional(string, null)<br>      target_group_pair_info = optional(object({<br>        listener_arns  = string<br>        target_group_1 = string<br>        target_group_2 = string<br>      }), null)<br>    }), null)<br>    ec2_tag_filter = optional(list(object({<br>      key   = string<br>      type  = string<br>      value = string<br>    })), [])<br>    ec2_tag_set = optional(object({<br>      ec2_tag_filter = optional(list(object({<br>        key   = string<br>        type  = string<br>        value = string<br>      })), [])<br>    }), null)<br>    trigger_configuration = optional(object({<br>      events     = list(string)<br>      name       = string<br>      target_arn = string<br>    }), null)<br>  }))</pre> | `[]` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codedeploy_app_name"></a> [codedeploy\_app\_name](#output\_codedeploy\_app\_name) | The application's name. |
| <a name="output_codedeploy_deployment_group_name"></a> [codedeploy\_deployment\_group\_name](#output\_codedeploy\_deployment\_group\_name) | The name of the CodeDeploy deployment group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
