## Start/Stop the Stack

Para limpar o histórico de métricas e os dados do banco antes de um novo benchmark:

Para subir por stack leiad COMMANDS.md;

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
```SQL
-- Monitorar conexoes por stack (user) database
SELECT
    usename AS usuario,
    COUNT(*) AS total_conexoes,
    COUNT(*) FILTER (WHERE state = 'active') AS ativas,
    COUNT(*) FILTER (WHERE state = 'idle') AS idle,
    COUNT(*) FILTER (WHERE state = 'idle in transaction') AS idle_em_transacao
FROM pg_stat_activity
GROUP BY usename
ORDER BY total_conexoes DESC;

-- Monitorar conexoes por stack (user) database
SELECT usename, application_name, state, count(*) 
FROM pg_stat_activity 
WHERE usename LIKE '%_user' 
GROUP BY usename, application_name, state;


-- Verificar registros criados por stack
SELECT  
    split_part(description , '-', 1) AS prefixo,
  COUNT(*) AS total
FROM bonus
GROUP BY  split_part(description, '-', 1);
```


# 📊 Available Stacks

This project contains **10 different stacks** for performance benchmarking:

| Stack | Technology | Gateway Port | Monolith Port | Database User | Notes |
|-------|-----------|--------------|---------------|---------------|-------|
| **Java WebFlux** | Spring WebFlux (Reactive) | 3006 | 3002 | `java_webflux_user` | Non-blocking reactive stack |
| **Java MVC VT** | Spring MVC + Virtual Threads | 3007 | 3003 | `java_mvcvt_user` | Virtual threads enabled |
| **Java MVC** | Spring MVC (Traditional) | 3016 | 3017 | `java_mvc_user` | Traditional thread pool |
| **Node.js** | NestJS + TypeORM | 3005 | 3001 | `nodejs_user` | Event-driven architecture |
| **Python** | FastAPI + SQLAlchemy | 3008 | 3004 | `python_fastapi_user` | Async Python with Uvicorn |
| **PHP CLI** | Laravel (CLI Server) | 3009 | 3010 | `php_cli_user` | Built-in PHP server |
| **PHP FPM** | Laravel + PHP-FPM + Nginx | 3011 | 3012 | `php_fpm_user` | Production-ready FPM |
| **PHP Octane** | Laravel Octane + Swoole | 3014 | 3015 | `php_octane_user` | High-performance async PHP |
| **Golang Gin** | Gin + GORM (Postgres) | 3018 | 3019 | `golang_user` | High-performance compiled Go |
| **.NET Core** | ASP.NET Core 8.0 | 3020 | 3021 | `dotnet_user` | ASP.NET Core with EF Core |
| **Rust Axum** | Rust + Axum + SQLx | 3022 | 3023 | `rust_user` | High-performance compiled Rust |


# Exemplo curl

```bash
curl -X POST http://localhost:3005/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP", "clientId": "client_5"}';

curl -X POST http://localhost:3006/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP", "clientId": "client_5"}';

curl -X POST http://localhost:3007/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP", "clientId": "client_5"}';

curl -X POST http://localhost:3008/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP", "clientId": "client_5"}';

curl -X POST http://localhost:3009/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP", "clientId": "client_5"}';

curl -X POST http://localhost:3011/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP", "clientId": "client_5"}';

curl -X POST http://localhost:3014/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP", "clientId": "client_5"}';

curl -X POST http://localhost:3016/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP", "clientId": "client_5"}';

curl -X POST http://localhost:3018/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Go", "clientId": "client_5"}';

curl -X POST http://localhost:3020/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus .NET", "clientId": "client_5"}';

curl -X POST http://localhost:3022/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Rust", "clientId": "client_5"}';
```



