# --- Global Infrastructure Config ---
datacenters = ["dc1"]
region      = "global"

# --- Database Config ---
db_user     = "postgres"
db_password = "postgres"
db_name     = "benchmark"

# --- Infrastructure Images ---
postgres_image  = "postgres:16-alpine"
pgbouncer_image = "edoburu/pgbouncer:latest"
traefik_image   = "traefik:v3.0"

# --- Infrastructure Resource Limits ---
postgres_cpu    = 2000
postgres_mem    = 2048
postgres_count  = 1
pgbouncer_cpu   = 1000
pgbouncer_mem   = 1024
pgbouncer_count = 1
traefik_cpu     = 2000
traefik_mem     = 1024
traefik_count   = 1

# --- Application Images ---
monolith_mvc_vt_image  = "benchmark-stacks/java-mvc-vt-monolith:1.0"
gateway_mvc_vt_image   = "benchmark-stacks/java-mvc-vt-gateway:1.0"
monolith_webflux_image = "benchmark-stacks/java-webflux-monolith:1.0"
gateway_webflux_image  = "benchmark-stacks/java-webflux-gateway:1.0"

monolith_dotnet_image  = "benchmark-stacks/dotnet-monolith:1.0"
gateway_dotnet_image   = "benchmark-stacks/dotnet-gateway:1.0"
monolith_golang_image  = "benchmark-stacks/golang-monolith:1.0"
gateway_golang_image   = "benchmark-stacks/golang-gateway:1.0"
monolith_nestjs_image  = "benchmark-stacks/nestjs-monolith:1.0"
gateway_nestjs_image   = "benchmark-stacks/nestjs-gateway:1.0"
monolith_fpm_image     = "benchmark-stacks/php-laravel-fpm-monolith:1.0"
gateway_fpm_image      = "benchmark-stacks/php-laravel-fpm-gateway:1.0"
monolith_octane_image  = "benchmark-stacks/php-laravel-octane-monolith:1.0"
gateway_octane_image   = "benchmark-stacks/php-laravel-octane-gateway:1.0"
monolith_python_image  = "benchmark-stacks/python-fastapi-monolith:1.0"
gateway_python_image   = "benchmark-stacks/python-fastapi-gateway:1.0"
monolith_rust_image    = "benchmark-stacks/rust-monolith:1.0"
gateway_rust_image     = "benchmark-stacks/rust-gateway:1.0"
monolith_quarkus_image = "benchmark-stacks/java-quarkus-monolith:1.0"
gateway_quarkus_image  = "benchmark-stacks/java-quarkus-gateway:1.0"


# --- Application Resource Limits (Specific per Stack) ---

# Java MVC VT
java_mvc_vt_monolith_cpu   = 1024
java_mvc_vt_monolith_mem   = 768
java_mvc_vt_monolith_count = 3
java_mvc_vt_gateway_cpu    = 1024
java_mvc_vt_gateway_mem    = 768
java_mvc_vt_gateway_count  = 2

# Java Quarkus
java_quarkus_monolith_cpu   = 1024
java_quarkus_monolith_mem   = 2048
java_quarkus_monolith_count = 2
java_quarkus_gateway_cpu    = 1024
java_quarkus_gateway_mem    = 2048
java_quarkus_gateway_count  = 2

# Java WebFlux
java_webflux_monolith_cpu   = 1024
java_webflux_monolith_mem   = 2048
java_webflux_monolith_count = 2
java_webflux_gateway_cpu    = 1024
java_webflux_gateway_mem    = 2048
java_webflux_gateway_count  = 2

# DotNet
dotnet_monolith_cpu   = 1024
dotnet_monolith_mem   = 2048
dotnet_monolith_count = 2
dotnet_gateway_cpu    = 1024
dotnet_gateway_mem    = 2048
dotnet_gateway_count  = 2

# Golang
golang_monolith_cpu   = 1024
golang_monolith_mem   = 2048
golang_monolith_count = 2
golang_gateway_cpu    = 1024
golang_gateway_mem    = 2048
golang_gateway_count  = 2

# Node NestJS
node_nestjs_monolith_cpu   = 1024
node_nestjs_monolith_mem   = 2048
node_nestjs_monolith_count = 2
node_nestjs_gateway_cpu    = 1024
node_nestjs_gateway_mem    = 2048
node_nestjs_gateway_count  = 2

# PHP Laravel FPM
php_laravel_fpm_monolith_cpu   = 4096
php_laravel_fpm_monolith_mem   = 512
php_laravel_fpm_monolith_count = 4
php_laravel_fpm_gateway_cpu    = 4096
php_laravel_fpm_gateway_mem    = 512
php_laravel_fpm_gateway_count  = 4

# PHP Laravel Octane
php_laravel_octane_monolith_cpu   = 2048
php_laravel_octane_monolith_mem   = 1024
php_laravel_octane_monolith_count = 3
php_laravel_octane_gateway_cpu    = 1536
php_laravel_octane_gateway_mem    = 1024
php_laravel_octane_gateway_count  = 3

# Python FastAPI
python_fastapi_monolith_cpu   = 1024
python_fastapi_monolith_mem   = 2048
python_fastapi_monolith_count = 2
python_fastapi_gateway_cpu    = 1024
python_fastapi_gateway_mem    = 2048
python_fastapi_gateway_count  = 2

# Rust
rust_monolith_cpu   = 1024
rust_monolith_mem   = 2048
rust_monolith_count = 2
rust_gateway_cpu    = 1024
rust_gateway_mem    = 2048
rust_gateway_count  = 2
