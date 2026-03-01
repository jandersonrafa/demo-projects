#!/usr/bin/env bash

# =============================================================================
# Script simples para rodar o benchmark k6 DUAS VEZES consecutivas
# Uso: ./run-2x.sh "192.168.0.114:8109"   ou   ./run-2x.sh "host1:port,host2:port"
# =============================================================================

TARGETS="$1"           # Recebe os targets como primeiro argumento
RUNS=2                 # Sempre roda 2 vezes
# RUNS=2                 # Sempre roda 2 vezes
INTERVAL=10            # Pausa de 10 segundos entre as duas execuções

# Loop para executar 2 vezes
for i in $(seq 1 $RUNS); do
    echo "→ Execução $i/$RUNS - Targets: $TARGETS - $(date '+%Y-%m-%d %H:%M:%S')"

    # Comando Docker que você já usa (com nome diferente por run)
    docker run --rm \
      --name benchmark-k6-run${i} \
      --network="host" \
      -v "$(pwd)/../k6-scripts:/scripts" \
      -v "$(pwd)/../reports:/reports" \
      -w /scripts \
      -e TARGETS="$TARGETS" \
      -e K6_PROMETHEUS_RW_SERVER_URL="http://192.168.0.137:9091/api/v1/write" \
      -e K6_PROMETHEUS_RW_TREND_STATS="p(95),p(99),avg" \
      grafana/k6:latest run \
      -o experimental-prometheus-rw \
      load-all.js

    # Se não for a última execução, espera um pouco
    if [ $i -lt $RUNS ]; then
        sleep $INTERVAL
    fi
done

echo "Finalizado - Targets: $TARGETS - $(date '+%Y-%m-%d %H:%M:%S')"


# Executar com 
#./run-2x.sh "192.168.0.114:8109"
# ou vários targets
# ./run-2x.sh "192.168.0.114:8109,192.168.0.115:8110"