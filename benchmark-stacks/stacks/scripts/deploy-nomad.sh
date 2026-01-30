#!/bin/bash

# Navigate to script directory to ensure relative paths work
cd "$(dirname "$0")"

echo "Starting Infrastructure..."
nomad job run -var-file=../nomad/vars/common.hcl ../nomad/jobs/infra/postgres.nomad
nomad job run -var-file=../nomad/vars/common.hcl ../nomad/jobs/infra/pgbouncer.nomad
nomad job run -var-file=../nomad/vars/common.hcl ../nomad/jobs/infra/traefik.nomad

echo "Starting Apps..."
nomad job run -var-file=../nomad/vars/common.hcl ../nomad/jobs/apps/java-mvc.nomad
nomad job run -var-file=../nomad/vars/common.hcl ../nomad/jobs/apps/java-mvc-vt.nomad
nomad job run -var-file=../nomad/vars/common.hcl ../nomad/jobs/apps/java-webflux.nomad

echo "Jobs submitted."
nomad status
