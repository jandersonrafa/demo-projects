
# Deploy swarm

1. **Iniciar o Docker Swarm (se ainda não estiver ativo):**
   ```bash
   cd docker-swarm
   docker swarm init --advertise-addr 192.168.0.137
   ```

2. **Fazer o deploy das aplicações:**
   ```bash
   ./deploy-swarm.sh
   ```

3. **Remover aplicações:**
   ```bash
   ./cleanup-swarm.sh
   ```

## Comandos Úteis

```bash
# Verificar serviços
docker service ls

# Verificar logs de um serviço específico
docker service logs java-mvc-vt_gateway

# Escalar um serviço
docker service scale java-mvc-vt_gateway=3

# Atualizar um serviço
docker service update --image nova-imagem java-mvc-vt_gateway
```


# Deploy nomad


1. **Iniciar o Docker Swarm (se ainda não estiver ativo):**
   ```bash
   cd nomad
   
   consul agent -dev -config-file=./consul/consul.hcl

   nomad agent -dev -config=./nomad
   
   ```

2. **Fazer o deploy das aplicações:**
   ```bash
   ./deploy-nomad.sh
   ```

3. **Remover aplicações:**
   ```bash
   ./cleanup-nomad.sh
   ```


