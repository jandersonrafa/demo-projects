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

### 📉 K6 Erros (Consolidado)
Esta métrica unifica dois tipos de falha crítica nos testes de carga:
1. **Drops (`dropped_iterations`)**: Requisições que o K6 **não conseguiu enviar** devido à saturação.
2. **Failed Requests (`http_req_failed`)**: Requisições que foram enviadas mas retornaram **erro HTTP 500** (falha da aplicação).

Isso simplifica a visualização de "quantas requisições falharam", seja por impossibilidade de envio ou erro no processamento.

---

## 📊 Como é Calculada a Taxa de Sucesso Real

A **Taxa Sucesso Real** é calculada a partir dos relatórios do K6, **não do Prometheus**:

### 📈 Fórmula:
```
Taxa Sucesso Real (%) = (K6 Reqs - K6 Failed Requests) / (K6 Reqs + K6 Drops) × 100
```

Ou de forma expandida:
```
Taxa Sucesso Real (%) = (http_reqs.count - http_req_failed.passes) / (http_reqs.count + dropped_iterations.count) × 100
```

### 📋 Fonte dos Dados:
- **K6 Reqs**: Métrica `http_reqs.count` do relatório K6. Representa o total de requisições HTTP enviadas pelo K6 ao servidor.
- **K6 Failed Requests (HTTP 500)**: Métrica `http_req_failed.passes` do relatório K6. Representa requisições que foram enviadas mas retornaram erro HTTP 500 (falha da aplicação).
- **K6 Drops**: Métrica `dropped_iterations.count` do relatório K6. Representa requisições descartadas pelo K6 antes do envio devido à saturação de VUs ou timeout interno do gerador de carga.

### 🎯 O que representa:
- **Taxa de sucesso real**: Percentual de requisições que foram **enviadas com sucesso E processadas com sucesso** pelo servidor
- **Considera dois tipos de falha**:
  1. **Falhas de envio (Drops)**: K6 não conseguiu enviar a requisição
  2. **Falhas de processamento (HTTP 500)**: Servidor recebeu mas retornou erro

### ⚠️ Importante:
Esta métrica foi **atualizada** para considerar não apenas a capacidade de envio (drops), mas também a **qualidade das respostas** (HTTP 500). Uma stack pode ter baixo número de drops mas alta taxa de erros HTTP 500, indicando problema na aplicação sob carga.

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

O script define uma janela fixa de **10 minutos (600s)** por stack:

- **start_ts**: timestamp ISO definido em `TEST_WINDOWS[stack].start` (início do teste)
- **end_ts**: `start_ts + 600`
- **step**: `"15s"` (amostragem a cada 15 segundos)

Trechos relevantes:

```17:54:benchmark-executor-k6-grafana/query_prometheus_metrics.py
TEST_WINDOWS = {
    "php-octane": {
        "start": "2026-01-21T15:38:48-03:00",
        "port": 3014,
        "stack": "php-octane",
        "name": "PHP Octane"
    },
    // ... demais stacks ...
}
```

```95:115:benchmark-executor-k6-grafana/query_prometheus_metrics.py
def get_container_metrics(stack_key, test_info):
    start_ts = parse_timestamp(test_info["start"])
    # Test duration is 10 minutes
    end_ts = start_ts + 600
    stack_label = test_info["stack"]
    results = {
        "stack": test_info["name"],
        "stack_label": stack_label,
        "port": test_info["port"],
        "start_time": test_info["start"],
        "duration_seconds": 600
    }
```

---

## 📅 Janelas de Tempo Específicas por Stack (10 Minutos)

| Stack | Início (UTC-3) | Fim (UTC-3) | Duração |
|-------|----------------|-------------|---------|
| **PHP Octane** | `2026-01-21T15:38:48` | `2026-01-21T15:48:48` | 10 min |
| **PHP FPM** | `2026-01-21T15:49:45` | `2026-01-21T15:59:45` | 10 min |
| **Python** | `2026-01-21T16:01:43` | `2026-01-21T16:11:43` | 10 min |
| **Node.js** | `2026-01-21T16:12:47` | `2026-01-21T16:22:47` | 10 min |
| **Java MVC VT** | `2026-01-21T16:24:29` | `2026-01-21T16:34:29` | 10 min |
| **Java WebFlux** | `2026-01-21T16:35:55` | `2026-01-21T16:45:55` | 10 min |

**Observação**: Cada teste teve duração de **10 minutos** com carga constante de 400 RPS, permitindo análise de estabilidade sob carga sustentada.

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

- PHP Octane: `php-octane`
- PHP FPM: `php-fpm`
- Python: `python`
- Node.js: `node`
- Java MVC VT: `java-mvc-vt`
- Java WebFlux: `java-webflux`

Exemplo (CPU para PHP FPM) com janela de 10 minutos:

```promql
rate(container_cpu_usage_seconds_total{name=~".*php-fpm.*gateway.*"}[1m])
```

**Período de coleta**: 15:49:45 → 15:59:45 (600 segundos total)

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
- **Janela fixa de 10 minutos**: Captura todo o período de teste com carga constante de 400 RPS, sem fases de ramping.
- **Step de 15s**: Amostragem pode perder picos muito rápidos de CPU/memória.
