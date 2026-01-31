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

job "php-laravel-fpm" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.app_monolith_count

    network {
      mode = "host"
      port "http" {}
      port "fpm" {}
    }

    service {
      name = "fpm-monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.fpm-monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.fpm-monolith.entrypoints=fpm-monolith",
      ]
    }

    task "app" {
      driver = "docker"
      config {
        image        = var.monolith_fpm_image
        network_mode = "host"
        # Overwrite the listen port in the entrypoint by appending to config
        command = "sh"
        args    = ["-c", "echo 'listen = 0.0.0.0:${NOMAD_PORT_fpm}' >> /usr/local/etc/php-fpm.d/zz-nomad.conf && php-fpm"]
      }
      env {
        DB_CONNECTION = "pgsql"
        DB_HOST       = "127.0.0.1"
        DB_PORT       = "6432"
        DB_DATABASE   = var.db_name
        DB_USERNAME   = "php_fpm_user"
        DB_PASSWORD   = "php_fpm_pass"
        APP_KEY       = "base64:u8MvK+1512zU2m6XvP3Yv1rK8Z5o8z8k9u0u1u2u3u4="
        SESSION_DRIVER = "array"
        APP_ENV       = "production"
        APP_DEBUG     = "false"
        FPM_MAX_CHILDREN = 20
      }
      resources {
        cpu    = var.app_monolith_cpu
        memory = var.app_monolith_mem
      }
    }

    task "nginx" {
      driver = "docker"
      config {
        image = "nginx:alpine"
        ports = ["http"]
        network_mode = "host"
        volumes = [
          "local/default.conf:/etc/nginx/conf.d/default.conf",
        ]
      }
      template {
        data = <<EOF
server {
    listen {{ env "NOMAD_PORT_http" }};
    index index.php index.html;
    root /var/www/html/public;

    location / {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /var/www/html/public/index.php;
        fastcgi_pass 127.0.0.1:{{ env "NOMAD_PORT_fpm" }};
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param QUERY_STRING $query_string;
    }
}
EOF
        destination = "local/default.conf"
      }
      resources {
        cpu    = 200
        memory = 256
      }
    }
  }

  group "gateway" {
    count = var.app_gateway_count

    network {
      mode = "host"
      port "http" {}
      port "fpm" {}
    }

    service {
      name = "fpm-gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.fpm-gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.fpm-gateway.entrypoints=fpm-gateway",
      ]
    }

    task "app" {
      driver = "docker"
      config {
        image        = var.gateway_fpm_image
        network_mode = "host"
        command = "sh"
        args    = ["-c", "echo 'listen = 0.0.0.0:${NOMAD_PORT_fpm}' >> /usr/local/etc/php-fpm.d/zz-nomad.conf && php-fpm"]
      }
      env {
        MONOLITH_URL = "http://127.0.0.1:9106"
        APP_KEY      = "base64:u8MvK+1512zU2m6XvP3Yv1rK8Z5o8z8k9u0u1u2u3u4="
        SESSION_DRIVER = "array"
        APP_ENV      = "production"
        APP_DEBUG    = "false"
        FPM_MAX_CHILDREN = 20
      }
      resources {
        cpu    = var.app_gateway_cpu
        memory = var.app_gateway_mem
      }
    }

    task "nginx" {
      driver = "docker"
      config {
        image = "nginx:alpine"
        ports = ["http"]
        network_mode = "host"
        volumes = [
          "local/default.conf:/etc/nginx/conf.d/default.conf",
        ]
      }
      template {
        data = <<EOF
server {
    listen {{ env "NOMAD_PORT_http" }};
    index index.php index.html;
    root /var/www/html/public;

    location / {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /var/www/html/public/index.php;
        fastcgi_pass 127.0.0.1:{{ env "NOMAD_PORT_fpm" }};
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param QUERY_STRING $query_string;
    }
}
EOF
        destination = "local/default.conf"
      }
      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}
