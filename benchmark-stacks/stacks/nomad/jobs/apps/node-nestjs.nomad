variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "monolith_nestjs_image" { type = string }
variable "gateway_nestjs_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# Resource variables
variable "node_nestjs_monolith_cpu" { type = number }
variable "node_nestjs_monolith_mem" { type = number }
variable "node_nestjs_gateway_cpu" { type = number }
variable "node_nestjs_gateway_mem" { type = number }

# Count variables
variable "node_nestjs_monolith_count" { type = number }
variable "node_nestjs_gateway_count" { type = number }

job "node-nestjs" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.node_nestjs_monolith_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "nestjs-monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.nestjs-monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.nestjs-monolith.entrypoints=nestjs-monolith",
      ]
    }

    task "monolith" {
      driver = "docker"

      config {
        image        = var.monolith_nestjs_image
        ports        = ["http"]
        network_mode = "host"
        cpu_hard_limit    = true
      }

      env {
        DB_HOST     = "127.0.0.1"
        DB_PORT     = "6432"
        DB_USER     = "nodejs_user"
        DB_PASSWORD = "nodejs_pass"
        DB_NAME     = var.db_name
        PORT        = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.node_nestjs_monolith_cpu
        memory = var.node_nestjs_monolith_mem
      }
    }
  }

  group "gateway" {
    count = var.node_nestjs_gateway_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "nestjs-gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.nestjs-gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.nestjs-gateway.entrypoints=nestjs-gateway",
      ]
    }

    task "gateway" {
      driver = "docker"

      config {
        image        = var.gateway_nestjs_image
        ports        = ["http"]
        network_mode = "host"
        cpu_hard_limit    = true
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:9103"
        PORT         = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.node_nestjs_gateway_cpu
        memory = var.node_nestjs_gateway_mem
      }
    }
  }
}
