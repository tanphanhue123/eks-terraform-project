# codepipeline

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
| [aws_codepipeline.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codestarnotifications_notification_rule.codepipeline_notification_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codepipeline"></a> [codepipeline](#input\_codepipeline) | All configuration to Provides a CodePipeline. | <pre>object({<br>    name     = string<br>    role_arn = string<br>    artifact_store = object({<br>      bucket_id   = string<br>      kms_key_arn = optional(string, null)<br>      region      = optional(string, null)<br>    })<br>    stages = list(object({<br>      name = string<br>      actions = list(object({<br>        version          = number<br>        run_order        = number<br>        category         = string #Approval, Build, Deploy, Invoke, Source and Test.<br>        name             = string<br>        provider         = string<br>        input_artifacts  = optional(list(string), null)<br>        output_artifacts = optional(list(string), null)<br>        namespace        = optional(string, null)<br>        role_arn         = optional(string, null)<br>        region           = optional(string, null)<br>        configuration    = optional(map(any), {})<br>      }))<br>    }))<br><br>  })</pre> | n/a | yes |
| <a name="input_codepipeline_notification_rule"></a> [codepipeline\_notification\_rule](#input\_codepipeline\_notification\_rule) | Provides a CodeStar Notifications Rule for CodePipeline. | <pre>object({<br>    status      = optional(string, "ENABLED")<br>    detail_type = optional(string, "FULL")<br>    event_type_ids = optional(list(string),<br>      [<br>        #Stage execution<br>        "codepipeline-pipeline-stage-execution-resumed",<br>        #Pipeline execution<br>        "codepipeline-pipeline-pipeline-execution-failed",<br>        "codepipeline-pipeline-pipeline-execution-canceled",<br>        "codepipeline-pipeline-pipeline-execution-started",<br>        "codepipeline-pipeline-pipeline-execution-succeeded",<br>        "codepipeline-pipeline-pipeline-execution-superseded"<br>      ]<br>    )<br>    sns_topic_arn = string<br>  })</pre> | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codepipeline_arn"></a> [codepipeline\_arn](#output\_codepipeline\_arn) | The codepipeline ARN. |
| <a name="output_codepipeline_name"></a> [codepipeline\_name](#output\_codepipeline\_name) | The codepipeline name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
