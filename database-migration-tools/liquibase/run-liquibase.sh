#!/bin/bash
# Script utilitário para testar o Liquibase com PostgreSQL através de um container efêmero.
#
# Para rodar:
# chmod +x run-liquibase.sh
# ./run-liquibase.sh

cd "$(dirname "$0")"

echo "Verificando o status das migrações do Liquibase..."
docker run --rm \
  --network migration_demo_net \
  -v $(pwd)/changelog:/liquibase/changelog \
  -v $(pwd)/liquibase.properties:/liquibase/liquibase.properties \
  liquibase/liquibase:latest \
  --defaultsFile=/liquibase/liquibase.properties \
  status --verbose

echo ""
echo "Aplicando as migrações no banco de dados (update)..."
docker run --rm \
  --network migration_demo_net \
  -v $(pwd)/changelog:/liquibase/changelog \
  -v $(pwd)/liquibase.properties:/liquibase/liquibase.properties \
  liquibase/liquibase:latest \
  --defaultsFile=/liquibase/liquibase.properties \
  update

echo ""
echo "Criando o arquivo de changelog (geração automática caso haja diferenças)... (Apenas demonstração)"
echo "O comando seria: docker run --rm ... liquibase:latest --defaultsFile=... generateChangeLog"
