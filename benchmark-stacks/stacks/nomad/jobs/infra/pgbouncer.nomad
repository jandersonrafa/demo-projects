variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "pgbouncer_image" { type = string }

# Resource variables
variable "pgbouncer_cpu" { type = number }
variable "pgbouncer_mem" { type = number }

# Count variables
variable "pgbouncer_count" { type = number }

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
        memory_hard_limit = var.pgbouncer_mem
        cpu_hard_limit    = true
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
