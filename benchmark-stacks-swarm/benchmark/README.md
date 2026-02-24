# Benchmarks

Esta pasta contém os resultados e relatórios dos testes de performance realizados nas diferentes stacks tecnológicas do projeto.

Abaixo estão os detalhes sobre a organização desta pasta:

- **[script](/demo-projects/benchmark-stacks/benchmark/script)**: Contém utilitários para automação e análise de resultados.
- **[generate_benchmark.py](/demo-projects/benchmark-stacks/benchmark/script/generate_benchmark.py)**: Script Python generico que a partir de relatórios k6 gerados efetua a consulta de métricas do Prometheus (Docker Swarm, Traefik, K6) e consolida em um relatório md.
- **[metricas-benchmark.md](/demo-projects/benchmark-stacks/benchmark/script/metricas-benchmark.md)**: Documentação técnica com as fórmulas, queries PromQL e lógica de cálculo de cada métrica.

## Gerar relatório

```bash
REPORTS_ROOT_DIR=../benchmark-1000rps/reports/second-execution-used python3 generate_benchmark.py
```


## Tipos de Testes

Os benchmarks estão divididos em quatro grandes grupos:


- **[benchmark-1000rps](/demo-projects/benchmark-stacks/benchmark/benchmark-1000rps)**: **Eficiência de Hardware.**
  - **Objetivo**: Identificar o hardware mínimo necessário (CPU e Memória) para sustentar uma carga fixa de **1000 RPS** com P95 < 200ms.
  - **Foco**: Comparar a economia de recursos entre as linguagens sob a mesma carga de trabalho.

- **[benchmark-limites](/demo-projects/benchmark-stacks/benchmark/benchmark-limites)**: **Limite de Performance (Throughput).**
  - **Objetivo**: Encontrar o RPS máximo (o "teto") que cada stack suporta utilizando um hardware padronizado de **1 Core e 1 GB RAM com velocidade de 4,3Ghz**.
  - **Foco**: Descobrir qual tecnologia entrega mais performance bruta com recursos limitados.

---
Para mais detalhes sobre a infraestrutura e a metodologia, consulte os relatórios dentro de cada pasta.
