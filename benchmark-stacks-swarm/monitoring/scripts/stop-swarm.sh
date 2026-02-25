#!/bin/bash

echo "Removing monitoring stack from Docker Swarm..."

docker stack rm monitoring

echo "Waiting for services to stop..."
# No formal wait command for stack rm, but we can check service list
sleep 2

docker service ls | grep monitoring
