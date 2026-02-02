# Executar k6
```
sudo snap install k6

```

# Executar testes k6 com base no script k6/scripts/load-all.js
k6 run k6/scripts/load-all.js

# Executar testes k6  focado  em stacks especificos com base no script k6/scripts/load-all.js
TARGETS="localhost:3007" k6 run k6/scripts/load-all.js

# Enviar métricas para o Prometheus
export K6_PROMETHEUS_RW_SERVER_URL=http://localhost:9091/api/v1/write
TARGETS="localhost:3007" k6 run -o experimental-prometheus-rw k6/scripts/load-all.js


docker run --rm \
  --name benchmark-k6 \
  --network="host" \
  -v $(pwd)/k6/scripts:/scripts \
  -w /scripts \
  -e TARGETS="localhost:3007" \
  -e K6_PROMETHEUS_RW_SERVER_URL="http://localhost:9091/api/v1/write" \
  -e K6_PROMETHEUS_RW_TREND_STATS="p(95),p(99),avg" \
  grafana/k6:latest run \
  -o experimental-prometheus-rw \
  load-all.js