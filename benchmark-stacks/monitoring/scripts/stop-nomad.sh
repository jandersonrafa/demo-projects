#!/bin/bash

# Ensure we are in the project root
cd "$(dirname "$0")/.." || exit 1

# Stop monitoring infrastructure
echo "Stopping monitoring infrastructure..."
nomad job stop prometheus
nomad job stop grafana

echo "Stop finished!"
nomad status
