# Subir container docker kong gateway https://suraj-batuwana.medium.com/managing-spring-boot-micro-services-with-kong-part-1-install-kong-c652eec67a35
docker network create kong-micro
docker run -d --name kong-database --network=kong-micro -p 5432:5432 -e "POSTGRES_USER=kong" -e "POSTGRES_DB=kong" -e "POSTGRES_PASSWORD=kong" postgres:9.6
docker run --rm --network=kong-micro -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-database" -e "KONG_PG_PASSWORD=kong" -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" kong:latest kong migrations bootstrap
docker run -d --name kong --network=kong-micro -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-database" -e "KONG_PG_PASSWORD=kong" -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" -e "KONG_PROXY_ERROR_LOG=/dev/stderr" -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" -p 8000:8000 -p 8443:8443 -p 127.0.0.1:8001:8001 -p 127.0.0.1:8444:8444 kong:latest

# subir aplicacao spring com api hello world
mvn clean package
mvn spring-boot:build-image
docker run --network=kong-micro --name kong-spring-hello-world -p 9000:9000 docker.io/library/demo:0.0.1-SNAPSHOT
 
# Setup API server routing using Spring boot microservices
cria servico: curl -i -s -X POST http://localhost:8001/services \
  --data name=kong-spring-hello-world \
  --data url='http://172.18.0.4:9000/v1/temperature/convert-to-fahrenheit/102'
cria rota : curl -i -X POST --url http://localhost:8001/services/kong-spring-hello-world/routes --data "name=kong-spring-hello-world-v1" --data "paths[]=/convert-to-fahrenheit-v1"
verificar ip: docker inspect kong-micro

# servico com parametros dinamicos
curl -i -X POST --url http://localhost:8001/services/ --data "name=temperature" --data "url=http://172.18.0.4:9000/v1/temperature"

curl -i -X POST --url http://localhost:8001/services/temperature/routes --data "name=temperature" --data "paths[]=/temperature-v1"

# Testar servicos e rotas criados
Listar servicos: curl http://localhost:8001/services/
Detalhar servico: curl http://localhost:8001/services/kong-spring-hello-world/
Detalhar rotas de servico: curl http://localhost:8001/services/kong-spring-hello-world/routes
Testar endpoint: curl http://localhost:8000/convert-to-fahrenheit-v1
Testar endpoint dinamico: curl http://localhost:8000/temperature-v1/convert-to-fahrenheit/2000

# Limitar requisicoes 3 por hora
curl -X POST http://localhost:8001/services/temperature/plugins \
    --data "name=rate-limiting"  \
    --data "config.second=20" \
    --data "config.hour=1000" \
    --data "config.policy=local"
Testar: http://localhost:8000/temperature-v1/convert-to-fahrenheit/201
Deletar plugin: curl -X DELETE http://localhost:8001/services/temperature/plugins/9b4a9234-3a4a-4c8c-a432-e0d3d2467b87

# Habilitar cache
cache geral: curl -i -X POST http://localhost:8001/plugins \                                                       
  --data "name=proxy-cache" \
  --data "config.request_method=GET" \
  --data "config.response_code=200" \
  --data "config.content_type=application/json; charset=utf-8" \
  --data "config.cache_ttl=30" \
  --data "config.strategy=memory"

cache  servico: curl -X POST http://localhost:8001/services/temperature/plugins \                                      
   --data "name=proxy-cache" \
   --data "config.request_method=GET" \
   --data "config.response_code=200" \
      --data "config.cache_ttl=30" \
   --data "config.strategy=memory"

   
Deletar plugin: curl -X DELETE http://localhost:8001/plugins/63046e49-3e72-43f7-9952-6f123fedb9ca 