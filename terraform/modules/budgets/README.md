# budgets

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.budgets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_budget_type"></a> [budget\_type](#input\_budget\_type) | (Required) Whether this budget tracks monetary cost or usage. | `string` | `"COST"` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_limit_amount"></a> [limit\_amount](#input\_limit\_amount) | (Required) The amount of cost or usage being measured for a budget. | `string` | n/a | yes |
| <a name="input_notifications"></a> [notifications](#input\_notifications) | (Optional) Object containing Budget Notifications. Can be used multiple times to define more than one budget notification. | <pre>list(object({<br>    threshold                  = number<br>    subscriber_email_addresses = optional(list(string), [])<br>    subscriber_sns_topic_arns  = optional(list(string), [])<br>  }))</pre> | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |
| <a name="input_time_period_start"></a> [time\_period\_start](#input\_time\_period\_start) | (Optional) The start of the time period covered by the budget. If you don't specify a start date, AWS defaults to the start of your chosen time period. The start date must come before the end date. Format: 2017-01-01\_12:00. | `string` | n/a | yes |
| <a name="input_time_unit"></a> [time\_unit](#input\_time\_unit) | (Required) The length of time until a budget resets the actual and forecasted spend. Valid values: MONTHLY, QUARTERLY, ANNUALLY, and DAILY. | `string` | `"MONTHLY"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
