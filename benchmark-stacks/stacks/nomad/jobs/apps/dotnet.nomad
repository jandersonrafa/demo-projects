variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "monolith_dotnet_image" { type = string }
variable "gateway_dotnet_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# Resource variables
variable "dotnet_monolith_cpu" { type = number }
variable "dotnet_monolith_mem" { type = number }
variable "dotnet_gateway_cpu" { type = number }
variable "dotnet_gateway_mem" { type = number }

# Count variables
variable "dotnet_monolith_count" { type = number }
variable "dotnet_gateway_count" { type = number }
variable "dotnet_max_pool_size" { type = number }

job "dotnet" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.dotnet_monolith_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "dotnet-monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.dotnet-monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.dotnet-monolith.entrypoints=dotnet-monolith",
      ]
    }

    task "monolith" {
      driver = "docker"

      config {
        image        = var.monolith_dotnet_image
        ports        = ["http"]
        network_mode = "host"
        cpu_hard_limit    = true
      }

      env {
        DB_HOST     = "127.0.0.1"
        DB_PORT     = "6432"
        DB_USER     = "dotnet_user"
        DB_PASSWORD = "dotnet_pass"
        DB_NAME     = var.db_name
        DB_MAX_POOL_SIZE = var.dotnet_max_pool_size
        PORT        = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.dotnet_monolith_cpu
        memory = var.dotnet_monolith_mem
      }
    }
  }

  group "gateway" {
    count = var.dotnet_gateway_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "dotnet-gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.dotnet-gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.dotnet-gateway.entrypoints=dotnet-gateway",
      ]
    }

    task "gateway" {
      driver = "docker"

      config {
        image        = var.gateway_dotnet_image
        ports        = ["http"]
        network_mode = "host"
        cpu_hard_limit    = true
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:9104"
        PORT         = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.dotnet_gateway_cpu
        memory = var.dotnet_gateway_mem
      }
    }
  }
}
