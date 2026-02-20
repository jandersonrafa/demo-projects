#!/bin/bash

# Ensure we are in the project root
cd "$(dirname "$0")/.." || exit 1

echo "Building images..."

# Java MVC VT
docker build -t benchmark-stacks/java-mvc-vt-gateway:1.0 apps/java-mvc-vt/gateway
docker build -t benchmark-stacks/java-mvc-vt-monolith:1.0 apps/java-mvc-vt/monolith

# # Java Webflux
# docker build -t benchmark-stacks/java-webflux-gateway:1.0 apps/java-webflux/gateway
# docker build -t benchmark-stacks/java-webflux-monolith:1.0 apps/java-webflux/monolith

# # .NET
# docker build -t benchmark-stacks/dotnet-gateway:1.0 apps/dotnet/gateway
# docker build -t benchmark-stacks/dotnet-monolith:1.0 apps/dotnet/monolith

# # Golang
# docker build -t benchmark-stacks/golang-gateway:1.0 apps/golang/gateway
# docker build -t benchmark-stacks/golang-monolith:1.0 apps/golang/monolith

# # Node NestJS
# docker build -t benchmark-stacks/nestjs-gateway:1.0 apps/node-nestjs/gateway
# docker build -t benchmark-stacks/nestjs-monolith:1.0 apps/node-nestjs/monolith

# # PHP Laravel FPM
# docker build -t benchmark-stacks/php-laravel-fpm-gateway:1.0 apps/php-laravel-fpm/gateway
# docker build -t benchmark-stacks/php-laravel-fpm-monolith:1.0 apps/php-laravel-fpm/monolith

# # PHP Laravel Octane
# docker build -t benchmark-stacks/php-laravel-octane-gateway:1.0 apps/php-laravel-octane/gateway
# docker build -t benchmark-stacks/php-laravel-octane-monolith:1.0 apps/php-laravel-octane/monolith

# # Python FastAPI
# docker build -t benchmark-stacks/python-fastapi-gateway:1.0 apps/python-fastapi/gateway
# docker build -t benchmark-stacks/python-fastapi-monolith:1.0 apps/python-fastapi/monolith

# # Rust
# docker build -t benchmark-stacks/rust-gateway:1.0 apps/rust/gateway
# docker build -t benchmark-stacks/rust-monolith:1.0 apps/rust/monolith

# # Quarkus
# docker build -t benchmark-stacks/java-quarkus-gateway:1.0 apps/java-quarkus/gateway
# docker build -t benchmark-stacks/java-quarkus-monolith:1.0 apps/java-quarkus/monolith


echo "All images built successfully!"