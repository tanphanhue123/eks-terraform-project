# rds-aurora

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.aurora_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_event_subscription.aurora_event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription) | resource |
| [aws_db_parameter_group.aurora_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.aurora_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_rds_cluster.aurora_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.aurora_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.aurora_cluster_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aurora_cluster"></a> [aurora\_cluster](#input\_aurora\_cluster) | Provides an RDS Aurora Cluster resource. | <pre>object({<br>    engine                       = string<br>    engine_version               = string<br>    database_name                = string<br>    master_username              = string<br>    master_password              = string<br>    skip_final_snapshot          = optional(bool, true)<br>    copy_tags_to_snapshot        = optional(bool, true)<br>    backup_retention_period      = optional(number, 7)<br>    preferred_backup_window      = optional(string, "17:01-17:31")<br>    preferred_maintenance_window = optional(string, "sun:16:00-sun:17:00")<br>    security_group_ids           = list(string)<br>    port                         = optional(number, null)<br>    apply_immediately            = optional(bool, true)<br>    enable_cloudwatch_logs       = optional(list(string), ["audit", "error", "slowquery"])<br>    storage_encrypted            = optional(bool, true)<br>    kms_key_id                   = optional(string, null)<br>    allow_major_version_upgrade  = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_aurora_event"></a> [aurora\_event](#input\_aurora\_event) | (Optional) The variable provides a DB event subscription resource. | <pre>object({<br>    source_type = optional(string, "db-cluster")<br>    event_categories = optional(list(string), [<br>      "failover",<br>      "failure",<br>      "maintenance",<br>      "notification",<br>    ])<br>    sns_topic_arn = string<br>  })</pre> | `null` | no |
| <a name="input_aurora_instance"></a> [aurora\_instance](#input\_aurora\_instance) | Provides an RDS Aurora Instance resources. | <pre>object({<br>    number                       = number<br>    instance_class               = string<br>    copy_tags_to_snapshot        = optional(bool, true)<br>    apply_immediately            = optional(bool, true)<br>    auto_minor_version_upgrade   = optional(bool, false)<br>    publicly_accessible          = optional(bool, false)<br>    performance_insights_enabled = optional(bool, false)<br>    monitoring_interval          = optional(number, 0)<br>    monitoring_role_arn          = optional(string, null)<br>  })</pre> | n/a | yes |
| <a name="input_aurora_log_group_retention"></a> [aurora\_log\_group\_retention](#input\_aurora\_log\_group\_retention) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `30` | no |
| <a name="input_aurora_parameter_group"></a> [aurora\_parameter\_group](#input\_aurora\_parameter\_group) | Provides an RDS Cluster & DB parameter group resources. | <pre>object({<br>    family = string<br>    cluster_parameters = optional(list(object({<br>      name         = string<br>      value        = string<br>      apply_method = optional(string, null)<br>    })), [])<br>    parameters = optional(list(object({<br>      name         = string<br>      value        = string<br>      apply_method = optional(string, null)<br>    })), [])<br>  })</pre> | n/a | yes |
| <a name="input_aurora_subnet_ids"></a> [aurora\_subnet\_ids](#input\_aurora\_subnet\_ids) | Provides an RDS DB subnet group resource. | `list(string)` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of all resources of this RDS Aurora module | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aurora_cluster_endpoint"></a> [aurora\_cluster\_endpoint](#output\_aurora\_cluster\_endpoint) | The DNS address of the RDS instance |
| <a name="output_aurora_cluster_identifier"></a> [aurora\_cluster\_identifier](#output\_aurora\_cluster\_identifier) | The RDS Cluster Identifier |
| <a name="output_aurora_cluster_name"></a> [aurora\_cluster\_name](#output\_aurora\_cluster\_name) | The RDS Cluster Name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
