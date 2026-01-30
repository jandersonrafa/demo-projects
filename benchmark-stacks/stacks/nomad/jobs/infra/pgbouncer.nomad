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

job "pgbouncer" {
  datacenters = var.datacenters
  type = "service"

  group "pgbouncer" {
    count = var.pgbouncer_count

    network {
      mode = "host"
      port "proxy" {
        static = 6432
      }
    }

    service {
      name = "pgbouncer"
      port = "proxy"
    }

    task "pgbouncer" {
      driver = "docker"

      config {
        image        = var.pgbouncer_image
        ports        = ["proxy"]
        network_mode = "host"
        volumes = [
          "local/pgbouncer.ini:/etc/pgbouncer/pgbouncer.ini",
          "local/userlist.txt:/etc/pgbouncer/userlist.txt"
        ]
      }

      template {
        data        = file("infra/pgbouncer/pgbouncer.ini")
        destination = "local/pgbouncer.ini"
      }

      template {
        data        = file("infra/pgbouncer/userlist.txt")
        destination = "local/userlist.txt"
      }

      env {
        PGBOUNCER_LISTEN_PORT = "6432"
      }

      resources {
        cpu    = var.pgbouncer_cpu
        memory = var.pgbouncer_mem
      }
    }
  }
}
