variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "traefik_image" { type = string }

# Resource variables
variable "traefik_cpu" { type = number }
variable "traefik_mem" { type = number }

# Count variables
variable "traefik_count" { type = number }

job "traefik-public" {
  datacenters = var.datacenters
  type        = "service"

  group "traefik-public" {
    count = var.traefik_count

    network {
      mode = "host"
      port "http" { static = 8081 }
      port "api"  { static = 8082 }

      # Gateways (EXTERNOS)
      port "mvc-vt-gateway"     { static = 8101 }
      port "webflux-gateway"    { static = 8102 }
      port "nestjs-gateway"     { static = 8103 }
      port "dotnet-gateway"     { static = 8104 }
      port "golang-gateway"     { static = 8105 }
      port "fpm-gateway"        { static = 8106 }
      port "octane-gateway"     { static = 8107 }
      port "python-gateway"     { static = 8108 }
      port "rust-gateway"       { static = 8109 }
      port "quarkus-gateway"    { static = 8110 }
    }

    service {
      name = "traefik-public"
      port = "http"
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = var.traefik_image
        network_mode = "host"
        volumes = [
          "local/traefik.yaml:/etc/traefik/traefik.yaml",
        ]
        cpu_hard_limit    = true
      }

      template {
        destination = "local/traefik.yaml"
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

  mvc-vt-gateway:
    address: ":8101"
  webflux-gateway:
    address: ":8102"
  nestjs-gateway:
    address: ":8103"
  dotnet-gateway:
    address: ":8104"
  golang-gateway:
    address: ":8105"
  fpm-gateway:
    address: ":8106"
  octane-gateway:
    address: ":8107"
  python-gateway:
    address: ":8108"
  rust-gateway:
    address: ":8109"
  quarkus-gateway:
    address: ":8110"

providers:
  consulCatalog:
    exposedByDefault: true
    endpoint:
      address: "http://127.0.0.1:8500"

metrics:
  prometheus:
    addEntryPointsLabels: true
    addServicesLabels: true
    buckets:
      - 0.01
      - 0.025
      - 0.05
      - 0.075
      - 0.1
      - 0.15
      - 0.2
      - 0.3
      - 0.4
      - 0.6
      - 0.8
      - 1.2
      - 2.0
      - 3.0
EOF
      }

      resources {
        cpu    = var.traefik_cpu
        memory = var.traefik_mem
      }
    }
  }
}
