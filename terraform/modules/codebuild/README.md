# codebuild

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
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codebuild"></a> [codebuild](#input\_codebuild) | All configuration to Provides a CodeBuild Project resource. | <pre>object({<br>    name           = string<br>    queued_timeout = optional(number, 480)<br>    build_timeout  = optional(number, 60)<br>    service_role   = string<br>    source = object({<br>      type      = optional(string, "CODEPIPELINE")<br>      buildspec = string<br>    })<br>    cache = object({<br>      type     = optional(string, "NO_CACHE")<br>      location = optional(string, null)<br>      modes    = optional(list(string), null)<br>    })<br>    artifacts = optional(object({<br>      type = string<br>    }), { type = "CODEPIPELINE" })<br>    environment = object({<br>      compute_type                = string<br>      image                       = string<br>      type                        = optional(string, "LINUX_CONTAINER")<br>      image_pull_credentials_type = optional(string, "CODEBUILD")<br>      variables = optional(list(object({<br>        name  = string<br>        value = any<br>      })), [])<br>    })<br>    s3_logs = optional(object({<br>      encryption_disabled = bool<br>      status              = string<br>      }),<br>      {<br>        encryption_disabled = false<br>        status              = "DISABLED"<br>      }<br>    )<br>  })</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_log_group_retention"></a> [log\_group\_retention](#input\_log\_group\_retention) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_arn"></a> [codebuild\_arn](#output\_codebuild\_arn) | ARN of the CodeBuild project. |
| <a name="output_codebuild_name"></a> [codebuild\_name](#output\_codebuild\_name) | Name of the CodeBuild project. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
