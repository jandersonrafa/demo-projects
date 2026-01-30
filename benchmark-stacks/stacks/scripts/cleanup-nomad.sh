#!/bin/bash

echo "Stopping all jobs..."

nomad job stop java-mvc
nomad job stop java-mvc-vt
nomad job stop java-webflux
nomad job stop pgbouncer
nomad job stop postgres
nomad job stop traefik

echo "All jobs stopped."
nomad status
