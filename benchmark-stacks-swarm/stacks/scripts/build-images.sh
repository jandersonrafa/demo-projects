#!/bin/bash

# Ensure we are in the project root
cd "$(dirname "$0")/.." || exit 1

echo "Building monolith images..."

echo "You can build individual stacks by uncommenting the lines you need:"

# # Java MVC VT (virtual threads)
# docker build -t benchmark-stacks/java-mvc-vt-monolith:1.0 apps/java-mvc-vt

# # Java MVC without VT (platform threads)
# docker build -t benchmark-stacks/java-mvc-without-vt-monolith:1.0 apps/java-mvc-without-vt

# # Java Webflux
# docker build -t benchmark-stacks/java-webflux-monolith:1.0 apps/java-webflux

# # .NET
# docker build -t benchmark-stacks/dotnet-monolith:1.0 apps/dotnet

# # Golang
# docker build -t benchmark-stacks/golang-monolith:1.0 apps/golang

# #Node NestJS (Express)
# docker build -t benchmark-stacks/nestjs-express-monolith:1.0 apps/node-nestjs-express

# # Node NestJS (Fastify)
# docker build -t benchmark-stacks/nestjs-fastify-monolith:1.0 apps/node-nestjs-fastify

# PHP Laravel FPM
docker build -t benchmark-stacks/php-laravel-fpm-monolith:1.0 apps/php-laravel-fpm

# # PHP Laravel Octane
# docker build -t benchmark-stacks/php-laravel-octane-monolith:1.0 apps/php-laravel-octane

# # Python FastAPI
# docker build -t benchmark-stacks/python-fastapi-monolith:1.0 apps/python-fastapi

# # Rust
# docker build -t benchmark-stacks/rust-monolith:1.0 apps/rust

# # Quarkus
# docker build -t benchmark-stacks/java-quarkus-monolith:1.0 apps/java-quarkus

echo "All monolith images built successfully!"