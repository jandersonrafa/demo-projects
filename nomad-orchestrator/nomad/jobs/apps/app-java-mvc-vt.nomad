variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "postgres_image" { type = string }
variable "traefik_image" { type = string }
variable "monolith_image" { type = string }
variable "gateway_image" { type = string }
variable "monolith_nestjs_image" { type = string }
variable "gateway_nestjs_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

job "app-java-mvc-vt" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = 2

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.monolith.entrypoints=java-monolith",
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
        image        = var.monolith_image
        ports        = ["http"]
        force_pull   = false
        network_mode = "host"
      }

      env {
        SPRING_DATASOURCE_URL      = "jdbc:postgresql://127.0.0.1:5432/${var.db_name}?sslmode=disable"
        SPRING_DATASOURCE_USERNAME = var.db_user
        SPRING_DATASOURCE_PASSWORD = var.db_password
        SERVER_PORT                = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }

  group "gateway" {
    count = 2

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.gateway.entrypoints=java-gateway",
      ]

      check {
        type     = "http"
        path     = "/actuator/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "gateway" {
      driver = "docker"

      config {
        image        = var.gateway_image
        ports        = ["http"]
        network_mode = "host"
        force_pull   = false
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:8084"
        SERVER_PORT  = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
