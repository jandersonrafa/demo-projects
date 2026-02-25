# Benchmark Report Formulas

Este documento descreve as métricas geradas pelo script `generate_benchmark.py` e as fórmulas/consultas Prometheus usadas para calculá-las. O relatório final `benchmark-gerado.md` contém três tabelas principais: métricas da infraestrutura (Swarm), métricas do K6 e métricas do Traefik.

---
## 1. Métricas do K6

Todas as consultas são avaliadas no instante do fim do teste (`prom_end_ts`) e cobrem os últimos `LOAD_SECONDS` (padrão 600s).

| Métrica              | Fórmula / Consulta PromQL                                                                                      | Cálculo adicional                              |
|----------------------|----------------------------------------------------------------------------------------------------------------|------------------------------------------------|
| Total requests       | `sum(increase(k6_http_reqs_total{scenario=~'load_.*{port}'}`
`[{LOAD_SECONDS}s]))`                                                           | resposta direta da consulta                   |
| Erros HTTP           | `sum(increase(k6_http_reqs_total{scenario=~'load_.*{port}', status=~'[45]..'}[{LOAD_SECONDS}s]))`               | erros 4xx + 5xx                                 |
| Iterações descartadas| `sum(increase(k6_dropped_iterations_total{scenario=~'load_.*{port}'}[{LOAD_SECONDS}s]))`                       | valor direto                                   |
| Erros totais         | `http_errors + dropped_iterations`                                                                             | soma simples                                   |
| Taxa de sucesso (%)  | `(k6_reqs - http_errors) / (k6_reqs + dropped_iterations) * 100`                                              | se denominador > 0                              |
| RPS médio            | `k6_reqs / LOAD_SECONDS`                                                                                       | solicitações por segundo                      |
| P95 médio (ms)       | `avg by (method) (last_over_time(k6_http_req_duration_p95{...}[{LOAD_SECONDS}s]))`
* `mean(vals) * 1000`  | primeiro faz `last_over_time` por método para recuperar o p95 final, depois `avg` entre métodos e converte para ms
| Latência média (ms)  | `avg by (method) (last_over_time(k6_http_req_duration_avg{...}[{LOAD_SECONDS}s]))`
* `mean(vals) * 1000`  | mesma lógica do p95, usando a métrica _avg

> **OBS**: `{port}` é substituído pelo número da porta do serviço em teste, e `scenario` filtra os resultados para o workload correspondente.

---
## 2. Métricas do Docker Swarm (infra)

As métricas de Swarm são todas derivadas de séries expostas pelo cAdvisor através do Prometheus.

| Métrica            | Consulta PromQL                                                                                                 | Descrição                                                                                     |
|--------------------|------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| Instâncias         | `count(container_last_seen{container_label_com_docker_swarm_service_name=~'{swarm_service}'}) by (container_label_com_docker_swarm_task_name)` | número de containers "vistos" no instante final                                       |
| CPU alocada (cores)| `sum(container_spec_cpu_quota{...} / container_spec_cpu_period{...})`                                           | quota/periodo = número de cores alocados                                                 |
| CPU avg (cores)    | `avg_over_time(sum by (...) (rate(container_cpu_usage_seconds_total{...}[{LOAD_SECONDS}s]))[{LOAD_SECONDS}s:])`   | média de uso de CPU durante a janela de carga                                           |
| CPU max (cores)    | `max_over_time(sum by (...) (rate(container_cpu_usage_seconds_total{...}[30s]))[{LOAD_SECONDS}s:])`               | valor máximo de uso de CPU no período                                                     |
| Memória alocada    | `sum(container_spec_memory_limit_bytes{...})`                                                                    | soma das limitações de memória em bytes                                                  |
| Memória avg (bytes)| `avg_over_time(sum(container_memory_working_set_bytes{...})[{LOAD_SECONDS}s:])`                                  | média de uso de memória no período                                                       |
| Memória max (bytes)| `max_over_time(sum(container_memory_working_set_bytes{...})[{LOAD_SECONDS}s:])`                                  | pico de uso de memória no período                                                        |

> **Filtro de task ativos**: para médias e máximos de CPU/memória são aplicados apenas `container_label_com_docker_swarm_task_id` que estiveram ativos (`container_last_seen>0`) durante o intervalo do teste. Esse conjunto é obtido por `get_active_task_ids()` e transforma‑se em um regex usado nas consultas como `{... ,container_label_com_docker_swarm_task_id=~"(id1|id2|...)")}`.

---
## 3. Métricas do Traefik

Somente para serviços que possuem o campo `traefik_service` no `STACK_MAP`. As consultas usam as métricas expostas pelo próprio Traefik.

| Métrica             | Consulta PromQL                                                                                             | Cálculo adicional                             |
|---------------------|--------------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| Total requests      | `sum(increase(traefik_service_requests_total{service=~'{t_service_regex}', code=~'[23]..'}[{LOAD_SECONDS}s]))` | solicitações com código 2xx ou 3xx           |
| Erros               | `sum(increase(traefik_service_requests_total{service=~'{t_service_regex}', code=~'[45]..'}[{LOAD_SECONDS}s]))` | códigos 4xx e 5xx                             |
| RPS médio           | `traefik_reqs / LOAD_SECONDS`                                                                               |                                               |
| P95 (ms)            | `histogram_quantile(0.95, sum(rate(traefik_service_request_duration_seconds_bucket{service=~'{t_service_regex}'}}[{LOAD_SECONDS}s])) by (le))` *1000 | quantil do histograma                      |
| Latência média (ms) | `(sum(rate(traefik_service_request_duration_seconds_sum{service=~'{t_service_regex}'}}[{LOAD_SECONDS}s])) / sum(rate(traefik_service_request_duration_seconds_count{service=~'{t_service_regex}'}}[{LOAD_SECONDS}s]))` *1000 | divisão do somatório pela contagem média |
| Taxa de sucesso (%) | `traefik_reqs / (traefik_reqs + traefik_errors) * 100`                                                     |                                               |

> O regex `{t_service_regex}` é construído a partir do nome do serviço, permitindo captura de variantes geradas pelo Traefik (ex.: `mvc-vt-monolith.*`).

---
## Legenda e conversões finais

* Valores de CPU são apresentados em **cores**.
* Memória alocada, média e máxima são convertidas de bytes para **MiB** na saída final (`/ (1024*1024)`).
* Latências obtidas em segundos multiplicadas por 1000 para exibição em **milissegundos**.
* Os percentuais (`k6_success_rate` e `traefik_success_pct`) são calculados com ponto flutuante e formatados com vírgula decimal.

Este documento serve como referência para entender de onde cada número do relatório foi originado e como ele é calculado pelo script.