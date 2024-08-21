# Subir projeto
Start redis: docker run -d --name redis-stack-server -p 6379:6379 redis/redis-stack-server:latest


# Componentes
admin: projeto rodando com spring boot admin
servicea: client do spring boot admin que envia as metricas via actuator
serviceb: client do spring boot admin que envia as metricas via actuator


# Descrição
Esses projetos mostram o funcionamento do spring boot admin, que é uma ferramenta que proporciona um monitoramento e gestão automatica de aplicações spring via endpoints actuator.
Resumidamente o admin tem o painel do spring boot admin e os services expoem endpoints do actuator ao qual ele vai buscar as informacoes

# funcionalidades spring boot admin
- Monitoria: visibilidade healthcheck aplicacoes
- Informações: informações expostas sobre a aplicacao
- Seguranca: comunicacao autenticada
- Memoria e thead: informações sobre essas metricas
- Environment: visualizacao e alteracao de properties em tempo real 
- Beans
- Scheduled tasks: visualizacao schedulers existentes
- Nivel log: alteracao nivel log
- Visualizacao log
- Mappings: mapeamento endpoints existentes
- liquibase/flyway: visualizacao migracoes executadas
- caches: visualizacao e limpeza cache
- Metricas/micrometer: criacao de contadores de metricas, inclusive do micrometer
- Sessions: visualizacao e exclusao de sessoes