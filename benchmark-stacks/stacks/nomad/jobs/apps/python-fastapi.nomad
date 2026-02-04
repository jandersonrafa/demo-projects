variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "monolith_python_image" { type = string }
variable "gateway_python_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# Resource variables
variable "python_fastapi_monolith_cpu" { type = number }
variable "python_fastapi_monolith_mem" { type = number }
variable "python_fastapi_gateway_cpu" { type = number }
variable "python_fastapi_gateway_mem" { type = number }

# Count variables
variable "python_fastapi_monolith_count" { type = number }
variable "python_fastapi_gateway_count" { type = number }

job "python-fastapi" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.python_fastapi_monolith_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "python-monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.python-monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.python-monolith.entrypoints=python-monolith",
      ]
    }

    task "monolith" {
      driver = "docker"

      config {
        image        = var.monolith_python_image
        ports        = ["http"]
        network_mode = "host"
        memory_hard_limit = var.python_fastapi_monolith_mem
        cpu_hard_limit    = true
      }

      env {
        DB_URL     = "postgresql+asyncpg://python_fastapi_user:python_fastapi_pass@127.0.0.1:6432/${var.db_name}"
        PORT       = "${NOMAD_PORT_http}"
        PROMETHEUS_MULTIPROC_DIR = "/tmp/prometheus_multiproc"
      }

      resources {
        cpu    = var.python_fastapi_monolith_cpu
        memory = var.python_fastapi_monolith_mem
      }
    }
  }

  group "gateway" {
    count = var.python_fastapi_gateway_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "python-gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.python-gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.python-gateway.entrypoints=python-gateway",
      ]
    }

    task "gateway" {
      driver = "docker"

      config {
        image        = var.gateway_python_image
        ports        = ["http"]
        network_mode = "host"
        memory_hard_limit = var.python_fastapi_gateway_mem
        cpu_hard_limit    = true
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:9108"
        PORT         = "${NOMAD_PORT_http}"
        PROMETHEUS_MULTIPROC_DIR = "/tmp/prometheus_multiproc"
      }

      resources {
        cpu    = var.python_fastapi_gateway_cpu
        memory = var.python_fastapi_gateway_mem
      }
    }
  }
}
