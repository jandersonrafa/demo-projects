#!/bin/bash

# Script para inicializar o stack no Nomad

echo "Iniciando deploy do stack java-mvc-vt no Nomad..."

# Verificar se o Nomad está ativo
if ! nomad server members 2>/dev/null | grep -q "alive"; then
    echo "Erro: Nomad não está ativo."
    exit 1
fi

# Construir as imagens Docker
echo "Construindo imagem do monolith..."
docker build -t java-mvc-vt-monolith:local ../java-mvc-vt/monolith

echo "Construindo imagem do gateway..."
docker build -t java-mvc-vt-gateway:local ../java-mvc-vt/gateway

# Fazer deploy do job Nomad
echo "Fazendo deploy do job Nomad..."
nomad job run java-mvc-vt.nomad

echo "Job deploy iniciado. Use os seguintes comandos para monitorar:"
echo "  nomad job status java-mvc-vt"
echo "  nomad job status java-mvc-vt -verbose"
echo "  nomad alloc logs <alloc-id>"
echo ""
echo "A aplicação estará disponível em:"
echo "  Gateway: http://localhost:8080"
echo "  Health Check Gateway: http://localhost:8080/actuator/health"
