# Monitoring Stack

Stack de monitoramento com Prometheus e Grafana rodando no **Docker Swarm**.

## Estrutura

```
monitoring/
├── docker-swarm/      # Configurações modularizadas do Swarm
│   ├── prometheus.yml  # Serviço do Prometheus e cAdvisor
│   └── grafana.yml     # Serviço do Grafana
├── infra/
│   ├── prometheus/
│   │   ├── data/           # Dados persistentes do Prometheus (TSDB)
│   │   └── prometheus.yml  # Configuração do Prometheus
...
└── scripts/
    └── deploy-swarm.sh     # Script de deploy no Swarm
```

## Configuração Inicial

### 1. Iniciar Docker Swarm

Se o nó ainda não estiver em modo Swarm, inicialize-o:

```bash
docker swarm init
```

### 2. Permissões de Volumes

Certifique-se de que os diretórios de dados possuem as permissões corretas para os containers:

```bash
# Prometheus (UID 65534)
sudo chown -R 65534:65534 infra/prometheus/data

# Grafana (UID 472)
sudo chown -R 472:472 infra/grafana/data
```

## Deploy

### Iniciar Stack

```bash
bash scripts/deploy-swarm.sh
```

### Parar Stack

```bash
bash scripts/stop-swarm.sh
```

## Acessar Serviços

- **Prometheus**: http://localhost:9091
- **Grafana**: http://localhost:3000
  - Usuário: `admin`
  - Senha: `admin`

## Persistência de Dados

### Prometheus

- **Localização**: `infra/prometheus/data/`
- **Conteúdo**: Time Series Database (TSDB) com todas as métricas coletadas
- **Retenção**: 30 dias (configurável no `docker-stack.yml`)

### Grafana

- **Localização**: `infra/grafana/data/`
- **Conteúdo**: 
  - Dashboards customizados
  - Configurações de usuário
  - Preferências e alertas
  - SQLite database com metadados

## Dashboards

Os dashboards são provisionados automaticamente a partir de:
- `infra/grafana/dashboards/teste-performance/`

Dashboards disponíveis:
- **Docker Swarm - Performance**: Métricas de infraestutura
- **K6 - Performance**: Métricas de testes de carga
- **Traefik - Performance**: Métricas do gateway

## Troubleshooting

### Verificar Status dos Serviços

```bash
docker service ls
docker stack ps monitoring
```

### Visualizar Logs

```bash
# Logs do Prometheus
docker service logs -f monitoring_prometheus

# Logs do Grafana
docker service logs -f monitoring_grafana
```

### Problemas de Rede

O Grafana está configurado para acessar o Prometheus via nome de serviço interno do Swarm: `http://prometheus:9091`. Se o datasource falhar, verifique se ambos os serviços estão na mesma rede (`monitoring_network`).