# 📈 Metodologia (Prometheus): PromQLs e Cálculos do `query_prometheus_metrics.py`

Este documento descreve **exclusivamente** como o script `query_prometheus_metrics.py` consulta o **Prometheus** e calcula métricas por stack (CPU/Memória/RPS Prometheus).  
Ele **não depende** de nenhum arquivo pronto de summary do K6 e **não explica métricas do K6**.

---

## 🎯 O que o script realmente gera a partir do Prometheus

O `query_prometheus_metrics.py` gera (por stack):

- **CPU Avg (cores)** e **CPU P95 (cores)**
- **Mem Avg (MB)** e **Mem P95 (MB)**
- **RPS (Prometheus) Avg/P95** (campo `rps_prometheus` no `prometheus_metrics_results.json`)

Esses valores são salvos em `prometheus_metrics_results.json`.

---

## ⚠️ Colunas da tabela do relatório que NÃO vêm do Prometheus (nesse fluxo)

As colunas abaixo **não são calculadas** pelo `query_prometheus_metrics.py` e **não têm PromQL associada** neste repositório:

- **K6 Reqs Sucesso**
- **K6 Reqs Erro**
- **RPS Médio** (do teste)
- **VUs Máx**
- **P95 (ms)** (latência HTTP)
- **Tempo Médio (ms)** (latência HTTP)
- **Taxa Sucesso** ✅ **(calculada via K6)**
- **Threshold**

Motivo: essas são métricas típicas de **ferramenta de load test (K6)**. O script Prometheus aqui só coleta **recursos do container** e (opcionalmente) um contador de requests do gateway se existir (`http_requests_total`).

---

## 📊 Como é Calculada a Taxa de Sucesso

A **Taxa Sucesso** é calculada a partir dos relatórios do K6, **não do Prometheus**:

### 📈 Fórmula:
Taxa Sucesso (%) = (K6 Reqs Sucesso / (K6 Reqs Sucesso + K6 Reqs Erro)) × 100


### 📋 Fonte dos Dados:
- **K6 Reqs Sucesso**: Métrica `http_reqs.count` do relatório K6. Representa o total de requisições enviadas e que obtiveram resposta (independente se 200 ou 500).
- **K6 Reqs Erro**: Métrica `dropped_iterations.count` do relatório K6. Representa requisições descartadas pelo K6 antes do envio devido à saturação de VUs ou timeout interno do gerador de carga.


### 🎯 O que representa:
- **Taxa de processamento**: Capacidade do sistema de aceitar e processar requisições
- **Resiliência de carga**: Percentual de requisições que não foram descartadas por saturação

### ⚠️ Importante:
Esta métrica **mudou** em relação a versões anteriores. Agora ela representa a **capacidade de processamento** (Throughput Capacity) e ignora erros de aplicação (HTTP 500), focando em quantas requisições o servidor conseguiu responder vs quantas foram descartadas.

---

## � O que significa "Threshold" (Critérios de Aprovação)

A coluna **Threshold** indica se a stack passou nos critérios de qualidade definidos para o teste de carga no K6.

### ✅ Critérios para Aprovação:
1.  **P95 de Latência < 1000ms**: 95% das requisições devem ser respondidas em menos de 1 segundo.
2.  **Taxa de Erro < 1%**: Menos de 1% das requisições podem falhar (exceto dropped iterations, que são contabilizadas separadamente na capacidade).

### ❌ Estados:
- ✅ **Passou**: Atendeu a todos os critérios.
- ❌ **Falhou**: Violou um ou mais critérios (geralmente latência altíssima ou saturação completa).

---

## �🕒 Janela de tempo por stack (como o script escolhe o intervalo)

- **start_ts**: timestamp ISO definido em `TEST_WINDOWS[stack].start`
- **end_ts**: `start_ts + 1620`
- **step**: `"15s"` (amostragem a cada 15 segundos)

Trechos relevantes:

```15:66:benchmark-executor-k6-grafana/query_prometheus_metrics.py
TEST_WINDOWS = {
    "node": {
        "start": "2026-01-13T17:01:33-03:00",  # 6m30s antes do fim
        "port": 3005,
        "stack": "node",
        "name": "Node.js (NestJS)"
    },
    // ... demais stacks ...
}
```

```107:127:benchmark-executor-k6-grafana/query_prometheus_metrics.py
def get_container_metrics(stack_key, test_info):
    start_ts = parse_timestamp(test_info["start"])
    end_ts = start_ts + 420
    stack_label = test_info["stack"]
    results = {
        "stack": test_info["name"],
        "stack_label": stack_label,
        "port": test_info["port"],
        "start_time": test_info["start"],
        "duration_seconds": 1620
    }
```

---

## 📅 Janelas de Tempo Específicas por Stack (7 Minutos)

| Stack | Início (UTC-3) | Fim (UTC-3) | Duração |
|-------|----------------|-------------|---------|
| **Node.js** | `2026-01-13T17:01:33` | `2026-01-13T17:08:33` | 7 min |
| **Java WebFlux** | `2026-01-13T17:08:54` | `2026-01-13T17:15:54` | 7 min |
| **Java MVC VT** | `2026-01-13T17:17:24` | `2026-01-13T17:24:24` | 7 min |
| **Python** | `2026-01-13T17:25:19` | `2026-01-13T17:32:19` | 7 min |
| **PHP CLI** | `2026-01-13T17:34:40` | `2026-01-13T17:41:40` | 7 min |
| **PHP FPM** | `2026-01-13T17:43:31` | `2026-01-13T17:50:31` | 7 min |
| **PHP Octane** | `2026-01-13T17:54:57` | `2026-01-13T18:01:57` | 7 min |
| **Java MVC** | `2026-01-13T18:03:05` | `2026-01-13T18:10:05` | 7 min |

**Observação**: Os timestamps de início foram ajustados para **6 minutos e 30 segundos antes** do fim original de cada teste, garantindo captura completa da janela de teste incluindo aquecimento e cooldown.

---

## 🧠 Como o script calcula **Avg** e **P95**

Depois de consultar o Prometheus (query_range), o script:

- coleta todos os pontos retornados (todas as séries + todos os timestamps),
- transforma em `float`,
- calcula estatísticas com `calculate_stats(values)`.

```91:105:benchmark-executor-k6-grafana/query_prometheus_metrics.py
def calculate_stats(values):
    """Calculate min, max, avg, p95 from list of values"""
    if not values:
        return {"min": 0, "max": 0, "avg": 0, "p95": 0}
    sorted_values = sorted(values)
    n = len(sorted_values)
    p95_idx = int(n * 0.95)
    return {
        "min": min(values),
        "max": max(values),
        "avg": sum(values) / len(values),
        "p95": sorted_values[p95_idx] if p95_idx < n else sorted_values[-1]
    }
```

### Observações importantes do cálculo

- **P95 no script não é `histogram_quantile()`**: é um percentil “simples” calculado em Python sobre as amostras retornadas.
- Se a query retornar múltiplas séries (ex.: mais de um container que bate no regex), o script **mistura todas as séries** em uma lista só.

---

## 📌 PromQLs usadas (exatamente como no script)

### 1) CPU (cores)

**PromQL** (exatamente):

```promql
rate(container_cpu_usage_seconds_total{name=~".*{stack_label}.*gateway.*"}[1m])
```

**Onde aparece no código**:

```129:133:benchmark-executor-k6-grafana/query_prometheus_metrics.py
cpu_query = f'rate(container_cpu_usage_seconds_total{{name=~".*{stack_label}.*gateway.*"}}[1m])'
cpu_data = query_prometheus(cpu_query, start_ts, end_ts)
```

**Unidade/Interpretação**:
- `container_cpu_usage_seconds_total` é um contador de *segundos de CPU consumidos*.
- `rate(...[1m])` converte em “segundos de CPU por segundo” ≈ **cores** (ex.: `0.5` ≈ 50% de 1 core).

**Como vira as colunas do relatório**:
- **CPU Avg (cores)** = `avg` calculado em Python sobre os valores retornados pela query_range.
- **CPU P95 (cores)** = `p95` calculado em Python sobre os mesmos valores.

### 2) Memória (MB)

**PromQL** (exatamente):

```promql
container_memory_usage_bytes{name=~".*{stack_label}.*gateway.*"}
```

**Onde aparece no código**:

```152:157:benchmark-executor-k6-grafana/query_prometheus_metrics.py
mem_query = f'container_memory_usage_bytes{{name=~".*{stack_label}.*gateway.*"}}'
mem_data = query_prometheus(mem_query, start_ts, end_ts)
```

**Conversão bytes → MB** (no Python):

```159:164:benchmark-executor-k6-grafana/query_prometheus_metrics.py
for result in mem_data["data"]["result"]:
    for value in result["values"]:
        mem_values.append(float(value[1]) / (1024 * 1024))
```

**Como vira as colunas do relatório**:
- **Mem Avg (MB)** = `avg` (Python) após conversão para MB.
- **Mem P95 (MB)** = `p95` (Python) após conversão para MB.

### 3) RPS no Prometheus (opcional no relatório)

O script também tenta coletar RPS via uma métrica customizada `http_requests_total`:

**PromQL** (exatamente):

```promql
rate(http_requests_total{stack="{stack_label}", component="gateway"}[1m])
```

**Onde aparece no código**:

```176:180:benchmark-executor-k6-grafana/query_prometheus_metrics.py
rps_query = f'rate(http_requests_total{{stack="{stack_label}", component="gateway"}}[1m])'
rps_data = query_prometheus(rps_query, start_ts, end_ts)
```

**Observação**:
- Para várias stacks no arquivo `prometheus_metrics_results.json`, o `rps_prometheus` ficou `0`, indicando que **essa métrica não existia** ou **não tinha labels compatíveis** no Prometheus durante a janela.
- Essa coleta **não substitui** o “RPS Médio” do K6; é um RPS do lado do gateway (se instrumentado).

---

## 🧩 Substituição do `{stack_label}` por stack (mapeamento real)

O `{stack_label}` vem do campo `TEST_WINDOWS[stack].stack`:

- Node.js: `node`
- Java WebFlux: `java-webflux`
- Java MVC VT: `java-mvc-vt`
- Python: `python`
- PHP CLI: `php`
- PHP FPM: `php-fpm`
- PHP Octane: `php-octane`
- Java MVC: `java-mvc`

Exemplo (CPU para PHP CLI) com janela de 7 minutos:

```promql
rate(container_cpu_usage_seconds_total{name=~".*php.*gateway.*"}[1m])
```

**Período de coleta**: 17:34:40 → 17:41:40 (420 segundos total)

---

## ✅ Resultado final (onde olhar)

O script grava tudo em `prometheus_metrics_results.json`. É dali que saem (quando usados no relatório):

- CPU Avg/P95 (cores)
- Mem Avg/P95 (MB)
- (opcional) RPS Prometheus Avg/P95

---

## 🔧 Limitações / riscos conhecidos desse método

- **Regex por `name`**: `name=~".*{stack_label}.*gateway.*"` pode:
  - pegar mais de um container,
  - ou não pegar nenhum se o label `name` do cAdvisor não contiver esses pedaços.
- **P95 em Python**: é percentil sobre amostras; não é P95 “exato” sobre todos os eventos.
- **Mistura de séries**: se a query retornar múltiplas séries, o script agrega tudo junto (não soma por timestamp nem faz `sum by(...)`).
- **Janela fixa de 7 minutos**: Pode incluir períodos de aquecimento/cooldown que afetam as médias, mas garante cobertura completa do teste.
- **Step de 15s**: Amostragem pode perder picos muito rápidos de CPU/memória.
