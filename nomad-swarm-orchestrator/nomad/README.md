# Java MVC VT - Nomad Deployment

Este projeto contém duas aplicações Spring Boot (Gateway e Monolith) configuradas para rodar em Nomad com 2 réplicas cada.

## Arquitetura

- **Gateway**: Aplicação Spring Boot na porta 3000 (exposta na porta 8080)
- **Monolith**: Aplicação Spring Boot na porta 3000 (interna)
- **PostgreSQL**: Banco de dados na porta 5432

## Pré-requisitos

- Docker e Nomad instalados
- Nomad agent ativo (dev mode ou cluster)
- Consul para service discovery (integrado com Nomad)

## Deploy

1. **Iniciar o Nomad (se ainda não estiver ativo):**
   ```bash
   nomad agent -dev
   ```

2. **Fazer o deploy das aplicações:**
   ```bash
   cd nomad
   ./deploy-nomad.sh
   ```

3. **Verificar o status dos jobs:**
   ```bash
   nomad job status java-mvc-vt
   nomad job status java-mvc-vt -verbose
   ```

## Acesso

- **Gateway**: http://localhost:8080
- **Health Check Gateway**: http://localhost:8080/actuator/health
- **Prometheus Metrics**: http://localhost:8080/actuator/prometheus

## Configuração

- **Réplicas**: Gateway (2), Monolith (2), PostgreSQL (1)
- **Service Discovery**: Consul para comunicação entre serviços
- **Load Balancing**: Nomad distribui as requisições entre as réplicas
- **Health Checks**: Verificação automática de saúde dos serviços

## Limpeza

Para remover todos os serviços:
```bash
./cleanup-nomad.sh
```

## Comandos Úteis

```bash
# Verificar status do job
nomad job status java-mvc-vt

# Verificar allocations
nomad alloc status

# Verificar logs de uma allocation específica
nomad alloc logs <alloc-id>

# Verificar serviços no Consul
curl http://localhost:8500/v1/catalog/services

# Escalar um serviço (editar count no arquivo .nomad)
nomad job run java-mvc-vt.nomad
```

## Comparação com Docker Swarm

| Característica | Docker Swarm | Nomad |
|---|---|---|
| **Orquestração** | Simples, integrado ao Docker | Flexível, multi-cloud |
| **Service Discovery** | DNS interno | Consul integrado |
| **Configuração** | docker-compose.yml | Arquivos .nomad (HCL) |
| **Escalabilidade** | docker service scale | count no job file |
| **Health Checks** | Integrado | Configurável por task |
| **Storage** | Volumes Docker | Volumes, host paths, etc |
