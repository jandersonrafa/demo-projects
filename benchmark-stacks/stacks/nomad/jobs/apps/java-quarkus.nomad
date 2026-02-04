variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "postgres_image" { type = string }
variable "pgbouncer_image" { type = string }
variable "traefik_image" { type = string }
variable "monolith_mvc_vt_image" { type = string }
variable "gateway_mvc_vt_image" { type = string }
variable "monolith_webflux_image" { type = string }
variable "gateway_webflux_image" { type = string }
variable "monolith_dotnet_image" { type = string }
variable "gateway_dotnet_image" { type = string }
variable "monolith_golang_image" { type = string }
variable "gateway_golang_image" { type = string }
variable "monolith_nestjs_image" { type = string }
variable "gateway_nestjs_image" { type = string }
variable "monolith_fpm_image" { type = string }
variable "gateway_fpm_image" { type = string }
variable "monolith_octane_image" { type = string }
variable "gateway_octane_image" { type = string }
variable "monolith_python_image" { type = string }
variable "gateway_python_image" { type = string }
variable "monolith_rust_image" { type = string }
variable "gateway_rust_image" { type = string }
variable "monolith_quarkus_image" { type = string }
variable "gateway_quarkus_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# Resource variables
variable "postgres_cpu" { type = number }
variable "postgres_mem" { type = number }
variable "pgbouncer_cpu" { type = number }
variable "pgbouncer_mem" { type = number }
variable "traefik_cpu" { type = number }
variable "traefik_mem" { type = number }
variable "app_monolith_cpu" { type = number }
variable "app_monolith_mem" { type = number }
variable "app_gateway_cpu" { type = number }
variable "app_gateway_mem" { type = number }

# Count variables
variable "postgres_count" { type = number }
variable "pgbouncer_count" { type = number }
variable "traefik_count" { type = number }
variable "app_monolith_count" { type = number }
variable "app_gateway_count" { type = number }

job "java-quarkus" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.app_monolith_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "quarkus-monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.quarkus-monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.quarkus-monolith.entrypoints=quarkus-monolith",
      ]

      check {
        type     = "http"
        path     = "/q/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "monolith" {
      driver = "docker"

      config {
        image        = var.monolith_quarkus_image
        ports        = ["http"]
        network_mode = "host"
        force_pull   = false
        memory_hard_limit = var.app_monolith_mem
        cpu_hard_limit    = true
      }

      env {
        DB_USER     = "java_quarkus_user"
        DB_PASSWORD = "java_quarkus_pass"
        DB_URL      = "jdbc:postgresql://127.0.0.1:6432/${var.db_name}"
        PORT        = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.app_monolith_cpu
        memory = var.app_monolith_mem
      }
    }
  }

  group "gateway" {
    count = var.app_gateway_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "quarkus-gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.quarkus-gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.quarkus-gateway.entrypoints=quarkus-gateway",
      ]

      check {
        type     = "http"
        path     = "/q/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "gateway" {
      driver = "docker"

      config {
        image        = var.gateway_quarkus_image
        ports        = ["http"]
        network_mode = "host"
        force_pull   = false
        memory_hard_limit = var.app_gateway_mem
        cpu_hard_limit    = true
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:9110"
        PORT         = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.app_gateway_cpu
        memory = var.app_gateway_mem
      }
    }
  }
}
