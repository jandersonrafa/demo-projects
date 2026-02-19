# Benchmark Stacks: Java, Node, PHP, Python, Go, .NET, Rust

Este projeto é um benchmark comparativo de performance entre diferentes stacks tecnológicas, utilizando uma arquitetura de Gateway e Monolito com deployment via Docker Swarm.

## 1. Inicializar Docker Swarm
Caso ainda não tenha inicializado o Swarm no seu nó:
```bash
docker swarm init
```

## 2. Deploy das Aplicações
Utilize o script centralizado para realizar o deploy no Docker Swarm.

**Para subir tudo:**
```bash
cd scripts
./deploy-swarm.sh
```

**Para subir apenas uma stack específica (ex: Java MVC VT):**
```bash
# Profiles disponíveis: 
# java-mvc-vt, java-webflux, java-quarkus, node-nestjs, dotnet, 
# golang, php-laravel-fpm, php-laravel-octane, python-fastapi, rust

cd scripts
./deploy-swarm.sh java-mvc-vt
```

## 3. Limpeza
Para parar todos os serviços e remover a stack:
```bash
cd scripts
./stop-swarm.sh
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

This project contains **10 different stacks** for performance benchmarking.

## Port Mapping (Docker Swarm)

| Stack | Technology | Swarm Service | Public Port (Traefik) | Database User | Notes |
|-------|-----------|-------------------------|--------------------------|---------------|-------|
| **Java MVC VT** | Spring MVC + Virtual Threads | `mvc-vt-monolith` | 8101 | `java_mvcvt_user` | Virtual threads enabled |
| **Java WebFlux** | Spring WebFlux (Reactive) | `webflux-monolith` | 8102 | `java_webflux_user` | Non-blocking reactive stack |
| **Node.js** | NestJS + TypeORM | `nestjs-monolith` | 8103 | `nodejs_user` | Event-driven architecture |
| **.NET Core** | ASP.NET Core 8.0 | `dotnet-monolith` | 8104 | `dotnet_user` | ASP.NET Core with EF Core |
| **Golang Gin** | Gin + GORM (Postgres) | `golang-monolith` | 8105 | `golang_user` | High-performance compiled Go |
| **PHP FPM** | Laravel + PHP-FPM + Nginx | `fpm-monolith` | 8106 | `php_fpm_user` | Production-ready FPM |
| **PHP Octane** | Laravel Octane + Swoole | `octane-monolith` | 8107 | `php_octane_user` | High-performance async PHP |
| **Python** | FastAPI + SQLAlchemy | `python-monolith` | 8108 | `python_fastapi_user` | Async Python with Uvicorn |
| **Rust Axum** | Rust + Axum + SQLx | `rust-monolith` | 8109 | `rust_user` | High-performance compiled Rust |
| **Java Quarkus** | Quarkus (Reactive) | `quarkus-monolith` | 8110 | `java_quarkus_user` | Supersonic Subatomic Java |



# Exemplo curl (Docker Swarm via Traefik)

```bash
# Java MVC VT
curl -X POST http://localhost:8101/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus MVC VT", "clientId": "client_1"}';

# Java WebFlux
curl -X POST http://localhost:8102/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus WebFlux", "clientId": "client_1"}';

# Node.js
curl -X POST http://localhost:8103/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Node", "clientId": "client_1"}';

# .NET Core
curl -X POST http://localhost:8104/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus .NET", "clientId": "client_1"}';

# Golang Gin
curl -X POST http://localhost:8105/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Go", "clientId": "client_1"}';

# PHP FPM
curl -X POST http://localhost:8106/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP FPM", "clientId": "client_1"}';

# PHP Octane
curl -X POST http://localhost:8107/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP Octane", "clientId": "client_1"}';

# Python
curl -X POST http://localhost:8108/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Python", "clientId": "client_1"}';

# Rust Axum
curl -X POST http://localhost:8109/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Rust", "clientId": "client_1"}';

# Java Quarkus
curl -X POST http://localhost:8110/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Quarkus", "clientId": "client_1"}';
```
```



