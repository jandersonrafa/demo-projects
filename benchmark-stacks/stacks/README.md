# Benchmark Stacks: Java, Node, PHP, Python, Go, .NET, Rust

Este projeto é um benchmark comparativo de performance entre diferentes stacks tecnológicas, utilizando uma arquitetura de Gateway e Monolito com deployment via Nomad.


## Subir Infraestrutura (Consul & Nomad)
Em terminais separados, inicie os agentes em modo de desenvolvimento:

**Consul:**
```bash
cd /scritps
consul agent -dev -config-file=../nomad/config/consul.hcl

# Consul UI (Interface Web)
http://localhost:8500

```

**Nomad:**
```bash
cd /scritps
sudo nomad agent -dev -config=../nomad/config/nomad.hcl

# Nomad UI (Interface Web): 
http://localhost:4646
```

## 2. Deploy das Aplicações
Utilize o script centralizado para realizar o deploy de toda a stack (Infraestrutura e Aplicação):
```bash
cd /scritps
./deploy-nomad.sh
```

## 3. Limpeza
Para parar todos os jobs:
```bash
cd /scritps
./stop-nomad.sh
ou
./cleanup-nomad.sh
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

## Port Mapping

| Stack | Technology | Nomad Gateway (Traefik) | Nomad Monolith (Traefik) | Database User | Notes |
|-------|-----------|-------------------------|--------------------------|---------------|-------|
| **Java MVC VT** | Spring MVC + Virtual Threads | 8101 | 9101 | `java_mvcvt_user` | Virtual threads enabled |
| **Java WebFlux** | Spring WebFlux (Reactive) | 8102 | 9102 | `java_webflux_user` | Non-blocking reactive stack |
| **Node.js** | NestJS + TypeORM | 8103 | 9103 | `nodejs_user` | Event-driven architecture |
| **.NET Core** | ASP.NET Core 8.0 | 8104 | 9104 | `dotnet_user` | ASP.NET Core with EF Core |
| **Golang Gin** | Gin + GORM (Postgres) | 8105 | 9105 | `golang_user` | High-performance compiled Go |
| **PHP FPM** | Laravel + PHP-FPM + Nginx | 8106 | 9106 | `php_fpm_user` | Production-ready FPM |
| **PHP Octane** | Laravel Octane + Swoole | 8107 | 9107 | `php_octane_user` | High-performance async PHP |
| **Python** | FastAPI + SQLAlchemy | 8108 | 9108 | `python_fastapi_user` | Async Python with Uvicorn |
| **Rust Axum** | Rust + Axum + SQLx | 8109 | 9109 | `rust_user` | High-performance compiled Rust |
| **Java Quarkus** | Quarkus (Reactive) | 8110 | 9110 | `java_quarkus_user` | Supersonic Subatomic Java |



# Exemplo curl (Nomad via Traefik)

```bash
# Java MVC VT - Gateway
curl -X POST http://localhost:8101/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus MVC VT", "clientId": "client_1"}';

# Java MVC VT - Monolith
curl -X POST http://localhost:9101/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus MVC VT", "clientId": "client_1"}';

# Java WebFlux - Gateway
curl -X POST http://localhost:8102/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus WebFlux", "clientId": "client_1"}';

# Java WebFlux - Monolith
curl -X POST http://localhost:9102/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus WebFlux", "clientId": "client_1"}';

# Node.js - Gateway
curl -X POST http://localhost:8103/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Node", "clientId": "client_1"}';

# Node.js - Monolith
curl -X POST http://localhost:9103/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Node", "clientId": "client_1"}';

# .NET Core - Gateway
curl -X POST http://localhost:8104/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus .NET", "clientId": "client_1"}';

# .NET Core - Monolith
curl -X POST http://localhost:9104/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus .NET", "clientId": "client_1"}';

# Golang Gin - Gateway
curl -X POST http://localhost:8105/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Go", "clientId": "client_1"}';

# Golang Gin - Monolith
curl -X POST http://localhost:9105/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Go", "clientId": "client_1"}';

# PHP FPM - Gateway
curl -X POST http://localhost:8106/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP FPM", "clientId": "client_1"}';

# PHP FPM - Monolith
curl -X POST http://localhost:9106/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP FPM", "clientId": "client_1"}';

# PHP Octane - Gateway
curl -X POST http://localhost:8107/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP Octane", "clientId": "client_1"}';

# PHP Octane - Monolith
curl -X POST http://localhost:9107/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus PHP Octane", "clientId": "client_1"}';

# Python - Gateway
curl -X POST http://localhost:8108/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Python", "clientId": "client_1"}';

# Python - Monolith
curl -X POST http://localhost:9108/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Python", "clientId": "client_1"}';

# Rust Axum - Gateway
curl -X POST http://localhost:8109/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Rust", "clientId": "client_1"}';

# Rust Axum - Monolith
curl -X POST http://localhost:9109/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Rust", "clientId": "client_1"}';

# Java Quarkus - Gateway
curl -X POST http://localhost:8110/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Quarkus", "clientId": "client_1"}';

# Java Quarkus - Monolith
curl -X POST http://localhost:9110/bonus -H "Content-Type: application/json" -d '{"amount": 150.00, "description": "Test Bonus Quarkus", "clientId": "client_1"}';
```



