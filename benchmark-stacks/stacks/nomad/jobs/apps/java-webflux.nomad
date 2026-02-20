variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "monolith_webflux_image" { type = string }
variable "gateway_webflux_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# Resource variables
variable "java_webflux_monolith_cpu" { type = number }
variable "java_webflux_monolith_mem" { type = number }
variable "java_webflux_gateway_cpu" { type = number }
variable "java_webflux_gateway_mem" { type = number }

# Count variables
variable "java_webflux_monolith_count" { type = number }
variable "java_webflux_gateway_count" { type = number }
variable "java_webflux_max_pool_size" { type = number }

job "java-webflux" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.java_webflux_monolith_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "webflux-monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.webflux-monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.webflux-monolith.entrypoints=webflux-monolith",
      ]

      check {
        type     = "http"
        path     = "/actuator/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "monolith" {
      driver = "docker"

      config {
        image        = var.monolith_webflux_image
        ports        = ["http"]
        network_mode = "host"
        force_pull   = false
        cpu_hard_limit    = true
      }

      env {
        DB_HOST     = "127.0.0.1"
        DB_PORT     = "6432"
        DB_USER     = "java_webflux_user"
        DB_PASSWORD = "java_webflux_pass"
        DB_NAME     = var.db_name
        DB_MAX_POOL_SIZE = var.java_webflux_max_pool_size
        SERVER_PORT = "${NOMAD_PORT_http}"
      }

      resources {
        cores    = 1
        memory = var.java_webflux_monolith_mem
      }
    }
  }

  group "gateway" {
    count = var.java_webflux_gateway_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "webflux-gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.webflux-gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.webflux-gateway.entrypoints=webflux-gateway",
      ]
    }

    task "gateway" {
      driver = "docker"

      config {
        image        = var.gateway_webflux_image
        ports        = ["http"]
        network_mode = "host"
        force_pull   = false
        cpu_hard_limit    = true
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:9102"
        SERVER_PORT  = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.java_webflux_gateway_cpu
        memory = var.java_webflux_gateway_mem
      }
    }
  }
}
