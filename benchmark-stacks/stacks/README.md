# Benchmark Stacks: Java, Node, PHP, Python, Go, .NET, Rust, C++

Este projeto é um benchmark comparativo de performance entre diferentes stacks tecnológicas, utilizando uma arquitetura de Gateway e Monolito.

## 🚀 Como Iniciar

Para limpar o histórico de métricas e os dados do banco antes de um novo benchmark:

Para informações detalhadas de como subir cada stack individualmente, consulte o arquivo [COMMANDS.md](COMMANDS.md).

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

This project contains **12 different stacks** for performance benchmarking.

## Port Mapping

| Stack | Technology | Docker Compose (Standard) | Nomad Gateway (Traefik) | Database User | Notes |
|-------|-----------|---------------------------|-------------------------|---------------|-------|
| **Java MVC VT** | Spring MVC + Virtual Threads | 3007 / 3003 | 8101 / 9101 | `java_mvcvt_user` | Virtual threads enabled |
| **Java WebFlux** | Spring WebFlux (Reactive) | 3006 / 3002 | 8102 / 9102 | `java_webflux_user` | Non-blocking reactive stack |
| **Node.js** | NestJS + TypeORM | 3005 / 3001 | 8103 / 9103 | `nodejs_user` | Event-driven architecture |
| **.NET Core** | ASP.NET Core 8.0 | 3020 / 3021 | 8104 / 9104 | `dotnet_user` | ASP.NET Core with EF Core |
| **Golang Gin** | Gin + GORM (Postgres) | 3018 / 3019 | 8105 / 9105 | `golang_user` | High-performance compiled Go |
| **PHP FPM** | Laravel + PHP-FPM + Nginx | 3011 / 3012 | 8106 / 9106 | `php_fpm_user` | Production-ready FPM |
| **PHP Octane** | Laravel Octane + Swoole | 3014 / 3015 | 8107 / 9107 | `php_octane_user` | High-performance async PHP |
| **Python** | FastAPI + SQLAlchemy | 3008 / 3004 | 8108 / 9108 | `python_fastapi_user` | Async Python with Uvicorn |
| **Rust Axum** | Rust + Axum + SQLx | 3024 / 3025 | 8109 / 9109 | `rust_user` | High-performance compiled Rust |
| **Java Quarkus** | Quarkus (Reactive) | N/A | 8110 / 9110 | `java_quarkus_user` | Supersonic Subatomic Java |
| **Java MVC** | Spring MVC (Traditional) | 3016 / 3017 | N/A | `java_mvc_user` | Traditional thread pool |
| **PHP CLI** | Laravel (CLI Server) | 3009 / 3010 | N/A | `php_cli_user` | Built-in PHP server |
| **C++ Drogon** | Drogon Framework | 3022 / 3023 | N/A | `cpp_drogon_user` | High-performance C++ |



# Exemplo curl

```bash
# Node.js
curl -X POST http://localhost:3005/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Node", "clientId": "client_1"}';

# Java WebFlux
curl -X POST http://localhost:3006/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus WebFlux", "clientId": "client_1"}';

# Java MVC VT
curl -X POST http://localhost:3007/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus MVC VT", "clientId": "client_1"}';

# Python
curl -X POST http://localhost:3008/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Python", "clientId": "client_1"}';

# PHP CLI
curl -X POST http://localhost:3009/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP CLI", "clientId": "client_1"}';

# PHP FPM
curl -X POST http://localhost:3011/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP FPM", "clientId": "client_1"}';

# PHP Octane
curl -X POST http://localhost:3014/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP Octane", "clientId": "client_1"}';

# Java MVC Traditional
curl -X POST http://localhost:3016/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus MVC", "clientId": "client_1"}';

# Golang Gin
curl -X POST http://localhost:3018/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Go", "clientId": "client_1"}';

# .NET Core
curl -X POST http://localhost:3020/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus .NET", "clientId": "client_1"}';

# C++ Drogon
curl -X POST http://localhost:3022/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus C++", "clientId": "client_1"}';

# Rust Axum
curl -X POST http://localhost:3024/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Rust", "clientId": "client_1"}';
```



