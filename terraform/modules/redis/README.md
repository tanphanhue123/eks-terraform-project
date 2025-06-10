# redis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.66.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_parameter_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.redis_replication_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.redis_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |
| <a name="input_redis_name"></a> [redis\_name](#input\_redis\_name) | Name of all resources of this Redis module | `string` | n/a | yes |
| <a name="input_redis_parameters"></a> [redis\_parameters](#input\_redis\_parameters) | Provides an Redis parameter group resources. | <pre>object({<br>    family = string<br>    parameters = optional(list(object({<br>      name  = string<br>      value = string<br>    })), [])<br>  })</pre> | n/a | yes |
| <a name="input_redis_replication_group"></a> [redis\_replication\_group](#input\_redis\_replication\_group) | Provides an Redis resource. | <pre>object({<br>    node_type                  = string<br>    automatic_failover_enabled = optional(bool, false)<br>    multi_az_enabled           = optional(bool, false)<br>    number_cache_clusters      = optional(number, 1)<br>    engine_version             = string<br>    security_group_ids         = list(string)<br>    maintenance_window         = optional(string, "sun:16:00-sun:17:00")<br>    snapshot_window            = optional(string, "17:01-18:31")<br>    snapshot_retention_limit   = optional(number, 7)<br>    sns_topic_arn              = optional(string, "")<br>  })</pre> | n/a | yes |
| <a name="input_redis_subnet_ids"></a> [redis\_subnet\_ids](#input\_redis\_subnet\_ids) | Provides an Redis subnet group resource. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_member_clusters"></a> [member\_clusters](#output\_member\_clusters) | Identifiers of all the nodes that are part of this replication group. |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | Address of the endpoint for the primary node in the replication group, if the cluster mode is disabled. |
| <a name="output_reader_endpoint_address"></a> [reader\_endpoint\_address](#output\_reader\_endpoint\_address) | Address of the endpoint for the reader node in the replication group, if the cluster mode is disabled. |
| <a name="output_redis_replication_group_id"></a> [redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ID of the ElastiCache Replication Group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
