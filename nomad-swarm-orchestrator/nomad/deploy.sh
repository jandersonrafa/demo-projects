#!/bin/bash

# Ensure we are in the nomad directory or point to the right paths
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Starting Postgres..."
nomad job run "$DIR/postgres.nomad"

echo "Starting Traefik Load Balancer..."
nomad job run "$DIR/traefik.nomad"

echo "Starting Monolith..."
nomad job run "$DIR/monolith.nomad"

echo "Starting Gateway..."
nomad job run "$DIR/gateway.nomad"

echo "All jobs submitted to Nomad."
nomad status
