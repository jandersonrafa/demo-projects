# introducao
Service Discovery (Descoberta de Serviço) é um padrão arquitetural usado em ambientes distribuídos, especialmente em arquiteturas de microsserviços. O objetivo principal da Service Discovery é permitir que os serviços em uma aplicação distribuída descubram e se comuniquem uns com os outros de forma dinâmica, sem a necessidade de configurações estáticas.

Consul é um exemplo de service discovery, mas existem outras alternativas como netflix eureka, etcd e zookeeper

Consul oferece 5 funcionalidades, 4 além do service discovery
- servicediscovery
- dns
- health checking
- kv store
- secure service connection 

# Como configurar
instalar consul
https://developer.hashicorp.com/consul/docs/install
https://developer.hashicorp.com/consul/downloads

instalar consul basta baixar o zip, descompactar que ele vai extrair um arquivo .exe. Dentro da pasta com o executavel rodar consul com comando consul agent -dev
Ele vai estar rodando em http://localhost:8500/ui/dc1/services
https://www.baeldung.com/spring-cloud-consul


Posteriormente a isso pode ser subido as aplicações client e server:
- client: aplicação que faz chamada para aplicação server
- server: aplicação que responde pelo endpoint /hello/server

# Instruções de teste 
Após consul, server e client estarem no ar, basta chamar o endpoint do client http://localhost:8080/hello que ele vai buscar no consul através do método  `discoveryClient.getInstances("test-server-consul")` quais endereços estao disponiveis para responder a esse microservico server, ou seja se tiver mais de dois rodando ele retorna 2 na lista. Após selecionar a instancia destino o client faz a requisição direto para o server.

Sendo assim o fluxo de comunicação fica:
client (/hello)-> consul (retorna endpoint instancia server)-> client (faz chamada server-> server (responde pelo endpoint /hello/server)