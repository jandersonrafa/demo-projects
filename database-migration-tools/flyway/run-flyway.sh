#!/bin/bash
# Script utilitário para testar o Flyway via Docker com suporte a ambientes

cd "$(dirname "$0")"

# Ambiente alvo (dev ou prod). Default para dev.
ENV=${1:-dev}
LOCATIONS="filesystem:/flyway/sql/common"

# Se for dev, adicionamos a pasta de massa de dados
if [ "$ENV" == "dev" ]; then
  LOCATIONS="$LOCATIONS,filesystem:/flyway/sql/dev"
fi

echo "=========================================="
echo "Executando Flyway no ambiente: $ENV"
echo "Locations mapeadas: $LOCATIONS"
echo "=========================================="

echo "1. Mostrando o status atual do banco de dados (Flyway Info)..."
docker run --rm \
  --network migration_demo_net \
  -v $(pwd)/conf:/flyway/conf \
  -v $(pwd)/sql:/flyway/sql \
  flyway/flyway:latest \
  -configFiles=/flyway/conf/flyway.conf \
  -locations="$LOCATIONS" \
  info

echo ""
echo "2. Aplicando as migrações SQL..."
docker run --rm \
  --network migration_demo_net \
  -v $(pwd)/conf:/flyway/conf \
  -v $(pwd)/sql:/flyway/sql \
  flyway/flyway:latest \
  -configFiles=/flyway/conf/flyway.conf \
  -locations="$LOCATIONS" \
  migrate

echo ""
echo "3. Status após a migração..."
docker run --rm \
  --network migration_demo_net \
  -v $(pwd)/conf:/flyway/conf \
  -v $(pwd)/sql:/flyway/sql \
  flyway/flyway:latest \
  -configFiles=/flyway/conf/flyway.conf \
  -locations="$LOCATIONS" \
  info
