###############################################################################
#Karpenter Helm charts
###############################################################################

resource "helm_release" "karpenter" {
  name                = "karpenter"
  namespace           = "karpenter"
  create_namespace    = true
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "1.2.0"
  wait                = false

  values = [
    <<-EOT
    nodeSelector:
      karpenter.sh/controller: 'true'
    settings:
      clusterName: ${module.eks_cluster.eks_cluster_name}
      clusterEndpoint: ${module.eks_cluster.eks_cluster_endpoint}
      interruptionQueue: ${aws_sqs_queue.karpenter.name}
    tolerations:
      - key: CriticalAddonsOnly
        operator: Exists
      - key: karpenter.sh/controller
        operator: Exists
        effect: NoSchedule
    webhook:
      enabled: false
    EOT
  ]

  lifecycle {
    ignore_changes = [
      repository_password
    ]
  }

  depends_on = [
    module.eks_cluster
  ]
}

###############################################################################
# Karpenter Manifest
###############################################################################
resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: default
    spec:
      template:
        spec:
          requirements:
            - key: kubernetes.io/arch
              operator: In
              values: ["amd64"]
            - key: kubernetes.io/os
              operator: In
              values: ["linux"]
            - key: karpenter.sh/capacity-type
              operator: In
              values: ["on-demand", "spot"]
            - key: karpenter.k8s.aws/instance-category
              operator: In
              values: ["t", "c"]
            - key: karpenter.k8s.aws/instance-size
              operator: NotIn
              values: ["nano", "micro"]
            - key: karpenter.k8s.aws/instance-generation
              operator: Gt
              values: ["2"]
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: default
          expireAfter: Never 
      limits:
        cpu: 100
      disruption:
        consolidationPolicy: WhenEmptyOrUnderutilized
        consolidateAfter: 5m    
  YAML

  depends_on = [
    kubectl_manifest.karpenter_node_class
  ]
}

resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      role: "${module.iam_role_node_group.iam_role_name}"
      amiSelectorTerms:
        - alias: "al2023@latest"
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: "${module.eks_cluster.eks_cluster_name}" 
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: "${module.eks_cluster.eks_cluster_name}" 
  YAML

  depends_on = [
    helm_release.karpenter, module.eks_cluster
  ]
}
