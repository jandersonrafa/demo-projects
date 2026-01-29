#!/bin/bash

echo "Stopping monolith job..."
nomad job stop -purge monolith

echo "Stopping postgres job..."
nomad job stop -purge postgres

echo "Stopping gateway job..."
nomad job stop -purge gateway

echo "Stopping traefik job..."
nomad job stop -purge traefik

echo "Cleanup complete."
