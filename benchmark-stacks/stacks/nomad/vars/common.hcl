# --- Global Infrastructure Config ---
datacenters = ["dc1"]
region      = "global"

# --- Database Config ---
db_user     = "postgres"
db_password = "postgres"
db_name     = "benchmark"

# --- Infrastructure Images ---
postgres_image  = "postgres:16-alpine"
pgbouncer_image = "edoburu/pgbouncer:latest"
traefik_image   = "traefik:v3.0"

# --- Infrastructure Resource Limits ---
postgres_cpu    = 2000
postgres_mem    = 4096
postgres_count  = 1
pgbouncer_cpu   = 1000
pgbouncer_mem   = 1024
pgbouncer_count = 1
traefik_cpu     = 1000
traefik_mem     = 1024
traefik_count   = 1

# --- Application Images ---
monolith_mvc_image     = "benchmark-stacks/java-mvc-monolith:1.0"
gateway_mvc_image      = "benchmark-stacks/java-mvc-gateway:1.0"
monolith_mvc_vt_image  = "benchmark-stacks/java-mvc-vt-monolith:1.0"
gateway_mvc_vt_image   = "benchmark-stacks/java-mvc-vt-gateway:1.0"
monolith_webflux_image = "benchmark-stacks/java-webflux-monolith:1.0"
gateway_webflux_image  = "benchmark-stacks/java-webflux-gateway:1.0"

# --- Application Resource Limits (Standardized) ---
app_monolith_cpu = 1000
app_monolith_mem = 2048
app_monolith_count = 2
app_gateway_cpu  = 1000
app_gateway_mem  = 2048
app_gateway_count  = 2
