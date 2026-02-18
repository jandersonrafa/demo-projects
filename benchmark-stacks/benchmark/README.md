# Benchmarks

Esta pasta contém os resultados e relatórios dos testes de performance realizados nas diferentes stacks tecnológicas do projeto.

Abaixo estão os detalhes sobre a organização desta pasta:

- **[script](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/benchmark/script)**: Contém utilitários para automação e análise de resultados.
  - **[generate_benchmark.py](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/benchmark/script/generate_benchmark.py)**: Script Python que consolida métricas do Prometheus (Nomad, Traefik, K6) em relatórios unificados.
  - **[metricas-benchmark.md](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/benchmark/script/metricas-benchmark.md)**: Documentação técnica com as fórmulas, queries PromQL e lógica de cálculo de cada métrica.

## Tipos de Testes

Os benchmarks estão divididos em dois grandes grupos:

- **[benchmark-150rps](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/benchmark/benchmark-150rps)**: **Eficiência de Hardware.**
  - **Objetivo**: Identificar o hardware mínimo necessário (CPU e Memória) para sustentar uma carga fixa de **150 RPS** com P95 < 200ms.
  - **Foco**: Comparar a economia de recursos entre as linguagens sob a mesma carga de trabalho.

- **[benchmark-limites](file:///home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/benchmark/benchmark-limites)**: **Limite de Performance (Throughput).**
  - **Objetivo**: Encontrar o RPS máximo (o "teto") que cada stack suporta utilizando um hardware padronizado de **1 Core e 1 GB RAM**.
  - **Foco**: Descobrir qual tecnologia entrega mais performance bruta com recursos limitados.

---
Para mais detalhes sobre a infraestrutura e a metodologia, consulte os relatórios dentro de cada pasta.
