#!/bin/bash

# Ensure we are in the root directory relative to the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

VAR_FILE="$ROOT_DIR/vars/common.hcl"

echo "Starting Infrastructure (Postgres)..."
nomad job run -var-file="$VAR_FILE" "$ROOT_DIR/jobs/infra/postgres.nomad"

echo "Starting Infrastructure (traefik)..."
nomad job run -var-file="$VAR_FILE" "$ROOT_DIR/jobs/infra/traefik.nomad"

echo "Starting App (Java Monolith + Gateway)..."
nomad job run -var-file="$VAR_FILE" "$ROOT_DIR/jobs/apps/app-java-mvc-vt.nomad"

echo "Starting App (NestJS Monolith + Gateway)..."
nomad job run -var-file="$VAR_FILE" "$ROOT_DIR/jobs/apps/app-nestjs.nomad"

echo "All jobs submitted to Nomad."
nomad status
