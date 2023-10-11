# Stackify prefix-
Trial por 14 dias depois versao free com funcionalidades reduzidas
https://docs.stackify.com/docs/prefix-java-on-windows

Ferramenta muito interessante para verificar tempos de reposta de cada requisicao, requests mais lentos, metodos mais lentos, queries lentas

https://stackify.com/java-profilers-3-types/

# Gerar jar executavel
mvn clean install dentro do projeto hello

# Como instalar
- Baixar instalação interface Stackify Prefix para visualizar requests
- Baixar jar do agent 
- Abrir stackfy
- Executar aplicacao com agente 
`java -javaagent:"C:\projetos-pessoais\demo-projects\profiler-stackify-prefix\stackify-java-apm-latest\stackify-java-apm.jar" -jar target/demo-0.0.1-SNAPSHOT.jar`
