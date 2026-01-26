# Docker Compose Stack Commands

This document lists the commands to start and stop each of the 10 benchmarking stacks independently.

> [!NOTE]
> All stacks depend on the **Postgres** service. The commands below are configured to automatically start Postgres if it's not already running.

---

### Command Examples
- To start the Node stack: `docker compose --profile node up -d`
- To stop the Node stack: `docker compose --profile node down`
- To start the WebFlux stack: `docker compose --profile webflux up -d`
- To start **ALL** stacks at once: `docker compose --profile "*" up -d`


## 1. Node NestJS
- **Up**: `docker compose --profile node up -d`
- **Down**: `docker compose --profile node down`

## 2. Java WebFlux
- **Up**: `docker compose --profile webflux up -d`
- **Down**: `docker compose --profile webflux down`

## 3. Java MVC Virtual Threads
- **Up**: `docker compose --profile mvc-vt up -d`
- **Down**: `docker compose --profile mvc-vt down`

## 4. Java MVC Traditional
- **Up**: `docker compose --profile mvc up -d`
- **Down**: `docker compose --profile mvc down`

## 5. Python FastAPI
- **Up**: `docker compose --profile python up -d`
- **Down**: `docker compose --profile python down`

## 6. PHP Laravel
- **Up**: `docker compose --profile php up -d`
- **Down**: `docker compose --profile php down`

## 7. PHP Laravel FPM
- **Up**: `docker compose --profile php-fpm up -d`
- **Down**: `docker compose --profile php-fpm down`

## 8. PHP Laravel Octane
- **Up**: `docker compose --profile php-octane up -d`
- **Down**: `docker compose --profile php-octane down`

## 9. Golang Gin
- **Up**: `docker compose --profile golang up -d`
- **Down**: `docker compose --profile golang down`

## 10. .NET Core
- **Up**: `docker compose --profile dotnet up -d`
- **Down**: `docker compose --profile dotnet down`

## 11. Rust Axum
- **Up**: `docker compose --profile rust up -d`
- **Down**: `docker compose --profile rust down`

## 12. C++ Drogon
- **Up**: `docker compose --profile cpp up -d`
- **Down**: `docker compose --profile cpp down`

---

## Shared Database (Postgres)
If you want to manage only the database:
- **Up**: `docker compose up -d postgres`
- **Down**: `docker compose stop postgres && docker compose rm -f postgres`

## Manage All Stacks
To manage everything at once (including all profiles):
- **Up**: `docker compose --profile "*" up -d`
- **Down**: `docker compose --profile "*" down`

