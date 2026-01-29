
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

4. **Endpoint cadastra bonus**
   ```bash
 curl -X POST http://localhost:8080/bonus \
  -H "Content-Type: application/json" \
  -d '{"clientId": "client_1", "amount": 200.00, "description": "Test Bonus"}'
{"id":1,"amount":220.0,"description":"JAVAMVCVT - Test Bonus","clientId":"client_1","expirationDate":"2026-02-28T19:03:59.997514432","createdAt":"2026-01-29T19:03:59.997490464"}% 

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