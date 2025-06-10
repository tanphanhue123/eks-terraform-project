<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.91.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.9.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.91.0 |
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider\_aws.virginia) | 5.91.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.9.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.19.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr_app"></a> [ecr\_app](#module\_ecr\_app) | ../../../modules/ecr | n/a |
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | ../../../modules/eks | n/a |
| <a name="module_iam_role_ebs_csi_driver"></a> [iam\_role\_ebs\_csi\_driver](#module\_iam\_role\_ebs\_csi\_driver) | ../../../modules/iam-role | n/a |
| <a name="module_iam_role_eks_cluster"></a> [iam\_role\_eks\_cluster](#module\_iam\_role\_eks\_cluster) | ../../../modules/iam-role | n/a |
| <a name="module_iam_role_eks_lb_controller"></a> [iam\_role\_eks\_lb\_controller](#module\_iam\_role\_eks\_lb\_controller) | ../../../modules/iam-role | n/a |
| <a name="module_iam_role_external_secret"></a> [iam\_role\_external\_secret](#module\_iam\_role\_external\_secret) | ../../../modules/iam-role | n/a |
| <a name="module_iam_role_karpenter"></a> [iam\_role\_karpenter](#module\_iam\_role\_karpenter) | ../../../modules/iam-role | n/a |
| <a name="module_iam_role_loki"></a> [iam\_role\_loki](#module\_iam\_role\_loki) | ../../../modules/iam-role | n/a |
| <a name="module_iam_role_node_group"></a> [iam\_role\_node\_group](#module\_iam\_role\_node\_group) | ../../../modules/iam-role | n/a |
| <a name="module_iam_role_vpc_cni"></a> [iam\_role\_vpc\_cni](#module\_iam\_role\_vpc\_cni) | ../../../modules/iam-role | n/a |
| <a name="module_s3_bucket_chunks"></a> [s3\_bucket\_chunks](#module\_s3\_bucket\_chunks) | ../../../modules/s3 | n/a |
| <a name="module_s3_bucket_ruler"></a> [s3\_bucket\_ruler](#module\_s3\_bucket\_ruler) | ../../../modules/s3 | n/a |
| <a name="module_security_group_eks_cluster"></a> [security\_group\_eks\_cluster](#module\_security\_group\_eks\_cluster) | ../../../modules/sg | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.karpenter](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.karpenter](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/resources/cloudwatch_event_target) | resource |
| [aws_sqs_queue.karpenter](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.karpenter](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/resources/sqs_queue_policy) | resource |
| [helm_release.alloy](https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release) | resource |
| [helm_release.aws_lbc](https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release) | resource |
| [helm_release.external-secret](https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release) | resource |
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release) | resource |
| [helm_release.kube-prometheus](https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release) | resource |
| [helm_release.loki](https://registry.terraform.io/providers/hashicorp/helm/2.9.0/docs/resources/release) | resource |
| [kubectl_manifest.alloy](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.eso](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.eso_secret_store](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_node_class](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_node_pool](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.prometheus_rules](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/data-sources/caller_identity) | data source |
| [aws_ecrpublic_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/data-sources/ecrpublic_authorization_token) | data source |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.eks](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.queue](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.alert_webhook](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.argocd_token](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/aws/5.91.0/docs/data-sources/ssm_parameter) | data source |
| [terraform_remote_state.general](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR of VPC | <pre>object({<br/>    vpc      = string<br/>    publics  = list(string)<br/>    privates = list(string)<br/>  })</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_global_ips"></a> [global\_ips](#input\_global\_ips) | All Public IPs are allowed on AWS ALB | `map(any)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region of environment | `string` | n/a | yes |
| <a name="input_service_ipv4_cidr"></a> [service\_ipv4\_cidr](#input\_service\_ipv4\_cidr) | Service ipv4 cidr | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_account_id"></a> [aws\_account\_id](#output\_aws\_account\_id) | Show information about project, environment and account |
| <a name="output_configure_kubectl"></a> [configure\_kubectl](#output\_configure\_kubectl) | Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
