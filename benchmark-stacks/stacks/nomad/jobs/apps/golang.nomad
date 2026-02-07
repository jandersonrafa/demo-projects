variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "monolith_golang_image" { type = string }
variable "gateway_golang_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# Resource variables
variable "golang_monolith_cpu" { type = number }
variable "golang_monolith_mem" { type = number }
variable "golang_gateway_cpu" { type = number }
variable "golang_gateway_mem" { type = number }

# Count variables
variable "golang_monolith_count" { type = number }
variable "golang_gateway_count" { type = number }

job "golang" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.golang_monolith_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "golang-monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.golang-monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.golang-monolith.entrypoints=golang-monolith",
      ]
    }

    task "monolith" {
      driver = "docker"

      config {
        image        = var.monolith_golang_image
        ports        = ["http"]
        network_mode = "host"
        cpu_hard_limit    = true
      }

      env {
        DB_HOST     = "127.0.0.1"
        DB_PORT     = "6432"
        DB_USER     = "golang_user"
        DB_PASSWORD = "golang_pass"
        DB_NAME     = var.db_name
        PORT        = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.golang_monolith_cpu
        memory = var.golang_monolith_mem
      }
    }
  }

  group "gateway" {
    count = var.golang_gateway_count

    network {
      mode = "host"
      port "http" {}
    }

    service {
      name = "golang-gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.golang-gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.golang-gateway.entrypoints=golang-gateway",
      ]
    }

    task "gateway" {
      driver = "docker"

      config {
        image        = var.gateway_golang_image
        ports        = ["http"]
        network_mode = "host"
        cpu_hard_limit    = true
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:9105"
        PORT         = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = var.golang_gateway_cpu
        memory = var.golang_gateway_mem
      }
    }
  }
}
