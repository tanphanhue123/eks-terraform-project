###############################################################################
#Alloy Helm charts
###############################################################################

resource "helm_release" "alloy" {
  name = "alloy"

  repository       = "https://grafana.github.io/helm-charts"
  chart            = "alloy"
  create_namespace = true
  namespace        = "logging"
  version          = "1.0.3"
  values = [
    <<-EOT
      alloy:
        configMap:
          # -- Create a new ConfigMap for the config file.
          create: false
          name: alloy-config
          key: config.alloy       
    EOT
  ]
  wait = false

  depends_on = [module.eks_cluster]
}

###############################################################################
# Alloy Manifest
###############################################################################
resource "kubectl_manifest" "alloy" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: alloy-config
      namespace: logging
    data:
      config.alloy: |
         discovery.kubernetes "pods" {
           role = "pod"
         }

         discovery.relabel "pod_logs" {
           targets = discovery.kubernetes.pods.targets
           rule {
             source_labels = ["__meta_kubernetes_namespace"]
             target_label  = "namespace"
           }
           rule {
             source_labels = ["__meta_kubernetes_pod_name"]
             target_label  = "pod"
           }
           rule {
             source_labels = ["__meta_kubernetes_pod_container_name"]
             target_label  = "container"
           }
           rule {
             source_labels = ["__meta_kubernetes_namespace", "__meta_kubernetes_pod_name"]
             separator     = "/"
             target_label  = "job"
           }
           rule {
             source_labels = ["__meta_kubernetes_pod_uid", "__meta_kubernetes_pod_container_name"]
             separator     = "/"
             action        = "replace"
             replacement   = "/var/log/pods/*$1/*.log"
             target_label  = "__path__"
           }
         }

         local.file_match "pod_logs" {
           path_targets = discovery.relabel.pod_logs.output
         }

         loki.source.file "pod_logs" {
           targets    = local.file_match.pod_logs.targets
           forward_to = [loki.process.pod_logs.receiver]
         }

         loki.process "pod_logs" {
           forward_to = [loki.write.loki.receiver]
         }

         loki.write "loki" {
           endpoint {
             url = "http://loki-gateway.logging/loki/api/v1/push"
           }
         }
    YAML

  depends_on = [
    helm_release.alloy
  ]
}
