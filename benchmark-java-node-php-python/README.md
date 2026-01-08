## Start/Stop the Stack

Para limpar o histórico de métricas e os dados do banco antes de um novo benchmark:

```bash
# Subir stack docker compose
docker compose up -d

# Subir stack docker compose forçando recriação
docker compose up --build --force-recreate -d

# Parar docker compose
docker compose down

# Parar docker compose e limpa banco de dados
docker compose down -v
```

# Query agrupar por linguagem bonus criados
SELECT  
    LEFT(description, 10) AS prefixo,
  COUNT(*) AS total
FROM bonus
GROUP BY  LEFT(description, 10)