### EBS CSI DRIVER
module "iam_role_ebs_csi_driver" {
  source = "../../../modules/iam-role"
  #basic
  env     = var.env
  project = var.project

  #iam-role
  name    = "ebs-csi-driver"
  service = "eks"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowEksAuthToAssumeRoleForPodIdentity",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "pods.eks.amazonaws.com"
          },
          "Action" : [
            "sts:AssumeRole",
            "sts:TagSession"
          ]
        }
      ]
    }
  )
  iam_default_policy_arn = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
}

### VPC CNI
module "iam_role_vpc_cni" {
  source = "../../../modules/iam-role"
  #basic
  env     = var.env
  project = var.project

  #iam-role
  name    = "vpc-cni"
  service = "eks"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowEksAuthToAssumeRoleForPodIdentity",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "pods.eks.amazonaws.com"
          },
          "Action" : [
            "sts:AssumeRole",
            "sts:TagSession"
          ]
        }
      ]
    }
  )
  iam_default_policy_arn = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
}

### ALB INGRESS CONTROLLER
module "iam_role_eks_lb_controller" {
  source = "../../../modules/iam-role"
  #basic
  env     = var.env
  project = var.project

  #iam-role
  name    = "lb-controller"
  service = "eks"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowEksAuthToAssumeRoleForPodIdentity",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "pods.eks.amazonaws.com"
          },
          "Action" : [
            "sts:AssumeRole",
            "sts:TagSession"
          ]
        }
      ]
    }
  )
  iam_custom_policy = {
    template = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Action" : [
              "iam:CreateServiceLinkedRole"
            ],
            "Resource" : "*",
            "Condition" : {
              "StringEquals" : {
                "iam:AWSServiceName" : "elasticloadbalancing.amazonaws.com"
              }
            }
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ec2:DescribeAccountAttributes",
              "ec2:DescribeAddresses",
              "ec2:DescribeAvailabilityZones",
              "ec2:DescribeInternetGateways",
              "ec2:DescribeVpcs",
              "ec2:DescribeVpcPeeringConnections",
              "ec2:DescribeSubnets",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeInstances",
              "ec2:DescribeNetworkInterfaces",
              "ec2:DescribeTags",
              "ec2:GetCoipPoolUsage",
              "ec2:DescribeCoipPools",
              "ec2:GetSecurityGroupsForVpc",
              "ec2:DescribeIpamPools",
              "ec2:DescribeRouteTables",
              "elasticloadbalancing:DescribeLoadBalancers",
              "elasticloadbalancing:DescribeLoadBalancerAttributes",
              "elasticloadbalancing:DescribeListeners",
              "elasticloadbalancing:DescribeListenerCertificates",
              "elasticloadbalancing:DescribeSSLPolicies",
              "elasticloadbalancing:DescribeRules",
              "elasticloadbalancing:DescribeTargetGroups",
              "elasticloadbalancing:DescribeTargetGroupAttributes",
              "elasticloadbalancing:DescribeTargetHealth",
              "elasticloadbalancing:DescribeTags",
              "elasticloadbalancing:DescribeTrustStores",
              "elasticloadbalancing:DescribeListenerAttributes",
              "elasticloadbalancing:DescribeCapacityReservation"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "cognito-idp:DescribeUserPoolClient",
              "acm:ListCertificates",
              "acm:DescribeCertificate",
              "iam:ListServerCertificates",
              "iam:GetServerCertificate",
              "waf-regional:GetWebACL",
              "waf-regional:GetWebACLForResource",
              "waf-regional:AssociateWebACL",
              "waf-regional:DisassociateWebACL",
              "wafv2:GetWebACL",
              "wafv2:GetWebACLForResource",
              "wafv2:AssociateWebACL",
              "wafv2:DisassociateWebACL",
              "shield:GetSubscriptionState",
              "shield:DescribeProtection",
              "shield:CreateProtection",
              "shield:DeleteProtection"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ec2:AuthorizeSecurityGroupIngress",
              "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ec2:CreateSecurityGroup"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ec2:CreateTags"
            ],
            "Resource" : "arn:aws:ec2:*:*:security-group/*",
            "Condition" : {
              "StringEquals" : {
                "ec2:CreateAction" : "CreateSecurityGroup"
              },
              "Null" : {
                "aws:RequestTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ec2:CreateTags",
              "ec2:DeleteTags"
            ],
            "Resource" : "arn:aws:ec2:*:*:security-group/*",
            "Condition" : {
              "Null" : {
                "aws:RequestTag/elbv2.k8s.aws/cluster" : "true",
                "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ec2:AuthorizeSecurityGroupIngress",
              "ec2:RevokeSecurityGroupIngress",
              "ec2:DeleteSecurityGroup"
            ],
            "Resource" : "*",
            "Condition" : {
              "Null" : {
                "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "elasticloadbalancing:CreateLoadBalancer",
              "elasticloadbalancing:CreateTargetGroup"
            ],
            "Resource" : "*",
            "Condition" : {
              "Null" : {
                "aws:RequestTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "elasticloadbalancing:CreateListener",
              "elasticloadbalancing:DeleteListener",
              "elasticloadbalancing:CreateRule",
              "elasticloadbalancing:DeleteRule"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "elasticloadbalancing:AddTags",
              "elasticloadbalancing:RemoveTags"
            ],
            "Resource" : [
              "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
              "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
              "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ],
            "Condition" : {
              "Null" : {
                "aws:RequestTag/elbv2.k8s.aws/cluster" : "true",
                "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "elasticloadbalancing:AddTags",
              "elasticloadbalancing:RemoveTags"
            ],
            "Resource" : [
              "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
              "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
              "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
              "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
            ]
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "elasticloadbalancing:ModifyLoadBalancerAttributes",
              "elasticloadbalancing:SetIpAddressType",
              "elasticloadbalancing:SetSecurityGroups",
              "elasticloadbalancing:SetSubnets",
              "elasticloadbalancing:DeleteLoadBalancer",
              "elasticloadbalancing:ModifyTargetGroup",
              "elasticloadbalancing:ModifyTargetGroupAttributes",
              "elasticloadbalancing:DeleteTargetGroup",
              "elasticloadbalancing:ModifyListenerAttributes",
              "elasticloadbalancing:ModifyCapacityReservation",
              "elasticloadbalancing:ModifyIpPools"
            ],
            "Resource" : "*",
            "Condition" : {
              "Null" : {
                "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "elasticloadbalancing:AddTags"
            ],
            "Resource" : [
              "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
              "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
              "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ],
            "Condition" : {
              "StringEquals" : {
                "elasticloadbalancing:CreateAction" : [
                  "CreateTargetGroup",
                  "CreateLoadBalancer"
                ]
              },
              "Null" : {
                "aws:RequestTag/elbv2.k8s.aws/cluster" : "false"
              }
            }
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "elasticloadbalancing:RegisterTargets",
              "elasticloadbalancing:DeregisterTargets"
            ],
            "Resource" : "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "elasticloadbalancing:SetWebAcl",
              "elasticloadbalancing:ModifyListener",
              "elasticloadbalancing:AddListenerCertificates",
              "elasticloadbalancing:RemoveListenerCertificates",
              "elasticloadbalancing:ModifyRule",
              "elasticloadbalancing:SetRulePriorities"
            ],
            "Resource" : "*"
          }
        ]
      }
    )
  }
}

### EXTERNAL SECRET
module "iam_role_external_secret" {
  source = "../../../modules/iam-role"
  #basic
  env     = var.env
  project = var.project

  #iam-role
  name    = "external-secret"
  service = "eks"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowEksAuthToAssumeRoleForPodIdentity",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "pods.eks.amazonaws.com"
          },
          "Action" : [
            "sts:AssumeRole",
            "sts:TagSession"
          ]
        }
      ]
    }
  )
  iam_custom_policy = {
    template = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Action" : [
              "secretsmanager:GetResourcePolicy",
              "secretsmanager:GetSecretValue",
              "secretsmanager:DescribeSecret",
              "secretsmanager:ListSecretVersionIds"
            ],
            "Resource" : [
              "*"
            ]
          }
        ]
      }
    )
  }
}

### KARPENTER
module "iam_role_karpenter" {
  source = "../../../modules/iam-role"
  #basic
  env     = var.env
  project = var.project

  #iam-role
  name    = "karpenter"
  service = "eks"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowEksAuthToAssumeRoleForPodIdentity",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "pods.eks.amazonaws.com"
          },
          "Action" : [
            "sts:AssumeRole",
            "sts:TagSession"
          ]
        }
      ]
    }
  )
  iam_custom_policy = {
    template = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "AllowScopedEC2InstanceAccessActions",
            "Effect" : "Allow",
            "Resource" : [
              "arn:aws:ec2:${var.region}::image/*",
              "arn:aws:ec2:${var.region}::snapshot/*",
              "arn:aws:ec2:${var.region}:*:security-group/*",
              "arn:aws:ec2:${var.region}:*:subnet/*",
              "arn:aws:ec2:${var.region}:*:capacity-reservation/*"
            ],
            "Action" : [
              "ec2:RunInstances",
              "ec2:CreateFleet"
            ]
          },
          {
            "Sid" : "AllowScopedEC2LaunchTemplateAccessActions",
            "Effect" : "Allow",
            "Resource" : "arn:aws:ec2:${var.region}:*:launch-template/*",
            "Action" : [
              "ec2:RunInstances",
              "ec2:CreateFleet"
            ],
            "Condition" : {
              "StringEquals" : {
                "aws:ResourceTag/kubernetes.io/cluster/${module.eks_cluster.eks_cluster_name}" : "owned"
              },
              "StringLike" : {
                "aws:ResourceTag/karpenter.sh/nodepool" : "*"
              }
            }
          },
          {
            "Sid" : "AllowScopedEC2InstanceActionsWithTags",
            "Effect" : "Allow",
            "Resource" : [
              "arn:aws:ec2:${var.region}:*:fleet/*",
              "arn:aws:ec2:${var.region}:*:instance/*",
              "arn:aws:ec2:${var.region}:*:volume/*",
              "arn:aws:ec2:${var.region}:*:network-interface/*",
              "arn:aws:ec2:${var.region}:*:launch-template/*",
              "arn:aws:ec2:${var.region}:*:spot-instances-request/*",
              "arn:aws:ec2:${var.region}:*:capacity-reservation/*"
            ],
            "Action" : [
              "ec2:RunInstances",
              "ec2:CreateFleet",
              "ec2:CreateLaunchTemplate"
            ],
            "Condition" : {
              "StringEquals" : {
                "aws:RequestTag/kubernetes.io/cluster/${module.eks_cluster.eks_cluster_name}" : "owned",
                "aws:RequestTag/eks:eks-cluster-name" : "${module.eks_cluster.eks_cluster_name}"
              },
              "StringLike" : {
                "aws:RequestTag/karpenter.sh/nodepool" : "*"
              }
            }
          },
          {
            "Sid" : "AllowScopedResourceCreationTagging",
            "Effect" : "Allow",
            "Resource" : [
              "arn:aws:ec2:${var.region}:*:fleet/*",
              "arn:aws:ec2:${var.region}:*:instance/*",
              "arn:aws:ec2:${var.region}:*:volume/*",
              "arn:aws:ec2:${var.region}:*:network-interface/*",
              "arn:aws:ec2:${var.region}:*:launch-template/*",
              "arn:aws:ec2:${var.region}:*:spot-instances-request/*"
            ],
            "Action" : "ec2:CreateTags",
            "Condition" : {
              "StringEquals" : {
                "aws:RequestTag/kubernetes.io/cluster/${module.eks_cluster.eks_cluster_name}" : "owned",
                "aws:RequestTag/eks:eks-cluster-name" : "${module.eks_cluster.eks_cluster_name}",
                "ec2:CreateAction" : [
                  "RunInstances",
                  "CreateFleet",
                  "CreateLaunchTemplate"
                ]
              },
              "StringLike" : {
                "aws:RequestTag/karpenter.sh/nodepool" : "*"
              }
            }
          },
          {
            "Sid" : "AllowScopedResourceTagging",
            "Effect" : "Allow",
            "Resource" : "arn:aws:ec2:${var.region}:*:instance/*",
            "Action" : "ec2:CreateTags",
            "Condition" : {
              "StringEquals" : {
                "aws:ResourceTag/kubernetes.io/cluster/${module.eks_cluster.eks_cluster_name}" : "owned"
              },
              "StringLike" : {
                "aws:ResourceTag/karpenter.sh/nodepool" : "*"
              },
              "StringEqualsIfExists" : {
                "aws:RequestTag/eks:eks-cluster-name" : "${module.eks_cluster.eks_cluster_name}"
              },
              "ForAllValues:StringEquals" : {
                "aws:TagKeys" : [
                  "eks:eks-cluster-name",
                  "karpenter.sh/nodeclaim",
                  "Name"
                ]
              }
            }
          },
          {
            "Sid" : "AllowScopedDeletion",
            "Effect" : "Allow",
            "Resource" : [
              "arn:aws:ec2:${var.region}:*:instance/*",
              "arn:aws:ec2:${var.region}:*:launch-template/*"
            ],
            "Action" : [
              "ec2:TerminateInstances",
              "ec2:DeleteLaunchTemplate"
            ],
            "Condition" : {
              "StringEquals" : {
                "aws:ResourceTag/kubernetes.io/cluster/${module.eks_cluster.eks_cluster_name}" : "owned"
              },
              "StringLike" : {
                "aws:ResourceTag/karpenter.sh/nodepool" : "*"
              }
            }
          },
          {
            "Sid" : "AllowRegionalReadActions",
            "Effect" : "Allow",
            "Resource" : "*",
            "Action" : [
              "ec2:DescribeCapacityReservations",
              "ec2:DescribeImages",
              "ec2:DescribeInstances",
              "ec2:DescribeInstanceTypeOfferings",
              "ec2:DescribeInstanceTypes",
              "ec2:DescribeLaunchTemplates",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeSpotPriceHistory",
              "ec2:DescribeSubnets"
            ],
            "Condition" : {
              "StringEquals" : {
                "aws:RequestedRegion" : "${var.region}"
              }
            }
          },
          {
            "Sid" : "AllowSSMReadActions",
            "Effect" : "Allow",
            "Resource" : "arn:aws:ssm:${var.region}::parameter/aws/service/*",
            "Action" : "ssm:GetParameter"
          },
          {
            "Sid" : "AllowPricingReadActions",
            "Effect" : "Allow",
            "Resource" : "*",
            "Action" : "pricing:GetProducts"
          },
          {
            "Sid" : "AllowInterruptionQueueActions",
            "Effect" : "Allow",
            "Resource" : "${aws_sqs_queue.karpenter.arn}",
            "Action" : [
              "sqs:DeleteMessage",
              "sqs:GetQueueUrl",
              "sqs:ReceiveMessage"
            ]
          },
          {
            "Sid" : "AllowPassingInstanceRole",
            "Effect" : "Allow",
            "Resource" : "${module.iam_role_node_group.iam_role_arn}",
            "Action" : "iam:PassRole",
            "Condition" : {
              "StringEquals" : {
                "iam:PassedToService" : [
                  "ec2.amazonaws.com",
                  "ec2.amazonaws.com.cn"
                ]
              }
            }
          },
          {
            "Sid" : "AllowScopedInstanceProfileCreationActions",
            "Effect" : "Allow",
            "Resource" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
            "Action" : [
              "iam:CreateInstanceProfile"
            ],
            "Condition" : {
              "StringEquals" : {
                "aws:RequestTag/kubernetes.io/cluster/${module.eks_cluster.eks_cluster_name}" : "owned",
                "aws:RequestTag/eks:eks-cluster-name" : "${module.eks_cluster.eks_cluster_name}",
                "aws:RequestTag/topology.kubernetes.io/region" : "${var.region}"
              },
              "StringLike" : {
                "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" : "*"
              }
            }
          },
          {
            "Sid" : "AllowScopedInstanceProfileTagActions",
            "Effect" : "Allow",
            "Resource" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
            "Action" : [
              "iam:TagInstanceProfile"
            ],
            "Condition" : {
              "StringEquals" : {
                "aws:ResourceTag/kubernetes.io/cluster/${module.eks_cluster.eks_cluster_name}" : "owned",
                "aws:ResourceTag/topology.kubernetes.io/region" : "${var.region}",
                "aws:RequestTag/kubernetes.io/cluster/${module.eks_cluster.eks_cluster_name}" : "owned",
                "aws:RequestTag/eks:eks-cluster-name" : "${module.eks_cluster.eks_cluster_name}",
                "aws:RequestTag/topology.kubernetes.io/region" : "${var.region}"
              },
              "StringLike" : {
                "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" : "*",
                "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" : "*"
              }
            }
          },
          {
            "Sid" : "AllowScopedInstanceProfileActions",
            "Effect" : "Allow",
            "Resource" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
            "Action" : [
              "iam:AddRoleToInstanceProfile",
              "iam:RemoveRoleFromInstanceProfile",
              "iam:DeleteInstanceProfile"
            ],
            "Condition" : {
              "StringEquals" : {
                "aws:ResourceTag/kubernetes.io/cluster/${module.eks_cluster.eks_cluster_name}" : "owned",
                "aws:ResourceTag/topology.kubernetes.io/region" : "${var.region}"
              },
              "StringLike" : {
                "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" : "*"
              }
            }
          },
          {
            "Sid" : "AllowInstanceProfileReadActions",
            "Effect" : "Allow",
            "Resource" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
            "Action" : "iam:GetInstanceProfile"
          },
          {
            "Sid" : "AllowAPIServerEndpointDiscovery",
            "Effect" : "Allow",
            "Resource" : "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/${module.eks_cluster.eks_cluster_name}",
            "Action" : "eks:DescribeCluster"
          }
        ]
      }
    )
  }
  depends_on = [aws_sqs_queue.karpenter]
}

### LOKI
module "iam_role_loki" {
  source = "../../../modules/iam-role"
  #basic
  env     = var.env
  project = var.project

  #iam-role
  name    = "loki"
  service = "eks"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowEksAuthToAssumeRoleForPodIdentity",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "pods.eks.amazonaws.com"
          },
          "Action" : [
            "sts:AssumeRole",
            "sts:TagSession"
          ]
        }
      ]
    }
  )
  iam_custom_policy = {
    template = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "LokiStorage",
            "Effect" : "Allow",
            "Action" : [
              "s3:ListBucket",
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject"
            ],
            "Resource" : [
              "${module.s3_bucket_chunks.s3_bucket_arn}",
              "${module.s3_bucket_chunks.s3_bucket_arn}/*",
              "${module.s3_bucket_ruler.s3_bucket_arn}",
              "${module.s3_bucket_ruler.s3_bucket_arn}/*"
            ]
          }
        ]
      }
    )
  }
}

### EXTERNAL SECRET
# module "iam_role_external_secret" {
#   source = "../../../modules/iam-role"
#   #basic
#   env     = var.env
#   project = var.project

#   #iam-role
#   name    = "external-secret"
#   service = "eks"
#   assume_role_policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Effect" : "Allow",
#           "Principal" : {
#             "Federated" : "${module.eks_cluster.aws_iam_openid_connect_provider_eks_cluster_arn}"
#           },
#           "Action" : "sts:AssumeRoleWithWebIdentity",
#           "Condition" : {
#             "StringEquals" : {
#               "${module.eks_cluster.aws_iam_openid_connect_provider_eks_cluster_url}:sub" : "system:serviceaccount:app:es-sa",
#               "${module.eks_cluster.aws_iam_openid_connect_provider_eks_cluster_url}:aud" : "sts.amazonaws.com"
#             }
#           }
#         }
#       ]
#     }
#   )
#   iam_custom_policy = {
#     template = jsonencode(
#       {
#         "Version" : "2012-10-17",
#         "Statement" : [
#           {
#             "Effect" : "Allow",
#             "Action" : [
#               "secretsmanager:GetResourcePolicy",
#               "secretsmanager:GetSecretValue",
#               "secretsmanager:DescribeSecret",
#               "secretsmanager:ListSecretVersionIds"
#             ],
#             "Resource" : [
#               "*"
#             ]
#           }
#         ]
#       }
#     )
#   }
# }
