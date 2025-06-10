###############################################################################
#Prometheus Kube Stack Helm charts
###############################################################################

resource "helm_release" "kube-prometheus" {
  name = "kube-prometheus"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  create_namespace = true
  namespace        = "monitoring"
  version          = "72.6.4"
  values = [
    <<-EOT
      # Prometheus
      prometheus:
        prometheusSpec:
          ruleSelector:
            matchLabels:
              release: prometheus 
          storageSpec:
            volumeClaimTemplate:
              spec:
                storageClassName: gp2
                accessModes: ["ReadWriteOnce"]
                resources:
                  requests:
                    storage: 20Gi

        ingress:
          enabled: true
          ingressClassName: alb
          hosts:
            - prometheus.tanphanhue.shop
          path: /
          pathType: Prefix
          annotations:
            alb.ingress.kubernetes.io/scheme: internet-facing
            alb.ingress.kubernetes.io/target-type: ip
            alb.ingress.kubernetes.io/load-balancer-name: pet-dev-alb-chatapp
            alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}, {"HTTPS":443}]'
            alb.ingress.kubernetes.io/ssl-redirect: '443'
            alb.ingress.kubernetes.io/healthcheck-path: /alerts
            alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:ap-southeast-1:034362049682:certificate/660d4feb-1023-4418-884a-2abbcb9e613b
            alb.ingress.kubernetes.io/group.name: app
            alb.ingress.kubernetes.io/group.order: '20'

      # Grafana
      grafana:
        persistence:
          enabled: true
          type: sts
          storageClassName: "gp2"
          accessModes:
            - ReadWriteOnce
          size: 20Gi
          finalizers:
          - kubernetes.io/pvc-protection
        sidecar:
         datasources:
           defaultDatasourceEnabled: true
        additionalDataSources:
         - name: Loki
           type: loki
           url: http://loki-gateway.logging
        adminPassword: ${data.aws_ssm_parameter.grafana_admin_password.value}
        ingress:
          enabled: true
          ingressClassName: alb
          hosts:
            - grafana.tanphanhue.shop
          path: /
          pathType: Prefix
          annotations:
            alb.ingress.kubernetes.io/scheme: internet-facing
            alb.ingress.kubernetes.io/target-type: ip
            alb.ingress.kubernetes.io/healthcheck-path: /login
            alb.ingress.kubernetes.io/load-balancer-name: pet-dev-alb-chatapp
            alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}, {"HTTPS":443}]'
            alb.ingress.kubernetes.io/ssl-redirect: '443'
            alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:ap-southeast-1:034362049682:certificate/660d4feb-1023-4418-884a-2abbcb9e613b
            alb.ingress.kubernetes.io/group.name: app
            alb.ingress.kubernetes.io/group.order: '30'

      # Alert Manager
      alertmanager:
        enabled: true
        config:
          global:
            resolve_timeout: 5m
            slack_api_url: '${data.aws_ssm_parameter.alert_webhook.value}'    
          route:
            group_by: ['alertname', 'job', 'severity']
            group_wait: 30s
            group_interval: 5m
            repeat_interval: 12h
            receiver: 'slack-notifications'
            routes:
              - match:
                  severity: critical
                receiver: 'slack-notifications'
                continue: true
              - match:
                  severity: warning
                receiver: 'slack-notifications'
                continue: true

          receivers:
            - name: 'slack-notifications'
              slack_configs:
                - channel: 'infra-alarms'
                  color: '{{ template "slack.color" . }}'
                  title: '{{ template "slack.title" . }}'
                  text: '{{ template "slack.text" . }}'
                  send_resolved: true
                  actions:
                    - type: button
                      text: 'Runbook :green_book:'
                      url: '{{ (index .Alerts 0).Annotations.runbook_url }}'
                    - type: button
                      text: 'Query :mag:'
                      url: '{{ (index .Alerts 0).GeneratorURL }}'
                    - type: button
                      text: 'Dashboard :chart_with_upwards_trend:'
                      url: '{{ (index .Alerts 0).Annotations.dashboard_url }}'
                    - type: button
                      text: 'Silence :no_bell:'
                      url: '{{ template "__alert_silence_link" . }}'

        templateFiles:
            slack.tmpl: |-
              {{/* Alertmanager Silence link */}}
              {{ define "__alert_silence_link" -}}
                  {{ .ExternalURL }}/#/silences/new?filter=%7B
                  {{- range .CommonLabels.SortedPairs -}}
                      {{- if ne .Name "alertname" -}}
                          {{- .Name }}%3D"{{- .Value -}}"%2C%20
                      {{- end -}}
                  {{- end -}}
                  alertname%3D"{{- .CommonLabels.alertname -}}"%7D
              {{- end }}

              {{/* Severity of the alert */}}
              {{ define "__alert_severity" -}}
                  {{- if eq .CommonLabels.severity "critical" -}}
                  *Severity:* `Critical`
                  {{- else if eq .CommonLabels.severity "warning" -}}
                  *Severity:* `Warning`
                  {{- else if eq .CommonLabels.severity "info" -}}
                  *Severity:* `Info`
                  {{- else -}}
                  *Severity:* :question: {{ .CommonLabels.severity }}
                  {{- end }}
              {{- end }}

              {{/* Title of the Slack alert */}}
              {{ define "slack.title" -}}
                [{{ .Status | toUpper -}}
                {{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{- end -}}
                ] {{ .CommonLabels.alertname }}
              {{- end }}


              {{/* Color of Slack attachment (appears as line next to alert )*/}}
              {{ define "slack.color" -}}
                  {{ if eq .Status "firing" -}}
                      {{ if eq .CommonLabels.severity "warning" -}}
                          warning
                      {{- else if eq .CommonLabels.severity "critical" -}}
                          danger
                      {{- else -}}
                          #439FE0
                      {{- end -}}
                  {{ else -}}
                  good
                  {{- end }}
              {{- end }}

              {{/* The text to display in the alert */}}
              {{ define "slack.text" -}}

                  {{ template "__alert_severity" . }}
                  {{- if (index .Alerts 0).Annotations.summary }}
                  {{- "\n" -}}
                  *Summary:* {{ (index .Alerts 0).Annotations.summary }}
                  {{- end }}

                  {{ range .Alerts }}

                      {{- if .Annotations.description }}
                      {{- "\n" -}}
                      {{ .Annotations.description }}
                      {{- "\n" -}}
                      {{- end }}
                      {{- if .Annotations.message }}
                      {{- "\n" -}}
                      {{ .Annotations.message }}
                      {{- "\n" -}}
                      {{- end }}

                  {{- end }}

              {{- end }}

        alertmanagerSpec:
          storage:
            volumeClaimTemplate:
              spec:
                storageClassName: gp2
                accessModes: ["ReadWriteOnce"]
                resources:
                  requests:
                    storage: 20Gi

        ingress:
          enabled: true
          ingressClassName: alb
          hosts:
            - alert-manager.tanphanhue.shop
          path: /
          pathType: Prefix
          annotations:
            alb.ingress.kubernetes.io/scheme: internet-facing
            alb.ingress.kubernetes.io/target-type: ip
            alb.ingress.kubernetes.io/load-balancer-name: pet-dev-alb-chatapp
            alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}, {"HTTPS":443}]'
            alb.ingress.kubernetes.io/ssl-redirect: '443'
            alb.ingress.kubernetes.io/healthcheck-path: /metrics
            alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:ap-southeast-1:034362049682:certificate/660d4feb-1023-4418-884a-2abbcb9e613b
            alb.ingress.kubernetes.io/group.name: app
            alb.ingress.kubernetes.io/group.order: '40'
    EOT
  ]
  wait = false

  depends_on = [module.eks_cluster]
}

###############################################################################
# Prometheus Rules Manifest
###############################################################################
resource "kubectl_manifest" "prometheus_rules" {
  yaml_body = <<-YAML
    apiVersion: monitoring.coreos.com/v1
    kind: PrometheusRule
    metadata:
      name: system-monitoring-rules
      labels:
        release: prometheus
    spec:
      groups:
        - name: host.rules
          rules:
            # Memory Alerts
            - alert: HostOutOfMemory
              expr: (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes < 0.10)
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host out of memory (instance {{ $labels.instance }})
                description: "Node memory is filling up (< 10% left)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            # CPU Alerts
            - alert: HostHighCpuLoad
              expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[2m])) * 100) > 80
              for: 0m
              labels:
                severity: warning
              annotations:
                summary: Host high CPU load (instance {{ $labels.instance }})
                description: "CPU load is > 80%\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            # Disk Alerts
            - alert: HostOutOfDiskSpace
              expr: (node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes < 10 and ON (instance, device, mountpoint) node_filesystem_readonly == 0
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host out of disk space (instance {{ $labels.instance }})
                description: "Disk is almost full (< 10% left)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: HostDiskWillFillIn24Hours
              expr: (node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes < 10 and ON (instance, device, mountpoint) predict_linear(node_filesystem_avail_bytes{fstype!~"tmpfs"}[1h], 24*3600) < 0 and ON (instance, device, mountpoint) node_filesystem_readonly == 0
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host disk will fill in 24 hours (instance {{ $labels.instance }})
                description: "Filesystem is predicted to run out of space within the next 24 hours at current write rate\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: HostUnusualDiskReadRate
              expr: sum by (instance) (rate(node_disk_read_bytes_total[2m])) / 1024 / 1024 > 50
              for: 5m
              labels:
                severity: warning
              annotations:
                summary: Host unusual disk read rate (instance {{ $labels.instance }})
                description: "Disk is probably reading too much data (> 50 MB/s)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: HostUnusualDiskWriteRate
              expr: sum by (instance) (rate(node_disk_written_bytes_total[2m])) / 1024 / 1024 > 50
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host unusual disk write rate (instance {{ $labels.instance }})
                description: "Disk is probably writing too much data (> 50 MB/s)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            # System Alerts
            - alert: HostUnusualDiskReadLatency
              expr: rate(node_disk_read_time_seconds_total[1m]) / rate(node_disk_reads_completed_total[1m]) > 0.1 and rate(node_disk_reads_completed_total[1m]) > 0
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host unusual disk read latency (instance {{ $labels.instance }})
                description: "Disk latency is growing (read operations > 100ms)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: HostUnusualDiskWriteLatency
              expr: rate(node_disk_write_time_seconds_total[1m]) / rate(node_disk_writes_completed_total[1m]) > 0.1 and rate(node_disk_writes_completed_total[1m]) > 0
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Host unusual disk write latency (instance {{ $labels.instance }})
                description: "Disk latency is growing (write operations > 100ms)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            # Container Alerts
            - alert: ContainerHighCpuUtilization
              expr: (sum(rate(container_cpu_usage_seconds_total{container!=""}[5m])) by (pod, container) / sum(container_spec_cpu_quota{container!=""}/container_spec_cpu_period{container!=""}) by (pod, container) * 100) > 80
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Container High CPU utilization (instance {{ $labels.instance }})
                description: "Container CPU utilization is above 80%\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"  

            - alert: ContainerHighMemoryUsage
              expr: (sum(container_memory_working_set_bytes{name!=""}) BY (instance, name) / sum(container_spec_memory_limit_bytes > 0) BY (instance, name) * 100) > 80
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Container High Memory usage (instance {{ $labels.instance }})
                description: "Container Memory usage is above 80%\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: ContainerVolumeUsage
              expr: (1 - (sum(container_fs_inodes_free{name!=""}) BY (instance) / sum(container_fs_inodes_total) BY (instance))) * 100 > 80
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Container Volume usage (instance {{ $labels.instance }})
                description: "Container Volume usage is above 80%\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: ContainerHighThrottleRate
              expr: sum(increase(container_cpu_cfs_throttled_periods_total{container!=""}[5m])) by (container, pod, namespace) / sum(increase(container_cpu_cfs_periods_total[5m])) by (container, pod, namespace) > ( 25 / 100 )
              for: 5m
              labels:
                severity: warning
              annotations:
                summary: Container high throttle rate (instance {{ $labels.instance }})
                description: "Container is being throttled\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: ContainerLowCpuUtilization
              expr: (sum(rate(container_cpu_usage_seconds_total{container!=""}[5m])) by (pod, container) / sum(container_spec_cpu_quota{container!=""}/container_spec_cpu_period{container!=""}) by (pod, container) * 100) < 20
              for: 7d
              labels:
                severity: info
              annotations:
                summary: Container Low CPU utilization (instance {{ $labels.instance }})
                description: "Container CPU utilization is under 20% for 1 week. Consider reducing the allocated CPU.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: ContainerLowMemoryUsage
              expr: (sum(container_memory_working_set_bytes{name!=""}) BY (instance, name) / sum(container_spec_memory_limit_bytes > 0) BY (instance, name) * 100) < 20
              for: 7d
              labels:
                severity: info
              annotations:
                summary: Container Low Memory usage (instance {{ $labels.instance }})
                description: "Container Memory usage is under 20% for 1 week. Consider reducing the allocated memory.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: KubernetesContainerOomKiller
              expr: (kube_pod_container_status_restarts_total - kube_pod_container_status_restarts_total offset 10m >= 1) and ignoring (reason) min_over_time(kube_pod_container_status_last_terminated_reason{reason="OOMKilled"}[10m]) == 1
              for: 0m
              labels:
                severity: warning
              annotations:
                summary: Kubernetes Container oom killer (instance {{ $labels.instance }})
                description: "Container {{ $labels.container }} in pod {{ $labels.namespace }}/{{ $labels.pod }} has been OOMKilled {{ $value }} times in the last 10 minutes.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: KubernetesPersistentvolumeclaimPending
              expr: kube_persistentvolumeclaim_status_phase{phase="Pending"} == 1
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Kubernetes PersistentVolumeClaim pending (instance {{ $labels.instance }})
                description: "PersistentVolumeClaim {{ $labels.namespace }}/{{ $labels.persistentvolumeclaim }} is pending\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: KubernetesVolumeOutOfDiskSpace
              expr: kubelet_volume_stats_available_bytes / kubelet_volume_stats_capacity_bytes * 100 < 10
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Kubernetes Volume out of disk space (instance {{ $labels.instance }})
                description: "Volume is almost full (< 10% left)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: KubernetesPersistentvolumeError
              expr: kube_persistentvolume_status_phase{phase=~"Failed|Pending", job="kube-state-metrics"} > 0
              for: 0m
              labels:
                severity: critical
              annotations:
                summary: Kubernetes PersistentVolume error (instance {{ $labels.instance }})
                description: "Persistent volume {{ $labels.persistentvolume }} is in bad state\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

            - alert: KubernetesPodNotHealthy
              expr: sum by (namespace, pod) (kube_pod_status_phase{phase=~"Pending|Unknown|Failed"}) > 0
              for: 15m
              labels:
                severity: critical
              annotations:
                summary: Kubernetes Pod not healthy (instance {{ $labels.instance }})
                description: "Pod {{ $labels.namespace }}/{{ $labels.pod }} has been in a non-running state for longer than 15 minutes.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
            - alert: KubernetesPodCrashLooping
              expr: increase(kube_pod_container_status_restarts_total[1m]) > 3
              for: 2m
              labels:
                severity: warning
              annotations:
                summary: Kubernetes pod crash looping (instance {{ $labels.instance }})
                description: "Pod {{ $labels.namespace }}/{{ $labels.pod }} is crash looping\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
    YAML

  depends_on = [
    helm_release.kube-prometheus
  ]
}
