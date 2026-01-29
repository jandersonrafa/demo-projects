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

job "traefik" {
  datacenters = var.datacenters
  type        = "service"

  group "traefik" {
    count = 1

    network {
      mode = "host"
      port "http" {
        static = 8081
      }
      port "api" {
        static = 8082
      }
      port "java-gateway" {
        static = 8083
      }
      port "java-monolith" {
        static = 8084
      }
      port "nestjs-gateway" {
        static = 8085
      }
      port "nestjs-monolith" {
        static = 8086
      }
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
  java-gateway:
    address: ":8083"
  java-monolith:
    address: ":8084"
  nestjs-gateway:
    address: ":8085"
  nestjs-monolith:
    address: ":8086"

providers:
  consulCatalog:
    exposedByDefault: true
    endpoint:
      address: "http://127.0.0.1:8500" # Consul endpoint
EOF
        destination = "local/traefik.yaml"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
