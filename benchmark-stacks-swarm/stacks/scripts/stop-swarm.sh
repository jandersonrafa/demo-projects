#!/bin/bash

# Ensure we are in the project root
cd "$(dirname "$0")/.." || exit 1

echo "Removing stack 'stacks' from Docker Swarm..."
docker stack rm stacks

echo "Waiting for services to stop..."
sleep 10

echo "Done."
