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

job "postgres" {
  datacenters = var.datacenters
  type = "service"

  group "db" {
    count = 1

    network {
      mode = "host"
      port "db" {
        static = 5432
      }
    }

    service {
      name = "benchmark-db"
      port = "db"
    }

    task "postgres" {
      driver = "docker"

      config {
        image        = "postgres:15-alpine"
        ports        = ["db"]
        network_mode = "host"
      }

      env {
        POSTGRES_DB       = var.db_name
        POSTGRES_USER     = var.db_user
        POSTGRES_PASSWORD = var.db_password
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}