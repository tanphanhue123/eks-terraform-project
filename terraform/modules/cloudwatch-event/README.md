# cloudwatch-event

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.56.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.cloudwatch_event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.cloudwatch_event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_event_rule"></a> [cloudwatch\_event\_rule](#input\_cloudwatch\_event\_rule) | All configurations about Cloudwatch Event Rule | <pre>object(<br>    {<br>      name                = string<br>      description         = string<br>      event_pattern       = optional(string, null)<br>      schedule_expression = optional(string, null)<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_cloudwatch_event_targets"></a> [cloudwatch\_event\_targets](#input\_cloudwatch\_event\_targets) | All configurations about Cloudwatch Event Targets | <pre>map(object(<br>    {<br>      arn      = string<br>      role_arn = optional(string, null)<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
