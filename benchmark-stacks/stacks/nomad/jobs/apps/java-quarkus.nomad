variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "monolith_quarkus_image" { type = string }
variable "gateway_quarkus_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# Resource variables
variable "java_quarkus_monolith_cpu" { type = number }
variable "java_quarkus_monolith_mem" { type = number }
variable "java_quarkus_gateway_cpu" { type = number }
variable "java_quarkus_gateway_mem" { type = number }

# Count variables
variable "java_quarkus_monolith_count" { type = number }
variable "java_quarkus_gateway_count" { type = number }
variable "java_quarkus_max_pool_size" { type = number }

job "java-quarkus" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.java_quarkus_monolith_count

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
        cpu_hard_limit    = true
      }

      env {
        DB_USER     = "java_quarkus_user"
        DB_PASSWORD = "java_quarkus_pass"
        DB_NAME     = var.db_name
        DB_MAX_POOL_SIZE = var.java_quarkus_max_pool_size
        QUARKUS_HTTP_PORT = "${NOMAD_PORT_http}"
        PORT        = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.java_quarkus_monolith_cpu
        memory = var.java_quarkus_monolith_mem
      }
    }
  }

  group "gateway" {
    count = var.java_quarkus_gateway_count

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
        cpu_hard_limit    = true
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:9110"
        PORT         = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.java_quarkus_gateway_cpu
        memory = var.java_quarkus_gateway_mem
      }
    }
  }
}
