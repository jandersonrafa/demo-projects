# Descrição
Foi criado a seguinte estrutura:
- grpc: (pacote microservicos comunicacao protocolo grpc)
    - client: microservico client para fazer chamada
    - server: microservico server para responder chamada
- openfeign:(pacote microservicos comunicacao protocolo rest)
    - client: microservico client para fazer chamada
    - server: microservico server para responder chamada


# GRPC - Definição
Client e server possuem arquivo protobuf PingPongService.proto com definicao de objeto de transporte.
Endpoint testar ping: curl http://localhost:8080/pingpong/ping
- Classe GRPCClientService.java no client faz chamada que e respondida pela classe PingPongServiceImpl.java no server


# Openfeign - Definição
Client e server possuem model PongResponse duplicada  com definicao de objeto de transporte.
Endpoint testar ping: curl http://localhost:8080/pingpong/ping
- Classe OpenFeignClientService.java no client faz chamada que e respondida pela classe PingPongServiceImpl.java no server

# Anotacoes
## Pros
arquivo protobug permite objetos complexos de forma simples
facil implementacao
## contras
nao é compativel com spring 3 nesse momento
ainda nao e incorporado pelo spring
num simples de carga demorou mais tempo para responder devido a response ser pequeno

# Teste de carga
Foi realizado um teste de carga simples com apache benchmark
Comando utilizado: `ab -n 10000 -c 50 http://localhost:8080/pingpong/ping`
Nesses testes tivemos os seguintes resultados (imagens na raiz do projeto)
- Rest
    - Requests per second:: 1330
    - Time per request: 37 ms
- Grpc
    - Requests per second:: 613
    - Time per request: 81 ms
    
Resumidamente podemos observar no grafico abaixo que o grpc se mostra melhor apenas em cenarios onde o response é de um tamanho grande, e response de tamanhos pequenos o rest pode ser superior

https://github.com/recepinanc/spring-boot-grpc-benchmarking/tree/main/benchmarking/response-time-graphs
https://github.com/recepinanc/spring-boot-grpc-benchmarking/blob/main/benchmarking/response-time-graphs/collage.png


# Referencias
https://sajeerzeji44.medium.com/grpc-for-spring-boot-microservices-bd9b79569772
https://github.com/piinalpin/gRPC-example