#!/bin/bash

# Script para remover o stack do Docker Swarm

echo "Removendo stack docker-swarm do Docker Swarm..."

# Remover o stack
docker stack rm docker-swarm

# Remover a rede (opcional, será removida automaticamente quando não houver mais serviços)
echo "Aguardando remoção dos serviços..."
sleep 10

# Verificar se a rede ainda existe e remover
if docker network ls | grep -q app-network; then
    docker network rm app-network
    echo "Rede app-network removida."
fi

echo "Stack docker-swarm removido com sucesso!"
