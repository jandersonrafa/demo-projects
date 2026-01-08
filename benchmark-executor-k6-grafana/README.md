# Benchmark Environment

## Start/Stop the Monitoring Stack

Para limpar o histórico de métricas e os dados do banco antes de um novo benchmark:

```bash
# Subir stack docker compose
docker compose up -d

# Subir stack docker compose forçando recriação
docker compose up --build --force-recreate -d

# Parar docker compose
docker compose down

# Parar docker compose e limpa volume com métricas
docker compose down -v

# Executar testes k6 com base no script k6/scripts/load-all.js
docker compose run --rm k6

# Executar testes k6  focado  em stacks especificos com base no script k6/scripts/load-all.js
docker compose run --rm -e TARGETS="host.docker.internal:3007" k6
```

## Accessing the Tools
- **Grafana**: [http://localhost:3000](http://localhost:3000) (User: `admin`, Pass: `admin`)
- **Prometheus**: [http://localhost:9091](http://localhost:9091)
- **cAdvisor**: [http://localhost:8081](http://localhost:8081)


> [!NOTE]
> O K6 agora está configurado para enviar métricas diretamente para o Prometheus (`remote_write`). Você pode visualizar os resultados detalhados no dashboard **K6 - Load Test Performance** no Grafana.

> [!TIP]
> Use `host.docker.internal` para acessar serviços rodando no host de dentro dos containers.

    ```
