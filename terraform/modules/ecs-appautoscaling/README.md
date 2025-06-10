# ecs-appautoscaling

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.59.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.ecs_appautoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs_appautoscaling_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecs_appautoscaling_policies"></a> [ecs\_appautoscaling\_policies](#input\_ecs\_appautoscaling\_policies) | Policies configurations to Provides a ECS Auto Scaling resource | <pre>list(object({<br>    name     = string<br>    cooldown = number<br>    step_adjustments = list(object({<br>      metric_interval_lower_bound = number<br>      metric_interval_upper_bound = number<br>      scaling_adjustment          = number<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_ecs_appautoscaling_target"></a> [ecs\_appautoscaling\_target](#input\_ecs\_appautoscaling\_target) | Targets configurations to Provides a ECS Auto Scaling resource | <pre>object({<br>    service_name = string<br>    cluster_name = string<br>    min_capacity = number<br>    max_capacity = number<br>  })</pre> | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_appautoscaling_policy_arn"></a> [ecs\_appautoscaling\_policy\_arn](#output\_ecs\_appautoscaling\_policy\_arn) | ARN assigned by AWS to the scaling policy |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
