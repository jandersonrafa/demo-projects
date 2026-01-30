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

job "postgres" {
  datacenters = var.datacenters
  type = "service"

  group "db" {
    count = var.postgres_count

    network {
      mode = "host"
      port "db" {
        static = 5432
      }
    }

    service {
      name = "benchmark-db"
      port = "db"
      
      check {
        type     = "script"
        name     = "pg_isready"
        command  = "/usr/local/bin/pg_isready"
        args     = ["-U", "postgres"]
        interval = "5s"
        timeout  = "5s"
        task     = "benchmark-postgres"
      }
    }

    task "benchmark-postgres" {
      driver = "docker"

      config {
        image        = var.postgres_image
        ports        = ["db"]
        network_mode = "host"
        args         = ["postgres", "-c", "max_connections=500"]
        volumes = [
          "local/01-init.sql:/docker-entrypoint-initdb.d/01-init.sql",
          "local/02-init-users.sql:/docker-entrypoint-initdb.d/02-init-users.sql"
        ]
      }

      template {
        data        = file("../infra/postgres/init.sql")
        destination = "local/01-init.sql"
      }

      template {
        data        = file("../infra/postgres/init-users.sql")
        destination = "local/02-init-users.sql"
      }

      env {
        POSTGRES_DB       = var.db_name
        POSTGRES_USER     = var.db_user
        POSTGRES_PASSWORD = var.db_password
      }

      resources {
        cpu    = var.postgres_cpu
        memory = var.postgres_mem
      }
    }
  }
}