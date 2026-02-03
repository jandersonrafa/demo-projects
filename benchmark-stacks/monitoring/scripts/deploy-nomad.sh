#!/bin/bash

# Ensure we are in the project root
cd "$(dirname "$0")/.." || exit 1

# Deploy monitoring infrastructure
echo "Deploying monitoring infrastructure..."
# nomad job run -var-file=nomad/vars/common.hcl nomad/jobs/infra/prometheus.nomad
nomad job run -var-file=nomad/vars/common.hcl nomad/jobs/infra/grafana.nomad

# Wait for deployments to be ready (basic check)
echo "Monitoring jobs submitted."
nomad status
