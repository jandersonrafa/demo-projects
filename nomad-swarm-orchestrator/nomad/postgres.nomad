job "postgres" {
  datacenters = ["dc1"]
  type = "service"

  group "db" {
    count = 1

    network {
      mode = "host"
      port "db" {
        static = 5432
      }
    }

    service {
      name = "benchmark-db"
      port = "db"
    }

    task "postgres" {
      driver = "docker"

      config {
        image        = "postgres:15-alpine"
        ports        = ["db"]
        network_mode = "host"
      }

      env {
        POSTGRES_DB       = "benchmark"
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "postgres"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
