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

job "app-nestjs" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith-nestjs" {
    count = 2

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "monolith-nestjs"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.monolith-nestjs.rule=PathPrefix(`/`)",
        "traefik.http.routers.monolith-nestjs.entrypoints=nestjs-monolith",
      ]

      check {
        type     = "http"
        path     = "/metrics"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "monolith-nestjs" {
      driver = "docker"

      config {
        image        = var.monolith_nestjs_image
        ports        = ["http"]
        force_pull   = false
        network_mode = "host"
      }

      env {
        PORT                    = "${NOMAD_PORT_http}"
        DB_HOST                 = "127.0.0.1"
        DB_PORT                 = "5432"
        DB_USERNAME             = var.db_user
        DB_PASSWORD             = var.db_password
        DB_NAME                 = var.db_name
        TYPEORM_CONNECTION      = "postgres"
        TYPEORM_HOST            = "127.0.0.1"
        TYPEORM_PORT            = "5432"
        TYPEORM_USERNAME        = var.db_user
        TYPEORM_PASSWORD        = var.db_password
        TYPEORM_DATABASE        = var.db_name
        TYPEORM_ENTITIES        = "dist/**/*.entity.js"
        TYPEORM_MIGRATIONS      = "dist/migrations/*.js"
        TYPEORM_SYNCHRONIZE     = "false"
        TYPEORM_LOGGING         = "false"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }

  group "gateway-nestjs" {
    count = 2

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "gateway-nestjs"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.gateway-nestjs.rule=PathPrefix(`/`)",
        "traefik.http.routers.gateway-nestjs.entrypoints=nestjs-gateway",
      ]

      check {
        type     = "http"
        path     = "/metrics"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "gateway-nestjs" {
      driver = "docker"

      config {
        image        = var.gateway_nestjs_image
        ports        = ["http"]
        network_mode = "host"
        force_pull   = false
      }

      env {
        PORT             = "${NOMAD_PORT_http}"
        MONOLITH_URL     = "http://127.0.0.1:8086"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
