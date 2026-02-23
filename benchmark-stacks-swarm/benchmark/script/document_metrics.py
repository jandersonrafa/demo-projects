#!/usr/bin/env python3
"""
Gera um arquivo Markdown documentando de onde vêm e como são calculadas
todas as métricas presentes no relatório `benchmark-gerado.md` gerado
pelo script `generate_benchmark.py`.
"""

from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
OUTPUT_FILE = BASE_DIR / "metricas-benchmark.md"


def main() -> None:
    content = """# Métricas do arquivo benchmark-gerado.md

Este documento descreve como cada coluna do relatório `benchmark-gerado.md`
é obtida a partir das métricas expostas no Prometheus (Docker Swarm/cAdvisor, K6 e Traefik)
e de informações presentes nos relatórios JSON do K6.

> Janela de análise: últimos 10 minutos (600s) antes do horário final do teste,
> extraído do nome do arquivo `summary-YYYY-MM-DD_HH-MM-SS-BR-PORT.json`.

---

## 1. Colunas gerais

- **Date**  
  **O que é**: data do término do teste.  
  **Origem**: extraída do nome do arquivo de relatório do K6
  (`summary-YYYY-MM-DD_HH-MM-SS-BR-PORT.json`), convertido para `DD/MM/YYYY`.

- **Start Time / End Time**  
  **O que é**: horários de início e fim da janela de 10 minutos usada nas consultas
  ao Prometheus.  
  **Origem**:
  - `End Time`: timestamp final do teste, extraído do nome do arquivo do K6.
  - `Start Time`: `End Time - 600s`.

- **Stack**  
  **O que é**: nome amigável da stack (ex.: `Rust Axum`, `Golang Gin`, etc).  
  **Origem**: obtido a partir do mapeamento estático `STACK_MAP` no
  `generate_benchmark.py`, que associa a porta (`PORT` do nome do arquivo) ao
  nome da stack.

---

## 2. Tabela \"Swarm Metrics - Infraestrutura\"

Todas as métricas desta tabela usam o nome do serviço Swarm construído como
`stacks_<traefik_service>` (por exemplo, `stacks_python-monolith`).

### 2.1 Swarm Inst

- **O que é**: quantidade de containers (tasks) ativos para o serviço Swarm no
  instante final da janela.  
- **Métrica Prometheus**: `container_last_seen`.  
- **Query (conceito)**:

```promql
count(
  container_last_seen{
    container_label_com_docker_swarm_service_name=~"stacks_<service>"
  }
) by (container_label_com_docker_swarm_task_name)
```

- **Cálculo**: o script conta o número de séries retornadas por essa query.

### 2.2 Total - CPU Alloc

- **O que é**: total de CPU *alocada* (limite configurado) em *cores* para o serviço.  
- **Métricas**: `container_spec_cpu_quota`, `container_spec_cpu_period`.  
- **Query (conceito)**:

```promql
sum(
  container_spec_cpu_quota{
    container_label_com_docker_swarm_service_name=~"stacks_<service>"
  }
  /
  container_spec_cpu_period{
    container_label_com_docker_swarm_service_name=~"stacks_<service>"
  }
)
```

- **Cálculo**: o resultado já está em número de cores.

### 2.3 Total - CPU Avg

- **O que é**: uso médio de CPU em *cores* ao longo da janela de 600s,
  somando todos os containers do serviço.  
- **Métrica**: `container_cpu_usage_seconds_total`.  
- **Query (conceito)**:

```promql
avg_over_time(
  sum by (container_label_com_docker_swarm_service_name) (
    rate(
      container_cpu_usage_seconds_total{
        container_label_com_docker_swarm_service_name=~"stacks_<service>",
        container_label_com_docker_swarm_task_id=~"(task_ids_ativos)"
      }[600s]
    )
  )[600s:]
)
```

- **Cálculo**:
  1. `rate(...[600s])` transforma o contador em uso de CPU por segundo (cores).
  2. `sum by service` soma todos os containers.
  3. `avg_over_time(...[600s:])` tira a média desse valor no período.

### 2.4 Total - CPU Max

- **O que é**: pico de uso de CPU em *cores* observado na janela de 600s.  
- **Métrica**: `container_cpu_usage_seconds_total`.  
- **Query (conceito)**:

```promql
max_over_time(
  sum by (container_label_com_docker_swarm_service_name) (
    rate(
      container_cpu_usage_seconds_total{
        container_label_com_docker_swarm_service_name=~"stacks_<service>"
      }[30s]
    )
  )[600s:]
)
```

### 2.5 Total - Mem Alloc (MiB)

- **O que é**: soma dos limites de memória (em MiB) de todos os containers
  do serviço.  
- **Métrica**: `container_spec_memory_limit_bytes`.  
- **Query (conceito)**:

```promql
sum(
  container_spec_memory_limit_bytes{
    container_label_com_docker_swarm_service_name=~"stacks_<service>"
  }
)
```

- **Cálculo**: o script converte de bytes para MiB (`/ 1024 / 1024`).

### 2.6 Total - Mem Avg (MiB)

- **O que é**: uso médio de memória em MiB, ao longo da janela, somando apenas
  os containers considerados ativos.  
- **Métrica**: `container_memory_working_set_bytes`.  
- **Query (conceito)**:

```promql
avg_over_time(
  sum(
    container_memory_working_set_bytes{
      container_label_com_docker_swarm_service_name=~"stacks_<service>",
      container_label_com_docker_swarm_task_id=~"(task_ids_ativos)"
    }
  )[600s:]
)
```

- **Cálculo**: resultado em bytes, convertido para MiB.

### 2.7 Total - Mem Max (MiB)

- **O que é**: maior valor de memória observada (MiB) na janela.  
- **Métrica**: `container_memory_working_set_bytes`.  
- **Query (conceito)**:

```promql
max_over_time(
  sum(
    container_memory_working_set_bytes{
      container_label_com_docker_swarm_service_name=~"stacks_<service>"
    }
  )[600s:]
)
```

- **Cálculo**: bytes convertidos para MiB.

---

## 3. Tabela \"K6 Metrics\"

As métricas K6 são obtidas via Prometheus, usando as séries que começam com
`k6_...` e filtrando pelo scenario que contém a porta da stack:
`scenario=~"load_.*<PORT>"`.

### 3.1 K6 Reqs

- **O que é**: total de requisições HTTP durante a fase de carga (600s).  
- **Métrica**: `k6_http_reqs_total`.  
- **Query (conceito)**:

```promql
sum(
  increase(
    k6_http_reqs_total{
      scenario=~"load_.*<PORT>"
    }[600s]
  )
)
```

### 3.2 K6 Erros

- **O que é**: total de falhas durante o teste (erros HTTP + iterações descartadas).  
- **Métricas**:
  - `k6_http_reqs_total{status=~"[45].."}` → erros 4xx/5xx.
  - `k6_dropped_iterations_total` → iterações descartadas.  
- **Queries (conceito)**:

```promql
HTTP_errors = sum(
  increase(
    k6_http_reqs_total{
      scenario=~"load_.*<PORT>", status=~"[45].."
    }[600s]
  )
)

Dropped = sum(
  increase(
    k6_dropped_iterations_total{
      scenario=~"load_.*<PORT>"
    }[600s]
  )
)
```

- **Cálculo**: `K6 Erros = HTTP_errors + Dropped`.

### 3.3 K6 RPS Avg

- **O que é**: média de requisições por segundo durante a fase de carga.  
- **Cálculo**:

```text
K6 RPS Avg = K6 Reqs / 600
```

### 3.4 K6 P95 (ms)

- **O que é**: latência P95 média (em milissegundos), agregando métodos HTTP
  (GET/POST).  
- **Métrica**: `k6_http_req_duration_p95`.  
- **Query (conceito)**:

```promql
avg by (method) (
  last_over_time(
    k6_http_req_duration_p95{
      scenario=~"load_.*<PORT>"
    }[600s]
  )
)
```

- **Cálculo**:
  1. Coleta o último P95 de cada método na janela.
  2. Tira a média entre os métodos.
  3. Converte de segundos para milissegundos (× 1000).

### 3.5 K6 Avg (ms)

- **O que é**: latência média (em milissegundos) das requisições HTTP.  
- **Métrica**: `k6_http_req_duration_avg`.  
- **Query (conceito)**: igual ao P95, mas com `k6_http_req_duration_avg`.  
- **Cálculo**: média entre métodos e conversão de segundos para milissegundos.

### 3.6 Success %

- **O que é**: percentual de requisições bem-sucedidas (sem erro HTTP e sem
  iteração descartada).  
- **Cálculo**:

```text
Total tentativas = K6 Reqs + Dropped
Sucesso = K6 Reqs - HTTP_errors
Success % = (Sucesso / Total tentativas) * 100
```

### 3.7 Threshold

- **O que é**: indicador visual de cumprimento do critério de sucesso mínimo.  
- **Regra**:
  - `✅` se `Success % >= 95`.
  - `❌` caso contrário.

---

## 4. Tabela \"Traefik Metrics\"

As métricas Traefik usam o rótulo `service` com regex no nome do serviço:
`service=~"<traefik_service>.*"`.

### 4.1 Traefik Reqs

- **O que é**: total de requisições 2xx e 3xx vistas pelo Traefik na janela.  
- **Métrica**: `traefik_service_requests_total`.  
- **Query (conceito)**:

```promql
sum(
  increase(
    traefik_service_requests_total{
      service=~"<svc>.*",
      code=~"[23].."
    }[600s]
  )
)
```

### 4.2 Traefik Erros

- **O que é**: total de requisições 4xx e 5xx vistas pelo Traefik.  
- **Métrica**: `traefik_service_requests_total`.  
- **Query (conceito)**:

```promql
sum(
  increase(
    traefik_service_requests_total{
      service=~"<svc>.*",
      code=~"[45].."
    }[600s]
  )
)
```

### 4.3 Traefik RPS Avg

- **O que é**: média de requisições por segundo do ponto de vista do Traefik.  
- **Cálculo**:

```text
Traefik RPS Avg = Traefik Reqs / 600
```

### 4.4 Traefik P95 (ms)

- **O que é**: latência P95 medida pelo Traefik (ms).  
- **Métricas**: histograma `traefik_service_request_duration_seconds_bucket`.  
- **Query (conceito)**:

```promql
histogram_quantile(
  0.95,
  sum(
    rate(
      traefik_service_request_duration_seconds_bucket{
        service=~"<svc>.*"
      }[600s]
    )
  ) by (le)
) * 1000
```

### 4.5 Traefik Avg (ms)

- **O que é**: latência média (ms) de resposta no Traefik.  
- **Métricas**:
  - `traefik_service_request_duration_seconds_sum`
  - `traefik_service_request_duration_seconds_count`  
- **Query (conceito)**:

```promql
(
  sum(
    rate(
      traefik_service_request_duration_seconds_sum{
        service=~"<svc>.*"
      }[600s]
    )
  )
  /
  sum(
    rate(
      traefik_service_request_duration_seconds_count{
        service=~"<svc>.*"
      }[600s]
    )
  )
) * 1000
```

### 4.6 Success %

- **O que é**: percentual de requisições bem-sucedidas (2xx/3xx) para o Traefik.  
- **Cálculo**:

```text
Total = Traefik Reqs + Traefik Erros
Success % = (Traefik Reqs / Total) * 100
```

### 4.7 Threshold

- **O que é**: indicador visual baseado no `Success %` do Traefik.  
- **Regra**:
  - `✅` se `Success % >= 95`.
  - `❌` caso contrário.

---

Este documento deve ser usado como referência técnica para interpretar os
resultados do arquivo `benchmark-gerado.md` e para auditar as fórmulas
usadas pelo script `generate_benchmark.py`.
"""

    OUTPUT_FILE.write_text(content, encoding="utf-8")
    print(f"Arquivo de documentação gerado em: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()

