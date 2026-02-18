variable "datacenters" { type = list(string) }
variable "prometheus_image" { type = string }
variable "grafana_image" { type = string }
variable "monitoring_dir" { type = string }

job "prometheus" {
  datacenters = var.datacenters
  type        = "service"

  group "prometheus" {
    count = 1

    # Configure host volume for persistent data
    volume "prometheus-data" {
      type      = "host"
      source    = "prometheus-data"
      read_only = false
    }

    network {
      mode = "host"
      port "prometheus" {
        static = 9091
      }
    }

    service {
      name = "prometheus"
      port = "prometheus"
      check {
        type     = "http"
        path     = "/-/healthy"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "prometheus" {
      driver = "docker"

      # Mount the persistent volume
      volume_mount {
        volume      = "prometheus-data"
        destination = "/prometheus"
        read_only   = false
      }

      config {
        image        = var.prometheus_image
        network_mode = "host"
        args = [
          "--config.file=/local/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.enable-remote-write-receiver",
          "--storage.tsdb.retention.time=30d",
          "--web.listen-address=:9091"
        ]
      }

      template {
        data        = file("${var.monitoring_dir}/infra/prometheus/prometheus.yml")
        destination = "local/prometheus.yml"
      }

      resources {
        cpu    = 500
        memory = 1024
      }
    }
  }
}
