datacenters = ["dc1"]
region      = "global"

postgres_image = "postgres:16-alpine"
traefik_image  = "traefik:v3.0"
monolith_image = "nomad/monolith:1.0"
gateway_image  = "nomad/gateway:1.0"
monolith_nestjs_image = "nomad/monolith-nestjs:1.0"
gateway_nestjs_image  = "nomad/gateway-nestjs:1.0"

db_user     = "postgres"
db_password = "postgres"
db_name     = "benchmark"
