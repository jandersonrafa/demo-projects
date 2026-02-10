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
postgres_cpu    = 1024
postgres_mem    = 1024
postgres_count  = 1
pgbouncer_cpu   = 512
pgbouncer_mem   = 512
pgbouncer_count = 1
traefik_cpu     = 1024
traefik_mem     = 512
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
java_mvc_vt_monolith_cpu   = 1536
java_mvc_vt_monolith_mem   = 512
java_mvc_vt_monolith_count = 1
java_mvc_vt_gateway_cpu    = 1536
java_mvc_vt_gateway_mem    = 1024
java_mvc_vt_gateway_count  = 0
java_mvc_vt_max_pool_size  = 60

# Java Quarkus
java_quarkus_monolith_cpu   = 1536
java_quarkus_monolith_mem   = 512
java_quarkus_monolith_count = 1
java_quarkus_gateway_cpu    = 1024
java_quarkus_gateway_mem    = 1024
java_quarkus_gateway_count  = 0
java_quarkus_max_pool_size  = 60

# Java WebFlux
java_webflux_monolith_cpu   = 2560
java_webflux_monolith_mem   = 256
java_webflux_monolith_count = 1
java_webflux_gateway_cpu    = 1024
java_webflux_gateway_mem    = 1024
java_webflux_gateway_count  = 0
java_webflux_max_pool_size  = 60

# DotNet
dotnet_monolith_cpu   = 1536
dotnet_monolith_mem   = 512
dotnet_monolith_count = 1
dotnet_gateway_cpu    = 1024
dotnet_gateway_mem    = 1024
dotnet_gateway_count  = 0
dotnet_max_pool_size  = 60

# Golang
golang_monolith_cpu   = 1536
golang_monolith_mem   = 256
golang_monolith_count = 1
golang_gateway_cpu    = 1024
golang_gateway_mem    = 1024
golang_gateway_count  = 0
golang_max_pool_size  = 60

# Node NestJS
node_nestjs_monolith_cpu   = 1536
node_nestjs_monolith_mem   = 256
node_nestjs_monolith_count = 1
node_nestjs_gateway_cpu    = 1536
node_nestjs_gateway_mem    = 512
node_nestjs_gateway_count  = 0
node_nestjs_max_pool_size  = 60

# PHP Laravel FPM
# Nao tem hardware suficiente na maquina para atender, atende a no máximo 100 rps
#php_laravel_fpm_monolith_cpu   = 2560
#php_laravel_fpm_monolith_mem   = 2560
#php_laravel_fpm_monolith_count = 3
#php_laravel_fpm_monolith_max_children  = 2
#php_laravel_fpm_gateway_cpu    = 2560
#php_laravel_fpm_gateway_mem    = 2560
#php_laravel_fpm_gateway_count  = 2
#php_laravel_fpm_gateway_max_children  = 3
#php_laravel_fpm_nginx_cpu      = 256
#php_laravel_fpm_nginx_mem      = 256

php_laravel_fpm_monolith_cpu   = 2048
php_laravel_fpm_monolith_mem   = 256
php_laravel_fpm_monolith_count = 6
php_laravel_fpm_monolith_max_children  = 6
php_laravel_fpm_gateway_cpu    = 10
php_laravel_fpm_gateway_mem    = 10
php_laravel_fpm_gateway_count  = 0
php_laravel_fpm_gateway_max_children  = 1
php_laravel_fpm_nginx_cpu      = 256
php_laravel_fpm_nginx_mem      = 256

# PHP Laravel Octane
php_laravel_octane_monolith_cpu      = 2048
php_laravel_octane_monolith_mem      = 1024
php_laravel_octane_monolith_count    = 2
php_laravel_octane_monolith_workers  = 6
php_laravel_octane_gateway_cpu       = 10
php_laravel_octane_gateway_mem       = 10
php_laravel_octane_gateway_count     = 0
php_laravel_octane_gateway_workers   = 0
php_laravel_octane_nginx_cpu      = 256
php_laravel_octane_nginx_mem      = 256

# Python FastAPI
python_fastapi_monolith_cpu   = 1560
python_fastapi_monolith_mem   = 512
python_fastapi_monolith_count = 1
python_fastapi_gateway_cpu    = 1024
python_fastapi_gateway_mem    = 1024
python_fastapi_gateway_count  = 0
python_fastapi_max_pool_size  = 60
python_fastapi_monolith_workers = 6
python_fastapi_gateway_workers  = 6

# Rust
rust_monolith_cpu   = 1024
rust_monolith_mem   = 1024
rust_monolith_count = 1
rust_gateway_cpu    = 1024
rust_gateway_mem    = 1024
rust_gateway_count  = 1
rust_max_pool_size  = 15
