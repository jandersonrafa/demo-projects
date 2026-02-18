#!/bin/bash

# Stop monitoring infrastructure
echo "Stopping monitoring infrastructure..."
nomad job stop -purge prometheus
nomad job stop -purge grafana

echo "Cleanup finished!"
nomad status
