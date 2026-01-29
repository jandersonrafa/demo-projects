#!/bin/bash

# Script para inicializar o stack no Docker Swarm

echo "Iniciando deploy do stack java-mvc-vt no Docker Swarm..."

# Verificar se o Docker Swarm está ativo
if ! docker info | grep -q "Swarm: active"; then
    echo "Erro: Docker Swarm não está ativo. Execute 'docker swarm init' primeiro."
    exit 1
fi

# Construir as imagens Docker
echo "Construindo imagem do monolith..."
docker build -t java-mvc-vt/monolith:latest ../java-mvc-vt/monolith

echo "Construindo imagem do gateway..."
docker build -t java-mvc-vt/gateway:latest ../java-mvc-vt/gateway

# Criar rede overlay se não existir
docker network create --driver overlay --attachable app-network 2>/dev/null || echo "Rede app-network já existe"

# Fazer deploy do stack
docker stack deploy -c docker-compose.yml java-mvc-vt

echo "Stack deploy iniciado. Use os seguintes comandos para monitorar:"
echo "  docker service ls"
echo "  docker service logs java-mvc-vt_gateway"
echo "  docker service logs java-mvc-vt_monolith"
echo ""
echo "A aplicação estará disponível em:"
echo "  Gateway: http://localhost:8080"
echo "  Health Check Gateway: http://localhost:8080/actuator/health"
echo "  Health Check Monolith: http://localhost:8080/actuator/health (via load balancer)"
