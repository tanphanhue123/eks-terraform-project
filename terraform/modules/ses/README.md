# ses

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
| [aws_iam_access_key.ses_smtp_user_iam_access_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.ses_smtp_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.ses_smtp_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_route53_record.ses_verification_dkim_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.ses_verification_mx_record_receiving](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.ses_verification_txt_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ses_active_receipt_rule_set.ses_active_receipt_rule_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_active_receipt_rule_set) | resource |
| [aws_ses_domain_dkim.ses_domain_dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim) | resource |
| [aws_ses_domain_identity.ses_domain_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity) | resource |
| [aws_ses_email_identity.ses_email_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_email_identity) | resource |
| [aws_ses_identity_notification_topic.ses_identity_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_identity_notification_topic) | resource |
| [aws_ses_receipt_rule.ses_receipt_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_receipt_rule) | resource |
| [aws_ses_receipt_rule_set.ses_receipt_rule_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_receipt_rule_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | Region of environment | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | ID of Route53 Hostedzone | `string` | n/a | yes |
| <a name="input_ses_domain_identity"></a> [ses\_domain\_identity](#input\_ses\_domain\_identity) | The domain name to assign to SES | `string` | n/a | yes |
| <a name="input_ses_email_identities"></a> [ses\_email\_identities](#input\_ses\_email\_identities) | List of emails to Provides an SES email identity resource | `list(string)` | `[]` | no |
| <a name="input_ses_email_receiving"></a> [ses\_email\_receiving](#input\_ses\_email\_receiving) | All configurations about SES Email Receiving | <pre>object({<br>    receipt_rule_set_name = string<br>    receipt_rule = object({<br>      name       = string<br>      recipients = list(string)<br>      s3_actions = optional(list(object(<br>        {<br>          position          = number<br>          bucket_name       = string<br>          object_key_prefix = optional(string, null)<br>          kms_key_arn       = optional(string, null)<br>          topic_arn         = optional(string, null)<br>        }<br>      )), [])<br>      sns_actions = optional(list(object(<br>        {<br>          position  = number<br>          topic_arn = string<br>          encoding  = optional(string, null)<br>        }<br>      )), [])<br>      lambda_actions = optional(list(object(<br>        {<br>          position        = number<br>          function_arn    = string<br>          invocation_type = optional(string, null)<br>          topic_arn       = optional(string, null)<br>        }<br>      )), [])<br>    })<br>  })</pre> | `null` | no |
| <a name="input_ses_identity_notification"></a> [ses\_identity\_notification](#input\_ses\_identity\_notification) | The type of notifications that will be published to the specified Amazon SNS topic and The Amazon Resource Name (ARN) of the Amazon SNS topic | <pre>object({<br>    topic_arn = string<br>    type      = list(string)<br>  })</pre> | `null` | no |
| <a name="input_ses_smtp_user"></a> [ses\_smtp\_user](#input\_ses\_smtp\_user) | The user's name and policy of smtp user | <pre>object({<br>    name   = string<br>    policy = string<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ses_smtp_user_name"></a> [ses\_smtp\_user\_name](#output\_ses\_smtp\_user\_name) | Secret access key converted into an SES SMTP username |
| <a name="output_ses_smtp_user_password_v4"></a> [ses\_smtp\_user\_password\_v4](#output\_ses\_smtp\_user\_password\_v4) | Secret access key converted into an SES SMTP password |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
