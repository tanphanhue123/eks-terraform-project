# alb-bg

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.57.1 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.alb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.alb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.alb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [template_file.action_fixed_response_message_body](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.default_action_fixed_response_message_body](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb"></a> [alb](#input\_alb) | All configurations to Provides a Load Balancer resource | <pre>object({<br>    internal           = optional(bool, false)<br>    security_group_ids = list(string)<br>    subnet_ids         = list(string)<br>    logs_bucket_id     = string<br>  })</pre> | n/a | yes |
| <a name="input_alb_listener_rules"></a> [alb\_listener\_rules](#input\_alb\_listener\_rules) | All configurations to Provides a Load Balancer Listener Rule resources | <pre>list(object({<br>    listener_arn = string<br>    priority     = number<br>    condition = object({<br>      type   = string<br>      values = list(string)<br>    })<br>    action = object({<br>      type = string<br>      forward = optional(object({<br>        target_group_arn = optional(string, null)<br>      }), {})<br>      fixed_response = optional(object({<br>        content_type = optional(string, null)<br>        status_code  = optional(number, null)<br>        message_body = optional(object({<br>          template = optional(string, null)<br>          vars     = optional(map(any), {})<br>        }), {})<br>      }), {})<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_alb_listeners"></a> [alb\_listeners](#input\_alb\_listeners) | All configurations to Provides a Load Balancer Listener resources | <pre>list(object({<br>    port            = number<br>    protocol        = string<br>    ssl_policy      = optional(string, null)<br>    certificate_arn = optional(string, null)<br>    default_action = object({<br>      type = string<br>      redirect = optional(object({<br>        port = number<br>      }), null)<br>      forward = optional(object({<br>        target_group_arn = string<br>      }), null)<br>      fixed_response = optional(object({<br>        content_type = optional(string, null)<br>        status_code  = optional(number, null)<br>        message_body = optional(object({<br>          template = optional(string, null)<br>          vars     = optional(map(any), {})<br>        }), {})<br>      }), {})<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_alb_target_group"></a> [alb\_target\_group](#input\_alb\_target\_group) | All configurations to Provides a Target Group resources of Load Balancer resource | <pre>object({<br>    vpc_id = optional(string, null)<br>    target_groups = optional(list(object({<br>      name                 = string<br>      target_type          = string<br>      port                 = number<br>      deregistration_delay = optional(string, 300)<br>      health_check = object({<br>        port                = number<br>        path                = string<br>        healthy_threshold   = optional(number, 3)<br>        unhealthy_threshold = optional(number, 3)<br>        interval            = optional(number, 30)<br>        timeout             = optional(number, null)<br>        matcher             = optional(number, 200)<br>      })<br>    })), [])<br>  })</pre> | `{}` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Name of application type | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | The ARN of the load balancer |
| <a name="output_alb_arn_suffix"></a> [alb\_arn\_suffix](#output\_alb\_arn\_suffix) | The ARN suffix for use with CloudWatch Metrics |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The DNS name of the load balancer |
| <a name="output_alb_listener_arn"></a> [alb\_listener\_arn](#output\_alb\_listener\_arn) | Amazon Resource Name (ARN) identifying your ALB Listener |
| <a name="output_alb_target_group_arn"></a> [alb\_target\_group\_arn](#output\_alb\_target\_group\_arn) | Amazon Resource Name (ARN) identifying your Target Group |
| <a name="output_alb_target_group_arn_suffix"></a> [alb\_target\_group\_arn\_suffix](#output\_alb\_target\_group\_arn\_suffix) | Amazon Resource Name (ARN) suffix for use with CloudWatch Metrics |
| <a name="output_alb_target_group_name"></a> [alb\_target\_group\_name](#output\_alb\_target\_group\_name) | Name of the target group |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
