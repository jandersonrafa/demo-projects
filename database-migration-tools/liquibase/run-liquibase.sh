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
  -v $(pwd):/liquibase/workspace \
  -v $(pwd)/external_lib:/external_lib \
  liquibase/liquibase:latest \
  --defaults-file=/liquibase/workspace/liquibase.properties \
  --search-path=/liquibase/workspace \
  --classpath=/external_lib/postgresql.jar \
  status --verbose

echo ""
echo "Aplicando as migrações no banco de dados (update) forçando o contexto 'dev'..."
docker run --rm \
  --network migration_demo_net \
  -v $(pwd):/liquibase/workspace \
  -v $(pwd)/external_lib:/external_lib \
  liquibase/liquibase:latest \
  --defaults-file=/liquibase/workspace/liquibase.properties \
  --search-path=/liquibase/workspace \
  --classpath=/external_lib/postgresql.jar \
  update --contexts="dev"

echo ""
echo "Criando o arquivo de changelog (geração automática caso haja diferenças)... (Apenas demonstração)"
echo "O comando seria: docker run --rm ... liquibase:latest --defaultsFile=... generateChangeLog"
