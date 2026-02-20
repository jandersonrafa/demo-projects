#!/bin/bash

# Check if Docker Swarm is initialized
if ! docker node ls > /dev/null 2>&1; then
    echo "Docker Swarm is not initialized. Initializing..."
    IP=$(hostname -I | awk '{print $1}')
    docker swarm init --advertise-addr "$IP"
fi

echo "Deploying stacks..."

# -----------------------------------------------------------------------
# Infrastructure (always deploy first - creates the shared network)
# -----------------------------------------------------------------------
docker stack deploy -c ../docker-swarm/infra/postgres.yml stacks

docker stack deploy -c ../docker-swarm/infra/pgbouncer.yml stacks

docker stack deploy -c ../docker-swarm/infra/traefik.yml stacks
docker stack deploy -c ../docker-swarm/infra/cadvisor.yml stacks

# Wait for network to be ready before deploying apps
sleep 3

# -----------------------------------------------------------------------
# Application Stacks (comment out any you don't want to deploy)
# -----------------------------------------------------------------------

# docker stack deploy -c ../docker-swarm/apps/java-mvc-vt.yml stacks

# docker stack deploy -c ../docker-swarm/apps/java-webflux.yml stacks

# docker stack deploy -c ../docker-swarm/apps/java-quarkus.yml stacks

# docker stack deploy -c ../docker-swarm/apps/node-nestjs.yml stacks

# docker stack deploy -c ../docker-swarm/apps/dotnet.yml stacks

# docker stack deploy -c ../docker-swarm/apps/golang.yml stacks

docker stack deploy -c ../docker-swarm/apps/php-laravel-fpm.yml stacks

docker stack deploy -c ../docker-swarm/apps/php-laravel-octane.yml stacks

# docker stack deploy -c ../docker-swarm/apps/python-fastapi.yml stacks

docker stack deploy -c ../docker-swarm/apps/rust.yml stacks

# -----------------------------------------------------------------------
echo ""
echo "Deployment complete. Checking stack status..."
sleep 3
docker stack ps stacks
