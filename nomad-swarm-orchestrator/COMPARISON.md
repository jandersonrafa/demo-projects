# Java MVC VT - Docker Swarm vs Nomad Comparison

Este projeto demonstra a mesma aplicação rodando em dois orquestradores diferentes para comparação.

## 📁 Estrutura do Projeto

```
java-mvc-vt/
├── docker-swarm/              # Docker Swarm configuration
│   ├── docker-compose.yml    # Docker Swarm compose file
│   ├── deploy.sh             # Docker Swarm deploy script
│   ├── cleanup.sh            # Docker Swarm cleanup script
│   └── README.md             # Docker Swarm documentation
├── nomad/                     # Nomad configuration
│   ├── java-mvc-vt.nomad    # Nomad job configuration
│   ├── deploy-nomad.sh      # Nomad deploy script
│   ├── cleanup-nomad.sh     # Nomad cleanup script
│   └── README.md            # Nomad documentation
├── gateway/                   # Gateway Spring Boot app
├── monolith/                  # Monolith Spring Boot app
└── COMPARISON.md             # Comparison documentation
```

## 🚀 Como Usar

### Docker Swarm
```bash
cd docker-swarm

# Iniciar Swarm
docker swarm init --advertise-addr <IP>

# Deploy
./deploy.sh

# Acessar
curl http://localhost:8080/actuator/health
```

### Nomad
```bash
cd nomad

# Iniciar Nomad (dev mode)
nomad agent -dev

# Deploy
./deploy-nomad.sh

# Acessar
curl http://localhost:8080/actuator/health
```

## 📊 Comparação Rápida

| Característica | Docker Swarm | Nomad |
|---|---|---|
| **Curva de Aprendizado** | Baixa | Média |
| **Configuração** | YAML (docker-compose) | HCL (.nomad) |
| **Service Discovery** | DNS interno | Consul |
| **Escalabilidade** | Simples | Flexível |
| **Multi-Cloud** | Limitado | Excelente |
| **Integração** | Docker Nativo | Multi-plataforma |
| **Monitoring** | Integrado | Prometheus/Grafana |

## 🎯 Cenário Testado

- **Gateway**: 2 réplicas (porta 8080)
- **Monolith**: 2 réplicas (porta 3000)
- **PostgreSQL**: 1 réplica (porta 5432)
- **Load Balancing**: Automático em ambos
- **Health Checks**: Configurados em ambos
- **Service Discovery**: DNS vs Consul

## 📈 Teste de Carga

Ambos suportam o mesmo teste:
```bash
# Criar bonus
curl -X POST http://localhost:8080/bonus \
  -H "Content-Type: application/json" \
  -d '{"clientId": "client_1", "amount": 200.00, "description": "Test Bonus"}'

# Consultar bonus
curl -X GET http://localhost:8080/bonus/1
```

## 🔧 Monitoramento

### Docker Swarm
```bash
docker service ls
docker service logs java-mvc-vt_gateway
docker service ps java-mvc-vt_monolith
```

### Nomad
```bash
nomad job status java-mvc-vt
nomad alloc status
nomad alloc logs <alloc-id>
```

## 📝 Conclusão

- **Docker Swarm**: Mais simples para ambientes Docker puros
- **Nomad**: Mais flexível para ambientes heterogêneos e multi-cloud

Ambos orquestram eficientemente as mesmas aplicações com características similares!
