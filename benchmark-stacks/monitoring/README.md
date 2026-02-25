# Monitoring Stack

Stack de monitoramento com Prometheus e Grafana rodando no Nomad.

## Estrutura

```
monitoring/
├── infra/
│   ├── prometheus/
│   │   ├── data/           # Dados persistentes do Prometheus (TSDB)
│   │   └── prometheus.yml  # Configuração do Prometheus
│   └── grafana/
│       ├── data/           # Dados persistentes do Grafana
│       ├── dashboards/     # Dashboards do Grafana
│       └── provisioning/   # Configuração de datasources
├── nomad/
│   ├── jobs/infra/
│   │   ├── prometheus.nomad  # Job do Prometheus
│   │   └── grafana.nomad     # Job do Grafana
│   ├── vars/
│   │   └── common.hcl        # Variáveis comuns
│   └── client-volumes.hcl    # Configuração de volumes do Nomad
└── scripts/
    ├── deploy-nomad.sh       # Script de deploy
    └── stop-nomad.sh         # Script para parar jobs
```

## Configuração Inicial

### 1. Configurar Volumes no Nomad Client

Os volumes persistentes precisam ser registrados na configuração do Nomad. O arquivo `nomad.hcl` já inclui estas configurações:

```bash
sudo cp nomad/config/nomad.hcl /etc/nomad.d/nomad.hcl
sudo systemctl restart nomad
```

**Importante:** Ajuste os caminhos em `/etc/nomad.d/nomad.hcl` se necessário para refletir o caminho absoluto do seu projeto.

### 2. Verificar Volumes Registrados

```bash
nomad node status -self | grep -A 10 "Host Volumes"
```

Você deve ver:
```
Host Volumes
prometheus-data  /caminho/completo/monitoring/infra/prometheus/data
grafana-data     /caminho/completo/monitoring/infra/grafana/data
```

## Deploy

### Iniciar Stack

```bash
cd scripts
./deploy-nomad.sh
```

### Parar Stack

```bash
cd scripts
./stop-nomad.sh
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
- **Retenção**: 30 dias (configurável em `prometheus.nomad`)

### Grafana

- **Localização**: `infra/grafana/data/`
- **Conteúdo**: 
  - Dashboards customizados
  - Configurações de usuário
  - Preferências e alertas
  - SQLite database com metadados

### Verificar Persistência

Após reiniciar os jobs, verifique que os dados foram preservados:

```bash
# Verificar dados do Prometheus
ls -lh infra/prometheus/data/

# Verificar dados do Grafana
ls -lh infra/grafana/data/

# Testar query no Prometheus (deve retornar dados históricos)
curl -s "http://localhost:9091/api/v1/query?query=up" | jq '.data.result'
```

## Dashboards

Os dashboards são provisionados automaticamente a partir de:
- `infra/grafana/dashboards/teste-performance/`

Dashboards disponíveis:
- **General - Performance Overview**: Visão geral consolidada de performance
- **Nomad - Performance**: Métricas detalhadas do Nomad
- **K6 - Performance**: Métricas de testes de carga
- **Traefik - Performance**: Métricas do gateway

## Troubleshooting

### Volumes não encontrados

Se os jobs falharem com erro de volume não encontrado:

1. Verifique se o arquivo `client-volumes.hcl` está em `/etc/nomad.d/`
2. Reinicie o Nomad: `sudo systemctl restart nomad`
3. Verifique os volumes: `nomad node status -self`

### Permissões

Se houver erros de permissão nos logs:

```bash
# Prometheus roda como UID 65534
sudo chown -R 65534:65534 infra/prometheus/data

# Grafana roda como UID 472
sudo chown -R 472:472 infra/grafana/data
```

### Logs

```bash
# Ver logs do Prometheus
nomad alloc logs -job prometheus prometheus

# Ver logs do Grafana
nomad alloc logs -job grafana grafana
```