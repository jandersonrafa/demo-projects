variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "postgres_image" { type = string }
variable "traefik_image" { type = string }
variable "monolith_image" { type = string }
variable "gateway_image" { type = string }
variable "monolith_nestjs_image" { type = string }
variable "gateway_nestjs_image" { type = string }
variable "prometheus_image" { type = string }
variable "grafana_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }
variable "monitoring_dir" { type = string }

job "monitoring" {
  datacenters = var.datacenters
  type        = "service"

  group "monitoring" {
    count = 1

    network {
      mode = "host"
      port "prometheus" {
        static = 9091
      }
      port "grafana" {
        static = 3000
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

    task "prometheus" {
      driver = "docker"

      config {
        image        = var.prometheus_image
        network_mode = "host"
        args = [
          "--config.file=/local/prometheus.yml",
          "--storage.tsdb.path=/local/data",
          "--web.enable-remote-write-receiver",
          "--storage.tsdb.retention.time=30d",
          "--web.listen-address=:9091"
        ]
      }

      template {
        data        = file("${var.monitoring_dir}/prometheus.yml")
        destination = "local/prometheus.yml"
      }

      resources {
        cpu    = 500
        memory = 1024
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
        data        = file("${var.monitoring_dir}/grafana/provisioning/datasources/datasources.yaml")
        destination = "local/grafana/provisioning/datasources/datasources.yaml"
      }

      template {
        data        = file("${var.monitoring_dir}/grafana/provisioning/dashboards/dashboards.yaml")
        destination = "local/grafana/provisioning/dashboards/dashboards.yaml"
      }

      # Provisioning key dashboards
      template {
        data            = file("${var.monitoring_dir}/grafana/dashboards/node/kpis.json")
        destination     = "local/grafana/dashboards/node/kpis.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/grafana/dashboards/java-mvc-vt/kpis.json")
        destination     = "local/grafana/dashboards/java-mvc-vt/kpis.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/grafana/dashboards/teste-performance/apps-performance.json")
        destination     = "local/grafana/dashboards/teste-performance/apps-performance.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/grafana/dashboards/teste-performance/k6-performance.json")
        destination     = "local/grafana/dashboards/teste-performance/k6-performance.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/grafana/dashboards/nomad/overview.json")
        destination     = "local/grafana/dashboards/nomad/overview.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/grafana/dashboards/nomad/official_nomad.json")
        destination     = "local/grafana/dashboards/nomad/official_official.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/grafana/dashboards/traefik/official_traefik.json")
        destination     = "local/grafana/dashboards/traefik/official_traefik.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      template {
        data            = file("${var.monitoring_dir}/grafana/dashboards/teste-performance/performance-analysis.json")
        destination     = "local/grafana/dashboards/teste-performance/performance-analysis.json"
        left_delimiter  = "[["
        right_delimiter = "]]"
      }

      # For brevity, I'll only include one key dashboard as a demonstration if the user wants more they can add.
      # Or I can mount them if they are locally available, but Nomad 'volumes' in docker driver are tricky with relative paths.
      # Actually, since this is a local environment, I could potentially mount the actual directories from the host.
      # However, for a proper Nomad job, templates are better for portability.
      # I'll try to use a simple approach: just the provisioning for now.
      
      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
