# cloudwatch-alarm

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.56.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.cloudwatch_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_alarms"></a> [cloudwatch\_alarms](#input\_cloudwatch\_alarms) | All configurations about Cloudwatch Alarms | <pre>list(object(<br>    {<br>      name                = string<br>      metric_name         = string<br>      namespace           = string<br>      comparison_operator = string<br>      statistic           = string<br>      threshold           = string<br>      unit                = string<br>      datapoints_to_alarm = string<br>      evaluation_periods  = string<br>      period              = string<br>      dimensions          = map(any)<br>      alarm_actions       = list(string)<br>      ok_actions          = optional(list(string), [])<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | AWS service name | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Application name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
