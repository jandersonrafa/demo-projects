# Relatório de Benchmark: Limites de Performance por Stack (GCP)

## Escopo do Teste
O teste consiste em avaliar o comportamento das stacks em um cenário real de negócio através de dois endpoints principais:

1. **`POST /bonus` (Escrita/Processamento)**:
   - Valida se o cliente existe e está ativo no banco de dados.
   - Aplica uma regra de negócio: se o valor for > 100, aplica um bônus de 10%.
   - Registra o bônus com data de expiração (30 dias) e descrição formatada.
   - Persiste os dados no PostgreSQL.
2. **`GET /bonus/recents` (Leitura/Estresse de Memória)**:
   - Busca os últimos 100 registros do banco de dados.
   - **Ordenação em Memória**: A ordenação por data de criação é feita propositalmente na camada de aplicação (e não no banco) para estressar CPU e Memória.
   - Retorna apenas os 10 resultados mais recentes após o processamento.

---

## Resumo Executivo
Este documento detalha o teste de performance realizado em ambiente **Google Cloud Platform (GCP)** em diversas tecnologias (stacks) para identificar a **taxa máxima de requisições por segundo (RPS)** que cada uma suporta.

O diferencial deste teste foi observar o comportamento das stacks em um ambiente de nuvem pública, mantendo a estratégia de carga progressiva (ramping) até atingir o limite de estabilidade.

---

## Metodologia do Teste

### Infraestrutura e Hardware
As aplicações foram executadas no GCP (Google Cloud Platform) utilizando Docker Swarm para orquestração:
- **Instâncias:** 2 instâncias por stack.
- **Banco de dados:** PostgreSQL com pgbouncer.
- **SLA de Latência:** O teste buscou identificar o patamar máximo de RPS mantendo a estabilidade das respostas.

### Coleta de Métricas
As métricas foram coletadas e centralizadas em um servidor **Prometheus**:
1. **Cadvisor:** Métricas de consumo de recursos do container (CPU/Memória).
2. **Traefik:** Edge Router/Load Balancer fornecendo latência e throughput.

### Estratégia de Carga (k6)
O script de teste k6 utilizou o executor `ramping-arrival-rate`:
- **Aquecimento (Warm-up):** Escalonamento gradual da carga.
- **Threshold:** Monitoramento de `http_req_duration` (P95) e `http_req_failed`.
- **Abort automático:** O teste é interrompido se os thresholds de latência ou erro forem violados.

---

# Infraestrutura e Coleta
As aplicações rodaram no **Docker swarm** e os dados foram coletados via **Prometheus**, consolidando métricas do Docker e do **Traefik**.
Segue abaixo diagrama explicando a infraestrutura envolvida no teste:

![alt text](infra-benchmark.png)

- 1 - Execução do teste pelo K6 enviando chamadas.
- 2 - Aplicações atendendo as requisições via Traefik.
- 3 - Persistência no PostgreSQL.
- 4 - Coleta de métricas via Prometheus (Cadvisor e Traefik).
- 5 - Visualização em Dashboards Grafana.

---

## Resultados Obtidos (GCP)
A tabela abaixo lista o **RPS máximo** alcançado por cada stack no ambiente GCP:

| Posição | Stack                              | RPS Máximo |
|----------|-------------------------------------|------------|
| 1º        | Rust Axum                           | 2400       |
| 1º        | Java Quarkus                        | 2400       |
| 2º        | Java MVC (Virtual Threads)          | 2250       |
| 3º        | Golang                              | 1600       |
| 4º        | Node + NestJS + Fastify             | 1300       |
| 4º        | .NET                                | 1300       |
| 4º        | Java MVC (Sem Virtual Threads)      | 1300       |
| 5º        | Node + NestJS + Express             | 900        |
| 6º        | Java WebFlux                        | 800        |
| 7º        | Python FastAPI                      | 500        |
| 8º        | PHP + Laravel + Octane              | 400        |
| 9º        | PHP + Laravel + FPM                 | 100        |

---

## Materiais/Documentos
O código fonte das aplicações e teste escrito está disponível em https://github.com/crmbonus-oficial/benchmark-stacks/benchmark/benchmark-limites-gcp

- `load-all-limits-gcp.js`: script com cenário de teste k6 customizado para GCP.
- `graficos-grafana.md`: Links dos dashboards grafana com as métricas de performance obtidas.
- `reports`: Relatórios gerados pelo k6.

---

## Conclusões

- **Liderança Absoluta:** **Rust** e **Java Quarkus** mantiveram a liderança com 2400 RPS, demonstrando excelente escalabilidade no GCP.
  
- **Eficiência das Virtual Threads:** O **Java MVC (VT)** apresentou um salto significativo, chegando a 2250 RPS, tornando-se uma das stacks mais performáticas do teste.

- **Golang:** Apresentou excelente desempenho com 1600 RPS, consolidando-se no grupo de elite.

- **Grupo Intermediário:** **Node (Fastify)**, **.NET** e **Java MVC (sem VT)** empataram em 1300 RPS. Curiosamente, o Java MVC sem VT performou melhor no GCP do que no ambiente anterior, provavelmente devido a diferenças na alocação de recursos do ambiente.

- **Destaque Negativo:** O **Java WebFlux** (800 RPS) e o **Node (Express)** (900 RPS) ficaram abaixo das demais stacks compiladas ou otimizadas.

- **Linguagens Interpretadas:** **Python** (500 RPS) e **PHP Octane** (400 RPS) continuam na base da tabela em termos de throughput bruto, com o **PHP FPM** apresentando o menor rendimento (100 RPS) sob carga máxima.

**Resumo:** O ambiente GCP permitiu alcançar valores de RPS mais elevados de forma geral, mas a hierarquia de eficiência entre as tecnologias permaneceu consistente, com Rust e Quarkus no topo.
