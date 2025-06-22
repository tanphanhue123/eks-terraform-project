###############################################################################
#External Secret Helm charts
###############################################################################

resource "helm_release" "external-secret" {
  name = "external-secrets"

  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  create_namespace = true
  namespace        = "external-secrets"
  version          = "0.14.4"
  values = [
    <<-EOT
    serviceAccount:
      annotations:
      name: external-secrets
    EOT
  ]
  wait = false

  depends_on = [module.eks_cluster]
}

# ###############################################################################
# # External Secrets Manifest
# ###############################################################################
resource "kubectl_manifest" "eso_secret_store" {
  yaml_body = <<-YAML
    apiVersion: external-secrets.io/v1beta1
    kind: SecretStore
    metadata:
      namespace: app
      name: app-secretstore
    spec:
      provider:
        aws:
          service: SecretsManager
          region: ap-southeast-1       
  YAML

  depends_on = [
    helm_release.external-secret
  ]
}

resource "kubectl_manifest" "eso" {
  yaml_body = <<-YAML
    apiVersion: external-secrets.io/v1beta1
    kind: ExternalSecret
    metadata:
      name: app-external-secret
      namespace: app
    spec:
      refreshInterval: 1h           
      secretStoreRef:
        kind: SecretStore
        name: app-secretstore               
      target:
        name: app-secret
        creationPolicy: Owner
      dataFrom:
      - extract:
          key: ${var.env}/app-secret
  YAML

  depends_on = [
    helm_release.external-secret
  ]
}
