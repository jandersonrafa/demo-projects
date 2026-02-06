variable "datacenters" { type = list(string) }
variable "region" { type = string }
variable "monolith_octane_image" { type = string }
variable "gateway_octane_image" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }

# Resource variables
variable "php_laravel_octane_monolith_cpu" { type = number }
variable "php_laravel_octane_monolith_mem" { type = number }
variable "php_laravel_octane_gateway_cpu" { type = number }
variable "php_laravel_octane_gateway_mem" { type = number }

# Count variables
variable "php_laravel_octane_monolith_count" { type = number }
variable "php_laravel_octane_gateway_count" { type = number }

job "php-laravel-octane" {
  datacenters = var.datacenters
  type        = "service"

  group "monolith" {
    count = var.php_laravel_octane_monolith_count

    network {
      mode = "host"
      port "http" {}
      port "octane" {}
    }

    service {
      name = "octane-monolith"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.octane-monolith.rule=PathPrefix(`/`)",
        "traefik.http.routers.octane-monolith.entrypoints=octane-monolith",
      ]
    }

    task "app" {
      driver = "docker"
      config {
        image        = var.monolith_octane_image
        network_mode = "host"
        command      = "php"
        args         = ["artisan", "octane:start", "--server=swoole", "--host=0.0.0.0", "--port=${NOMAD_PORT_octane}", "--workers=15"]
        cpu_hard_limit    = true
      }
      env {
        DB_CONNECTION = "pgsql"
        DB_HOST       = "127.0.0.1"
        DB_PORT       = "6432"
        DB_DATABASE   = var.db_name
        DB_USERNAME   = "php_octane_user"
        DB_PASSWORD   = "php_octane_pass"
        APP_KEY       = "base64:u8MvK+1512zU2m6XvP3Yv1rK8Z5o8z8k9u0u1u2u3u4="
        SESSION_DRIVER = "array"
        APP_ENV       = "production"
        APP_DEBUG     = "false"
        OCTANE_WORKERS = 15
        PORT           = "${NOMAD_PORT_octane}"
      }
      resources {
        cpu    = var.php_laravel_octane_monolith_cpu
        memory = var.php_laravel_octane_monolith_mem
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
        try_files $uri @octane;
    }

    location @octane {
        proxy_pass http://127.0.0.1:{{ env "NOMAD_PORT_octane" }};
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF
        destination = "local/default.conf"
      }
      resources {
        cpu    = 512  
        memory = 512
      }
    }
  }

  group "gateway" {
    count = var.php_laravel_octane_gateway_count

    network {
      mode = "host"
      port "http" {}
      port "octane" {}
    }

    service {
      name = "octane-gateway"
      port = "http"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.octane-gateway.rule=PathPrefix(`/`)",
        "traefik.http.routers.octane-gateway.entrypoints=octane-gateway",
      ]
    }

    task "app" {
      driver = "docker"
      config {
        image        = var.gateway_octane_image
        network_mode = "host"
        command      = "php"
        args         = ["artisan", "octane:start", "--server=swoole", "--host=0.0.0.0", "--port=${NOMAD_PORT_octane}", "--workers=15"]
        cpu_hard_limit    = true
      }
      env {
        MONOLITH_URL = "http://127.0.0.1:9107"
        APP_KEY      = "base64:u8MvK+1512zU2m6XvP3Yv1rK8Z5o8z8k9u0u1u2u3u4="
        SESSION_DRIVER = "array"
        APP_ENV      = "production"
        APP_DEBUG    = "false"
        OCTANE_WORKERS = 15
        PORT           = "${NOMAD_PORT_octane}"
      }
      resources {
        cpu    = var.php_laravel_octane_gateway_cpu
        memory = var.php_laravel_octane_gateway_mem
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
        try_files $uri @octane;
    }

    location @octane {
        proxy_pass http://127.0.0.1:{{ env "NOMAD_PORT_octane" }};
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF
        destination = "local/default.conf"
      }
      resources {
        cpu    = 512
        memory = 512
      }
    }
  }
}
