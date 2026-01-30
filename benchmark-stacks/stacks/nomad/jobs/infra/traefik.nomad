variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "postgres_image" { type = string }
variable "pgbouncer_image" { type = string }
variable "traefik_image" { type = string }
variable "monolith_mvc_image" { type = string }
variable "gateway_mvc_image" { type = string }
variable "monolith_mvc_vt_image" { type = string }
variable "gateway_mvc_vt_image" { type = string }
variable "monolith_webflux_image" { type = string }
variable "gateway_webflux_image" { type = string }
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

job "traefik" {
  datacenters = var.datacenters
  type        = "service"

  group "traefik" {
    count = var.traefik_count

    network {
      mode = "host"
      port "http" { static = 8081 }
      port "api" { static = 8082 }
      port "mvc-gateway" { static = 8100 }
      port "mvc-monolith" { static = 9100 }
      port "mvc-vt-gateway" { static = 8101 }
      port "mvc-vt-monolith" { static = 9101 }
      port "webflux-gateway" { static = 8102 }
      port "webflux-monolith" { static = 9102 }
      port "nestjs-gateway" { static = 8103 }
      port "nestjs-monolith" { static = 9103 }
    }

    service {
      name = "traefik"
      port = "http"
      check {
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = var.traefik_image
        network_mode = "host"
        volumes = [
          "local/traefik.yaml:/etc/traefik/traefik.yaml",
        ]
      }

      template {
        data = <<EOF
log:
  level: INFO

api:
  dashboard: true
  insecure: true

entryPoints:
  web:
    address: ":8081"
  traefik:
    address: ":8082"
  mvc-gateway:
    address: ":8100"
  mvc-monolith:
    address: ":9100"
  mvc-vt-gateway:
    address: ":8101"
  mvc-vt-monolith:
    address: ":9101"
  webflux-gateway:
    address: ":8102"
  webflux-monolith:
    address: ":9102"
  nestjs-gateway:
    address: ":8103"
  nestjs-monolith:
    address: ":9103"

metrics:
  prometheus:
    addEntryPointsLabels: true
    addServicesLabels: true

providers:
  consulCatalog:
    exposedByDefault: true
    endpoint:
      address: "http://127.0.0.1:8500"
EOF
        destination = "local/traefik.yaml"
      }

      resources {
        cpu    = var.traefik_cpu
        memory = var.traefik_mem
      }
    }
  }
}
