# Referencias
https://www.vinsguru.com/circuit-breaker-pattern/
https://medium.com/@truongbui95/circuit-breaker-pattern-in-spring-boot-d2d258b75042

# introdução
Conceito de circuit breaker é utilizado para configurar que além de oferecer respostas padrao para caso a comunicacao entre servico a e b falhe, tambem seja evitado que quando servico b se recupere ocorra uma enxurrada de requisições que acabe derrubando servico b antes mesmo de startar. 

Projeto e composto de um client e um server
Client tem endpoint http://localhost:8080/hello que ao ser acionado chama endpoint do server http://localhost:2000/hello
Chamada realizada é envolta de um circuit breaker que basicamente chama o servidor pelo metodo callserver e caso falhe retorna resposta padrao do metodo getDefaultResponseHello

Classe [ ](client/src/main/java/com/example/demo/controller/Resilience4JConfiguration.java) define quantas vezes vai tentar realizar a chamada para o servico b antes de comecar a retornar automaticamente a resposta padrao


