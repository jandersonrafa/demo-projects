#!/bin/bash

echo "Stopping all jobs..."

nomad job stop app-java-mvc-vt
nomad job stop app-nestjs
nomad job stop postgres
nomad job stop traefik
nomad job stop monitoring

echo "All jobs stopped."
nomad status
