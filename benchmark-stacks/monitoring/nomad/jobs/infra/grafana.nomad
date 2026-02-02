variable "datacenters" { type = list(string) }
variable "grafana_image" { type = string }
variable "prometheus_image" { type = string }
variable "monitoring_dir" { type = string }

job "grafana" {
  datacenters = var.datacenters
  type        = "service"

  group "grafana" {
    count = 1

    network {
      mode = "host"
      port "grafana" {
        static = 3000
      }
    }

    service {
      name = "grafana"
      port = "grafana"
      check {
        type     = "http"
        path     = "/api/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "grafana" {
      driver = "docker"

      config {
        image        = var.grafana_image
        network_mode = "host"
        volumes = [
          "local/grafana/provisioning:/etc/grafana/provisioning",
          "local/grafana/dashboards:/var/lib/grafana/dashboards"
        ]
      }

      env {
        GF_SECURITY_ADMIN_PASSWORD = "admin"
      }

      template {
        data        = file("${var.monitoring_dir}/infra/grafana/provisioning/datasources/datasources.yaml")
        destination = "local/grafana/provisioning/datasources/datasources.yaml"
      }

      template {
        data        = file("${var.monitoring_dir}/infra/grafana/provisioning/dashboards/dashboards.yaml")
        destination = "local/grafana/provisioning/dashboards/dashboards.yaml"
      }

      # Provisioning key dashboards



      template {
        data            = file("${var.monitoring_dir}/infra/grafana/dashboards/teste-performance/apps-performance.json")
        destination     = "local/grafana/dashboards/teste-performance/apps-performance.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/infra/grafana/dashboards/teste-performance/k6-performance.json")
        destination     = "local/grafana/dashboards/teste-performance/k6-performance.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/infra/grafana/dashboards/nomad/overview.json")
        destination     = "local/grafana/dashboards/nomad/overview.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/infra/grafana/dashboards/nomad/official_nomad.json")
        destination     = "local/grafana/dashboards/nomad/official_official.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/infra/grafana/dashboards/traefik/official_traefik.json")
        destination     = "local/grafana/dashboards/traefik/official_traefik.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/infra/grafana/dashboards/teste-performance/performance-analysis.json")
        destination     = "local/grafana/dashboards/teste-performance/performance-analysis.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }
      
      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
