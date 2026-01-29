job "monolith" {
  datacenters = ["dc1"]
  type = "service"

  group "api" {
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
        "traefik.http.routers.monolith.entrypoints=monolith",
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
        image        = "java-mvc-vt/monolith:1.0"
        ports        = ["http"]
        force_pull   = false
        network_mode = "host"
      }

      env {
        SPRING_DATASOURCE_URL      = "jdbc:postgresql://127.0.0.1:5432/benchmark?sslmode=disable"
        SPRING_DATASOURCE_USERNAME = "postgres"
        SPRING_DATASOURCE_PASSWORD = "postgres"
        SERVER_PORT                = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
