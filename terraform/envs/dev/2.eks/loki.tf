###############################################################################
#Loki Helm charts
###############################################################################

resource "helm_release" "loki" {
  name = "loki"

  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  create_namespace = true
  namespace        = "logging"
  version          = "6.30.0"
  values = [
    <<-EOT
        loki:
          auth_enabled: false
          schemaConfig:
            configs:
              - from: "2024-04-01"
                store: tsdb
                object_store: s3
                schema: v13
                index:
                  prefix: loki_index_
                  period: 24h
          storage_config:
            aws:
              region: ${var.region}
              bucketnames: ${module.s3_bucket_chunks.s3_bucket_id}
              s3forcepathstyle: false
          pattern_ingester:
              enabled: true
          limits_config:
            allow_structured_metadata: true
            volume_enabled: true
            retention_period: 672h    #28 days retention
          querier:
            max_concurrent: 2
          storage:
            type: s3
            bucketNames:
                chunks: ${module.s3_bucket_chunks.s3_bucket_id}
                ruler: ${module.s3_bucket_ruler.s3_bucket_id}
            s3:
              region: ${var.region}
        deploymentMode: SingleBinary
        singleBinary:
          replicas: 3
          persistence:
            storageClass: gp2
            accessModes:
              - ReadWriteOnce
            size: 30Gi
        # Zero out replica counts of other deployment modes
        backend:
          replicas: 0
        read:
          replicas: 0
        write:
          replicas: 0

        ingester:
          replicas: 0
        querier:
          replicas: 0
        queryFrontend:
          replicas: 0
        queryScheduler:
          replicas: 0
        distributor:
          replicas: 0
        compactor:
          replicas: 0
        indexGateway:
          replicas: 0
        bloomCompactor:
          replicas: 0
        bloomGateway:
          replicas: 0
    EOT
  ]
  wait = false

  depends_on = [module.eks_cluster]
}
