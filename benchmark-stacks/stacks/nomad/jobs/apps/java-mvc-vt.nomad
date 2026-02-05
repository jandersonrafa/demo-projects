variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "monolith_mvc_vt_image" { type = string }
variable "gateway_mvc_vt_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# Resource variables
variable "java_mvc_vt_monolith_cpu" { type = number }
variable "java_mvc_vt_monolith_mem" { type = number }
variable "java_mvc_vt_gateway_cpu" { type = number }
variable "java_mvc_vt_gateway_mem" { type = number }

# Count variables
variable "java_mvc_vt_monolith_count" { type = number }
variable "java_mvc_vt_gateway_count" { type = number }

job "java-mvc-vt" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.java_mvc_vt_monolith_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "mvc-vt-monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.mvc-vt-monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.mvc-vt-monolith.entrypoints=mvc-vt-monolith",
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
        image        = var.monolith_mvc_vt_image
        ports        = ["http"]
        network_mode = "host"
        force_pull   = false
      }

      env {
        DB_HOST     = "127.0.0.1"
        DB_PORT     = "6432"
        DB_USER     = "java_mvcvt_user"
        DB_PASSWORD = "java_mvcvt_pass"
        DB_NAME     = var.db_name
        SERVER_PORT = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.java_mvc_vt_monolith_cpu
        memory = var.java_mvc_vt_monolith_mem
      }
    }
  }

  group "gateway" {
    count = var.java_mvc_vt_gateway_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "mvc-vt-gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.mvc-vt-gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.mvc-vt-gateway.entrypoints=mvc-vt-gateway",
      ]
    }

    task "gateway" {
      driver = "docker"

      config {
        image        = var.gateway_mvc_vt_image
        ports        = ["http"]
        network_mode = "host"
        force_pull   = false
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:9101"
        SERVER_PORT  = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.java_mvc_vt_gateway_cpu
        memory = var.java_mvc_vt_gateway_mem
      }
    }
  }
}
