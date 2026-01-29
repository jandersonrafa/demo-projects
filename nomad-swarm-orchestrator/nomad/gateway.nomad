job "gateway" {
  datacenters = ["dc1"]
  type = "service"

  group "api" {
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
        "traefik.http.routers.gateway.entrypoints=web",
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
        image        = "java-mvc-vt/gateway:1.0"
        ports        = ["http"]
        network_mode = "host"
        force_pull   = false
      }

      env {
        MONOLITH_URL = "http://127.0.0.1:8083"
        SERVER_PORT  = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
