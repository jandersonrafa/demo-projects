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

```

## Accessing the Tools
- **Grafana**: [http://localhost:3000](http://localhost:3000) (User: `admin`, Pass: `admin`)
- **Prometheus**: [http://localhost:9091](http://localhost:9091)


> [!TIP]
> Use `host.docker.internal` para acessar serviços rodando no host de dentro dos containers.

    ```
