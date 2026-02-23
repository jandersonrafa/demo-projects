# Benchmark Stacks

Este projeto visa comparar o desempenho de diferentes stacks tecnológicas (como Java, Node.js, Rust, Go, C++, etc.) em cenários de alta carga, utilizando o Docker swarm como orquestrador e Prometheus/Grafana para monitoramento.


## Usar portainer para monitorar docker swarm local

```bash
docker volume create portainer_data

docker service create \
  --name portainer \
  --publish 7000:9000 \
  --constraint 'node.role==manager' \
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  --mount type=volume,src=portainer_data,dst=/data \
  portainer/portainer-ce:latest

acessar http://<ip_maquina>:7000 // Não funciona localhost
```

## Estrutura do Projeto

Abaixo estão as descrições sucintas de cada pasta na raiz do projeto:

- **[benchmark](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/benchmark)**: Contém relatórios detalhados, resultados de testes de limites (RPS máximo, latência P95) e scripts em Python para processamento e consolidação de métricas.
- **[executor-k6](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/executor-k6)**: Contém os scripts de teste de carga escritos em Javascript para o K6, além da lógica de execução automatizada dos benchmarks.
- **[monitoring](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/monitoring)**: Configurações de infraestrutura e jobs Docker Swarm para a stack de observabilidade, incluindo Prometheus, Grafana e Traefik.
- **[stacks](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/stacks)**: Código-fonte das aplicações em diversas linguagens e frameworks, incluindo seus respectivos Dockerfiles e arquivos de configuração para deploy no Docker Swarm.


<!-- 
https://aws.amazon.com/pt/blogs/aws/new-t3-instances-burstable-cost-effective-performance/
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances-unlimited-mode.html?icmpid=docs_ec2_console -->