# Executor k6

Esta pasta centraliza a inteligência e a execução dos testes de carga do projeto utilizando o **Grafana k6**. Aqui você encontrará os scripts que definem os cenários de teste e o local onde os relatórios de execução são armazenados.

## Organização de Pastas

- **[reports](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/executor-k6/reports)**: Contém os resultados das execuções consolidados. Os arquivos são gerados automaticamente em formato JSON (para processamento posterior) e HTML (para visualização rápida no navegador).
- **[scripts](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/executor-k6/scripts)**: Contém a lógica dos testes em Javascript.
  - `load-all.js`: Utilizado para o benchmark de **Limites** (RPS progressivo).
  - `load-all-150rps.js`: Utilizado para o benchmark de **Eficiência de Hardware** (carga constante de 150 RPS).

---

# Como Executar os Testes
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


Executar dentro nivel acima de scripts 

docker run --rm \
  --name benchmark-k6 \
  --network="host" \
  -v $(pwd)/scripts:/scripts \
  -v $(pwd)/reports:/reports \
  -w /scripts \
  -e TARGETS="192.168.0.114:8101,192.168.0.114:8102" \
  -e K6_PROMETHEUS_RW_SERVER_URL="http://localhost:9091/api/v1/write" \
  -e K6_PROMETHEUS_RW_TREND_STATS="p(95),p(99),avg" \
  grafana/k6:latest run \
  -o experimental-prometheus-rw \
  load-all.js