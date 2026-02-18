# PHP Laravel FPM
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


# Node NestJS
node_nestjs_monolith_cpu   = 1536
node_nestjs_monolith_mem   = 256
node_nestjs_monolith_count = 1
node_nestjs_gateway_cpu    = 1536
node_nestjs_gateway_mem    = 512
node_nestjs_gateway_count  = 0
node_nestjs_max_pool_size  = 60

# Java MVC VT
java_mvc_vt_monolith_cpu   = 1536
java_mvc_vt_monolith_mem   = 512
java_mvc_vt_monolith_count = 1
java_mvc_vt_gateway_cpu    = 1536
java_mvc_vt_gateway_mem    = 1024
java_mvc_vt_gateway_count  = 0
java_mvc_vt_max_pool_size  = 60

# Java WebFlux
java_webflux_monolith_cpu   = 2560
java_webflux_monolith_mem   = 256
java_webflux_monolith_count = 1
java_webflux_gateway_cpu    = 1024
java_webflux_gateway_mem    = 1024
java_webflux_gateway_count  = 0
java_webflux_max_pool_size  = 60

# Java Quarkus
java_quarkus_monolith_cpu   = 1536
java_quarkus_monolith_mem   = 512
java_quarkus_monolith_count = 1
java_quarkus_gateway_cpu    = 1024
java_quarkus_gateway_mem    = 1024
java_quarkus_gateway_count  = 0
java_quarkus_max_pool_size  = 60

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
golang_monolith_mem   = 512
golang_monolith_count = 1
golang_gateway_cpu    = 1024
golang_gateway_mem    = 1024
golang_gateway_count  = 0
golang_max_pool_size  = 60


# Python FastAPI
python_fastapi_monolith_cpu   = 1536
python_fastapi_monolith_mem   = 512
python_fastapi_monolith_count = 2
python_fastapi_gateway_cpu    = 1024
python_fastapi_gateway_mem    = 1024
python_fastapi_gateway_count  = 0
python_fastapi_max_pool_size  = 30
python_fastapi_monolith_workers = 3
python_fastapi_gateway_workers  = 3


# Rust
rust_monolith_cpu   = 512
rust_monolith_mem   = 256
rust_monolith_count = 1
rust_gateway_cpu    = 1024
rust_gateway_mem    = 1024
rust_gateway_count  = 0
rust_max_pool_size  = 60
