#!/bin/bash

# Directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Check if Docker Swarm is initialized
if ! docker node ls > /dev/null 2>&1; then
    echo "Docker Swarm is not initialized. Initializing..."
    docker swarm init
fi

echo "Deploying monitoring stack to Docker Swarm..."

# Ensure the data directories exist and have the correct permissions
mkdir -p infra/prometheus/data
mkdir -p infra/grafana/data
chmod 777 infra/prometheus/data
chmod 777 infra/grafana/data
chmod 777 infra/grafana/dashboards

# Deploy the stack
docker stack deploy -c "$SCRIPT_DIR/docker-stack.yml" monitoring

echo "Waiting for services to start..."
sleep 5

docker stack ps monitoring
