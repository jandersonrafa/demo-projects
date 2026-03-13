#!/bin/bash
# Script utilitário para testar o Atlas via Docker

cd "$(dirname "$0")"

echo "1. Inspecionando o esquema atual do banco de dados (deve estar vazio ou com as tabelas do Liquibase)..."
docker run --rm \
  --network migration_demo_net \
  arigaio/atlas:latest \
  schema inspect -u "postgres://demo_user:demo_password@demo_postgres:5432/demo_db?sslmode=disable"

echo ""
echo "2. Visualizando as mudanças (diff) necessárias para chegar ao estado desejado (schema.sql)..."
docker run --rm \
  --network migration_demo_net \
  -v $(pwd):/workspace \
  -w /workspace \
  arigaio/atlas:latest \
  schema apply --dry-run \
  --env local \
  --config file:///workspace/atlas.hcl

echo ""
echo "3. Aplicando as mudanças no banco de dados para sincronizar com o arquivo schema.sql..."
docker run --rm \
  --network migration_demo_net \
  -v $(pwd):/workspace \
  -w /workspace \
  arigaio/atlas:latest \
  schema apply \
  --env local \
  --config file:///workspace/atlas.hcl \
  --auto-approve

echo ""
echo "4. Inspecionando o esquema novamente (todas as tabelas do schema.sql devem estar presentes)..."
docker run --rm \
  --network migration_demo_net \
  arigaio/atlas:latest \
  schema inspect -u "postgres://demo_user:demo_password@demo_postgres:5432/demo_db?sslmode=disable"
