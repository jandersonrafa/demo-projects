#!/bin/bash

# Ensure we are in the project root
cd "$(dirname "$0")/.." || exit 1


# Stop applications
echo "Stopping applications..."
nomad job stop java-mvc-vt
nomad job stop java-webflux
nomad job stop java-quarkus
nomad job stop node-nestjs
nomad job stop dotnet
nomad job stop golang
nomad job stop php-laravel-fpm
nomad job stop php-laravel-octane
nomad job stop python-fastapi
nomad job stop rust

# Stop infrastructure
echo "Stopping infrastructure..."
# nomad job stop traefik-private
# nomad job stop traefik-public
# nomad job stop pgbouncer
nomad job stop postgres

echo "Cleanup finished!"
nomad status
