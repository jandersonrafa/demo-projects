job "traefik" {
  datacenters = ["dc1"]
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
      port "monolith" {
        static = 8083
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
        image        = "traefik:v3.0"
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
  monolith:
    address: ":8083"

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
