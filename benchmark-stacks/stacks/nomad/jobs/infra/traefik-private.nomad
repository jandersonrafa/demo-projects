variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "traefik_image" { type = string }

# Resource variables
variable "traefik_cpu" { type = number }
variable "traefik_mem" { type = number }

# Count variables
variable "traefik_count" { type = number }

job "traefik-private" {
  datacenters = var.datacenters
  type        = "service"

  group "traefik-private" {
    count = var.traefik_count

    network {
      mode = "host"

      port "http" { static = 9091 }
      port "api"  { static = 9092 }


      # Monoliths (INTERNOS)
      port "mvc-vt-monolith"     { static = 9101 }
      port "webflux-monolith"    { static = 9102 }
      port "nestjs-monolith"     { static = 9103 }
      port "dotnet-monolith"     { static = 9104 }
      port "golang-monolith"     { static = 9105 }
      port "fpm-monolith"        { static = 9106 }
      port "octane-monolith"     { static = 9107 }
      port "python-monolith"     { static = 9108 }
      port "rust-monolith"       { static = 9109 }
      port "quarkus-monolith"    { static = 9110 }
    }

    service {
      name = "traefik-private"
      port = "mvc-vt-monolith"
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
    address: ":9091"
  traefik:
    address: ":9092"

  mvc-vt-monolith:
    address: ":9101"
  webflux-monolith:
    address: ":9102"
  nestjs-monolith:
    address: ":9103"
  dotnet-monolith:
    address: ":9104"
  golang-monolith:
    address: ":9105"
  fpm-monolith:
    address: ":9106"
  octane-monolith:
    address: ":9107"
  python-monolith:
    address: ":9108"
  rust-monolith:
    address: ":9109"
  quarkus-monolith:
    address: ":9110"

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
