#!/bin/bash

# Stop applications
echo "Stopping applications..."
nomad job stop -purge java-mvc-vt
nomad job stop -purge java-webflux
nomad job stop -purge node-nestjs
nomad job stop -purge dotnet
nomad job stop -purge golang
nomad job stop -purge php-laravel-fpm
nomad job stop -purge php-laravel-octane
nomad job stop -purge python-fastapi
nomad job stop -purge rust
nomad job stop -purge java-quarkus


# Stop infrastructure
echo "Stopping infrastructure..."
nomad job stop -purge traefik
nomad job stop -purge pgbouncer
nomad job stop -purge postgres

echo "Cleanup finished!"
nomad status
