-- Create dedicated users for each stack
-- This script runs automatically when the PostgreSQL container is first initialized

-- Java WebFlux Stack
CREATE USER java_webflux_user WITH PASSWORD 'java_webflux_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO java_webflux_user;

-- Java MVC Virtual Threads Stack
CREATE USER java_mvcvt_user WITH PASSWORD 'java_mvcvt_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO java_mvcvt_user;

-- Java MVC Traditional Stack
CREATE USER java_mvc_user WITH PASSWORD 'java_mvc_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO java_mvc_user;

-- Node.js Express Stack
CREATE USER nodejs_express_user WITH PASSWORD 'nodejs_express_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO nodejs_express_user;

-- Node.js Fastify Stack
CREATE USER nodejs_fastify_user WITH PASSWORD 'nodejs_fastify_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO nodejs_fastify_user;

-- Python FastAPI Stack
CREATE USER python_fastapi_user WITH PASSWORD 'python_fastapi_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO python_fastapi_user;

-- PHP CLI Stack
CREATE USER php_cli_user WITH PASSWORD 'php_cli_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO php_cli_user;

-- PHP FPM Stack
CREATE USER php_fpm_user WITH PASSWORD 'php_fpm_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO php_fpm_user;

-- PHP Octane Stack
CREATE USER php_octane_user WITH PASSWORD 'php_octane_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO php_octane_user;

-- Go Stack
CREATE USER golang_user WITH PASSWORD 'golang_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO golang_user;

-- .NET Stack
CREATE USER dotnet_user WITH PASSWORD 'dotnet_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO dotnet_user;

-- Rust Stack
CREATE USER rust_user WITH PASSWORD 'rust_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO rust_user;

-- C++ Drogon Stack
CREATE USER cpp_drogon_user WITH PASSWORD 'cpp_drogon_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO cpp_drogon_user;

-- Java Quarkus Stack
CREATE USER java_quarkus_user WITH PASSWORD 'java_quarkus_pass';
GRANT ALL PRIVILEGES ON DATABASE benchmark TO java_quarkus_user;

-- Connect to the benchmark database to grant schema-level privileges
\c benchmark

-- Grant privileges on all existing tables and sequences
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO java_webflux_user, java_mvcvt_user, java_mvc_user, nodejs_express_user, nodejs_fastify_user, python_fastapi_user, php_cli_user, php_fpm_user, php_octane_user, golang_user, dotnet_user, cpp_drogon_user, rust_user, java_quarkus_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO java_webflux_user, java_mvcvt_user, java_mvc_user, nodejs_express_user, nodejs_fastify_user, python_fastapi_user, php_cli_user, php_fpm_user, php_octane_user, golang_user, dotnet_user, cpp_drogon_user, rust_user, java_quarkus_user;

-- Grant default privileges for future tables and sequences
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO java_webflux_user, java_mvcvt_user, java_mvc_user, nodejs_express_user, nodejs_fastify_user, python_fastapi_user, php_cli_user, php_fpm_user, php_octane_user, golang_user, dotnet_user, cpp_drogon_user, rust_user, java_quarkus_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO java_webflux_user, java_mvcvt_user, java_mvc_user, nodejs_express_user, nodejs_fastify_user, python_fastapi_user, php_cli_user, php_fpm_user, php_octane_user, golang_user, dotnet_user, cpp_drogon_user, rust_user, java_quarkus_user;

