variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "postgres_image" { type = string }
variable "pgbouncer_image" { type = string }
variable "traefik_image" { type = string }
variable "monolith_mvc_vt_image" { type = string }
variable "gateway_mvc_vt_image" { type = string }
variable "monolith_webflux_image" { type = string }
variable "gateway_webflux_image" { type = string }
variable "monolith_dotnet_image" { type = string }
variable "gateway_dotnet_image" { type = string }
variable "monolith_golang_image" { type = string }
variable "gateway_golang_image" { type = string }
variable "monolith_nestjs_image" { type = string }
variable "gateway_nestjs_image" { type = string }
variable "monolith_fpm_image" { type = string }
variable "gateway_fpm_image" { type = string }
variable "monolith_octane_image" { type = string }
variable "gateway_octane_image" { type = string }
variable "monolith_python_image" { type = string }
variable "gateway_python_image" { type = string }
variable "monolith_rust_image" { type = string }
variable "gateway_rust_image" { type = string }
variable "monolith_quarkus_image" { type = string }
variable "gateway_quarkus_image" { type = string }

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
      port "mvc-vt-gateway" { static = 8101 }
      port "mvc-vt-monolith" { static = 9101 }
      port "webflux-gateway" { static = 8102 }
      port "webflux-monolith" { static = 9102 }
      port "nestjs-gateway" { static = 8103 }
      port "nestjs-monolith" { static = 9103 }
      port "dotnet-gateway" { static = 8104 }
      port "dotnet-monolith" { static = 9104 }
      port "golang-gateway" { static = 8105 }
      port "golang-monolith" { static = 9105 }
      port "fpm-gateway" { static = 8106 }
      port "fpm-monolith" { static = 9106 }
      port "octane-gateway" { static = 8107 }
      port "octane-monolith" { static = 9107 }
      port "python-gateway" { static = 8108 }
      port "python-monolith" { static = 9108 }
      port "rust-gateway" { static = 8109 }
      port "rust-monolith" { static = 9109 }
      port "quarkus-gateway" { static = 8110 }
      port "quarkus-monolith" { static = 9110 }
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
        memory_hard_limit = var.traefik_mem
        cpu_hard_limit    = true
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
  dotnet-gateway:
    address: ":8104"
  dotnet-monolith:
    address: ":9104"
  golang-gateway:
    address: ":8105"
  golang-monolith:
    address: ":9105"
  fpm-gateway:
    address: ":8106"
  fpm-monolith:
    address: ":9106"
  octane-gateway:
    address: ":8107"
  octane-monolith:
    address: ":9107"
  python-gateway:
    address: ":8108"
  python-monolith:
    address: ":9108"
  rust-gateway:
    address: ":8109"
  rust-monolith:
    address: ":9109"
  quarkus-gateway:
    address: ":8110"
  quarkus-monolith:
    address: ":9110"


metrics:
  prometheus:
    addEntryPointsLabels: true
    addServicesLabels: true
    buckets:
      - 0.0001
      - 0.001
      - 0.005
      - 0.01
      - 0.025
      - 0.05
      - 0.075
      - 0.1
      - 0.25
      - 0.5
      - 0.75
      - 1
      - 2.5
      - 5
      - 10

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
