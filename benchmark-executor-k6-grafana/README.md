# Benchmark Environment

### Start the Monitoring Stack
```bash
cd ../monitoring
docker compose up -d
```

## Accessing the Tools
- **Grafana**: [http://localhost:3000](http://localhost:3000) (User: `admin`, Pass: `admin`)
- **Prometheus**: [http://localhost:9091](http://localhost:9091)
- **cAdvisor**: [http://localhost:8081](http://localhost:8081)

## Running Load Tests with K6

To run the default benchmark (all apps):
```bash
cd monitoring
docker compose run --rm k6
```

To run against a specific app (e.g., Java MVC VT on port 3007):
```bash
cd monitoring
docker compose run --rm -e TARGETS="host.docker.internal:3007" k6


To run against a specific app (e.g., Java MVC VT on port 3007) generate report in reports/:
```bash
cd monitoring
docker compose run --rm -e TARGETS="host.docker.internal:3007"  k6 run --summary-export=/reports/summary.json /scripts/load-all.js
```

> [!NOTE]
> O K6 agora está configurado para enviar métricas diretamente para o Prometheus (`remote_write`). Você pode visualizar os resultados detalhados no dashboard **K6 - Load Test Performance** no Grafana.

> [!TIP]
> Use `host.docker.internal` para acessar serviços rodando no host de dentro dos containers.

## Resetting Data

Para limpar o histórico de métricas e os dados do banco antes de um novo benchmark:

1.  **Limpar tudo (Métricas + Banco)**:
    ```bash
    cd apps && docker compose down -v
    cd ../monitoring && docker compose down -v
    ```
2.  **Limpar apenas métricas (Grafana/Prometheus)**:
    ```bash
    cd monitoring && docker compose down -v
    ```
3.  **Subir novamente**:
    ```bash
    cd apps && docker compose up -d
    cd ../monitoring && docker compose up -d
    ```
