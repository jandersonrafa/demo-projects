variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "monolith_rust_image" { type = string }
variable "gateway_rust_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# Resource variables
variable "rust_monolith_cpu" { type = number }
variable "rust_monolith_mem" { type = number }
variable "rust_gateway_cpu" { type = number }
variable "rust_gateway_mem" { type = number }

# Count variables
variable "rust_monolith_count" { type = number }
variable "rust_gateway_count" { type = number }

job "rust" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.rust_monolith_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "rust-monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.rust-monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.rust-monolith.entrypoints=rust-monolith",
      ]
    }

    task "monolith" {
      driver = "docker"

      config {
        image        = var.monolith_rust_image
        ports        = ["http"]
        network_mode = "host"
        memory_hard_limit = var.rust_monolith_mem
        cpu_hard_limit    = true
      }

      env {
        DB_HOST     = "127.0.0.1"
        DB_PORT     = "6432"
        DB_USER     = "rust_user"
        DB_PASSWORD = "rust_pass"
        DB_NAME     = var.db_name
        PORT        = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.rust_monolith_cpu
        memory = var.rust_monolith_mem
      }
    }
  }

  group "gateway" {
    count = var.rust_gateway_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "rust-gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.rust-gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.rust-gateway.entrypoints=rust-gateway",
      ]
    }

    task "gateway" {
      driver = "docker"

      config {
        image        = var.gateway_rust_image
        ports        = ["http"]
        network_mode = "host"
        memory_hard_limit = var.rust_gateway_mem
        cpu_hard_limit    = true
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:9109"
        PORT         = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.rust_gateway_cpu
        memory = var.rust_gateway_mem
      }
    }
  }
}
