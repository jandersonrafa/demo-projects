#!/bin/bash

# Ensure we are in the project root
cd "$(dirname "$0")/.." || exit 1

# Deploy infrastructure
echo "Deploying infrastructure..."
nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/infra/postgres.nomad
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/infra/pgbouncer.nomad
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/infra/traefik-private.nomad
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/infra/traefik-public.nomad

# Wait for infra to be ready
echo "Waiting for infrastructure to be ready..."
sleep 10

# Deploy applications in parallel
echo "Deploying applications in parallel..."
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/apps/java-mvc-vt.nomad &
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/apps/java-webflux.nomad &
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/apps/node-nestjs.nomad &
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/apps/dotnet.nomad &
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/apps/golang.nomad &
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/apps/php-laravel-fpm.nomad &
nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/apps/php-laravel-octane.nomad &
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/apps/python-fastapi.nomad &
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/apps/rust.nomad &
# nomad job run -hcl2-strict=false -var-file=nomad/vars/common.hcl nomad/jobs/apps/java-quarkus.nomad &


# Wait for all background deployments to finish
wait

echo "All jobs submitted in parallel!"
nomad status
