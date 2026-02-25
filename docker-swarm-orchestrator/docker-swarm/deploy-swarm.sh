#!/bin/bash

# Script para inicializar o stack no Docker Swarm

echo "Iniciando deploy do stack docker-swarm no Docker Swarm..."

# Verificar se o Docker Swarm está ativo
if ! docker info | grep -q "Swarm: active"; then
    echo "Erro: Docker Swarm não está ativo. Execute 'docker swarm init' primeiro."
    exit 1
fi

# Garantir que estamos no diretório do script
cd "$(dirname "$0")"

# Construir as imagens Docker
echo "Construindo imagem do monolith..."
if ! docker build -t docker-swarm/monolith:latest ../monolith; then
    echo "Erro ao construir imagem do monolith."
    exit 1
fi

echo "Construindo imagem do gateway..."
if ! docker build -t docker-swarm/gateway:latest ../gateway; then
    echo "Erro ao construir imagem do gateway."
    exit 1
fi

# Criar rede overlay se não existir
docker network create --driver overlay --attachable app-network 2>/dev/null || echo "Rede app-network já existe"

# Fazer deploy do stack
# --resolve-image never garante que o Swarm use a imagem local sem tentar buscá-la em um registry
docker stack deploy -c docker-compose.yml --resolve-image never docker-swarm

echo "Stack deploy iniciado. Use os seguintes comandos para monitorar:"
echo "  docker service ls"
echo "  docker service logs docker-swarm_gateway"
echo "  docker service logs docker-swarm_monolith"
echo ""
echo "A aplicação estará disponível em:"
echo "  Gateway: http://localhost:8080"
echo "  Health Check Gateway: http://localhost:8080/actuator/health"
echo "  Health Check Monolith: http://localhost:8080/actuator/health (via load balancer)"
