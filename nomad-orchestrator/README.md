# Configurar ambiente
```bash
# Instalar nomad, consul e envoy
./nomad/scripts/install_dependencies.sh

```

# Nomad Orchestrator

Projeto para orquestração de serviços (Gateway e Monolith) utilizando HashiCorp Nomad, Consul e Traefik.

## 0. Buildar Imagens
Antes de rodar o Nomad, as imagens Docker devem estar disponíveis localmente:
```bash
docker build -t nomad/gateway:1.0 ./java-mvc-vt/gateway
docker build -t nomad/monolith:1.0 ./java-mvc-vt/monolith
```

## 1. Subir Infraestrutura (Consul & Nomad)
Em terminais separados, inicie os agentes em modo de desenvolvimento:

**Consul:**
```bash
consul agent -dev -config-file=./nomad/consul/consul.hcl
```

**Nomad:**
```bash
sudo nomad agent -dev -config=./nomad/nomad
```

## 2. Deploy das Aplicações
Utilize o script centralizado para realizar o deploy de toda a stack (Infraestrutura e Aplicação):
```bash
./nomad/scripts/deploy.sh
```

## 3. Limpeza
Para parar todos os jobs:
```bash
./nomad/scripts/cleanup.sh
```

## 4. Estrutura de Arquivos
- `nomad/jobs/infra/`: Job unificado `infra.nomad` (Postgres + Traefik).
- `nomad/jobs/apps/`: Job unificado `app.nomad` (Gateway + Monolith).
- `nomad/vars/common.hcl`: Variáveis de ambiente e versões de imagem.
- `nomad/scripts/`: Scripts de automação.

## 5. Testar Endpoint
O Gateway estará acessível via Traefik na porta `8081`.

**Cadastrar Bônus:**
```bash
curl -X POST http://localhost:8081/bonus \
  -H "Content-Type: application/json" \
  -d '{"clientId": "client_1", "amount": 200.00, "description": "Test Bonus"}'
```
