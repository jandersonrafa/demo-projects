# Benchmark Report Generator - Documentação Técnica

Este documento detalha todas as métricas geradas pelo script `generate_benchmark.py` e a lógica de cálculo envolvida.

## Visão Geral

O script gera três tabelas principais:
1. **Nomad Metrics** - Métricas de infraestrutura (CPU, Memória, Instâncias)
2. **K6 Metrics** - Métricas de performance do teste de carga
3. **Traefik Metrics** - Métricas do proxy/gateway

Todas as métricas são consultadas via Prometheus usando PromQL e focam na **fase de carga** (últimos 10 minutos do teste, excluindo warmup).

---

## 1. Nomad Metrics - Infraestrutura

### 1.1 Nomad Instances
**Descrição:** Número de instâncias (alocações) do job Nomad

**Query PromQL:**
```promql
count(count(nomad_client_allocs_cpu_total_ticks{exported_job='<job_name>'}) by (alloc_id))
```

**Lógica:**
- Conta alocações únicas (`alloc_id`) do job
- Usa instant query no final da janela de teste
- Retorna número inteiro de instâncias

**Exemplo:** `1` (uma instância), `2` (duas instâncias)

---

### 1.2 CPU Allocation (Total - CPU Alloc)
**Descrição:** CPU alocada total para o job (em cores)

**Query PromQL:**
```promql
sum(nomad_client_allocs_cpu_allocated{exported_job='<job_name>'})
```

**Lógica:**
- Soma a CPU alocada de todas as alocações
- Valor em MHz, convertido para cores (1024 MHz = 1 core)
- Instant query no final da janela

**Conversão:** `MHz / 1024 = cores`

**Exemplo:** `1536 MHz → 1,50 core`

---

### 1.3 CPU Usage Average (Total - CPU Avg)
**Descrição:** Uso médio de CPU durante a fase de carga (em cores)

**Query PromQL:**
```promql
sum(nomad_client_allocs_cpu_total_ticks{exported_job='<job_name>'})
```

**Lógica:**
- Range query com step de 15s durante os 600s de carga
- Calcula média aritmética de todos os valores retornados
- Valor em MHz, convertido para cores

**Conversão:** `mean(valores_mhz) / 1024 = cores`

**Exemplo:** `1013 MHz (média) → 0,99 core`

---

### 1.4 CPU Usage Max (Total - CPU Max)
**Descrição:** Pico máximo de uso de CPU durante a fase de carga (em cores)

**Query PromQL:**
```promql
sum(nomad_client_allocs_cpu_total_ticks{exported_job='<job_name>'})
```

**Lógica:**
- Mesma range query da CPU Avg
- Extrai o valor máximo da série temporal
- Valor em MHz, convertido para cores

**Conversão:** `max(valores_mhz) / 1024 = cores`

**Exemplo:** `1576 MHz (pico) → 1,54 core`

---

### 1.5 Memory Allocation (Total - Mem Alloc)
**Descrição:** Memória alocada total para o job (em MiB)

**Query PromQL:**
```promql
sum(nomad_client_allocs_memory_allocated{exported_job='<job_name>'})
```

**Lógica:**
- Soma a memória alocada de todas as alocações
- Valor em bytes, convertido para MiB e arredondado
- Instant query no final da janela

**Conversão:** `bytes / 1024 / 1024 = MiB` (arredondado para inteiro)

**Exemplo:** `536870912 bytes → 512 MiB`

---

### 1.6 Memory Usage Average (Total - Mem Avg)
**Descrição:** Uso médio de memória durante a fase de carga (em MiB)

**Query PromQL:**
```promql
sum(nomad_client_allocs_memory_usage{exported_job='<job_name>'})
```

**Lógica:**
- Range query com step de 15s durante os 600s de carga
- Calcula média aritmética de todos os valores
- Valor em bytes, convertido para MiB e arredondado

**Conversão:** `mean(valores_bytes) / 1024 / 1024 = MiB` (arredondado)

**Exemplo:** `290455552 bytes (média) → 277 MiB`

---

### 1.7 Memory Usage Max (Total - Mem Max)
**Descrição:** Pico máximo de uso de memória durante a fase de carga (em MiB)

**Query PromQL:**
```promql
sum(nomad_client_allocs_memory_usage{exported_job='<job_name>'})
```

**Lógica:**
- Mesma range query da Mem Avg
- Extrai o valor máximo da série temporal
- Valor em bytes, convertido para MiB e arredondado

**Conversão:** `max(valores_bytes) / 1024 / 1024 = MiB` (arredondado)

**Exemplo:** `296747008 bytes (pico) → 283 MiB`

---

## 2. K6 Metrics - Performance do Teste de Carga

### 2.1 K6 Requests (K6 Reqs)
**Descrição:** Total de requisições HTTP bem-sucedidas durante a fase de carga

**Query PromQL:**
```promql
sum(increase(k6_http_reqs_total{scenario=~'load_.*<port>'}[600s]))
```

**Lógica:**
- Filtra por cenário `load_*` e porta específica
- `increase()` calcula o incremento total em 600s
- Instant query no final da janela
- Exclui automaticamente a fase de warmup

**Exemplo:** `89507` requisições

---

### 2.2 K6 Errors (K6 Erros)
**Descrição:** Total de erros durante a fase de carga (HTTP 4xx/5xx + dropped iterations)

**Query PromQL (HTTP Errors):**
```promql
sum(increase(k6_http_reqs_total{scenario=~'load_.*<port>', status=~'[45]..'}[600s]))
```

**Query PromQL (Dropped Iterations):**
```promql
sum(increase(k6_dropped_iterations_total{scenario=~'load_.*<port>'}[600s]))
```

**Lógica:**
- HTTP Errors: requisições com status 4xx ou 5xx
- Dropped Iterations: iterações que não puderam ser executadas (sobrecarga)
- Total de erros = HTTP Errors + Dropped Iterations

**Exemplo:** `8 erros` (6 HTTP + 2 dropped)

---

### 2.3 K6 RPS Average (K6 RPS Avg)
**Descrição:** Taxa média de requisições por segundo

**Cálculo:**
```
RPS = Total Requests / 600s
```

**Lógica:**
- Derivado diretamente do total de requisições
- Mais preciso que `mean(rate(...))` para testes de duração fixa
- Evita distorções de edge effects nas bordas da janela

**Exemplo:** `89507 / 600 = 149,18 RPS`

---

### 2.4 K6 P95 Latency (K6 P95 ms)
**Descrição:** Latência P95 (95º percentil) em milissegundos

**Query PromQL:**
```promql
avg by (method) (last_over_time(k6_http_req_duration_p95{scenario=~'load_.*<port>'}[600s]))
```

**Lógica:**
1. `last_over_time()`: Captura o valor final de P95 na janela de 600s
2. `avg by (method)`: Agrupa por método HTTP (GET, POST) e calcula média
3. Média final dos valores por método (GET e POST)
4. Conversão de segundos para milissegundos (× 1000)

**Justificativa:**
- Alinha com a lógica do dashboard Grafana
- Evita agregar múltiplas séries de endpoints sem agrupamento
- Representa melhor a performance real (GET vs POST)

**Exemplo:** `0.02666 s → 26,66 ms`

---

### 2.5 K6 Average Latency (K6 Avg ms)
**Descrição:** Latência média em milissegundos

**Query PromQL:**
```promql
avg by (method) (last_over_time(k6_http_req_duration_avg{scenario=~'load_.*<port>'}[600s]))
```

**Lógica:**
- Mesma abordagem do P95
- Agrupa por método HTTP antes de calcular média final
- Conversão de segundos para milissegundos (× 1000)

**Exemplo:** `0.00974 s → 9,74 ms`

---

### 2.6 Success Rate (Success %)
**Descrição:** Taxa de sucesso das requisições

**Cálculo:**
```
Success % = ((Total Reqs - HTTP Errors) / (Total Reqs + Dropped Iterations)) × 100
```

**Lógica:**
- Numerador: Requisições bem-sucedidas (sem erros HTTP)
- Denominador: Total de tentativas (incluindo dropped iterations)
- Formatação com vírgula decimal (padrão brasileiro)

**Exemplo:** `(89507 - 6) / (89507 + 2) × 100 = 99,99%`

---

### 2.7 Threshold
**Descrição:** Indicador visual de aprovação (✅ ou ❌)

**Lógica:**
```
✅ se Success % >= 95%
❌ se Success % < 95%
```

---

## 3. Traefik Metrics - Proxy/Gateway

### 3.1 Traefik Requests (Traefik Reqs)
**Descrição:** Total de requisições bem-sucedidas (2xx, 3xx) no Traefik

**Query PromQL:**
```promql
sum(increase(traefik_service_requests_total{service=~'<service>.*', code=~'[23]..'}[600s]))
```

**Lógica:**
- Filtra por serviço Traefik específico
- Inclui apenas códigos 2xx e 3xx (sucesso)
- `increase()` calcula incremento total em 600s

**Exemplo:** `89985` requisições

---

### 3.2 Traefik Errors (Traefik Erros)
**Descrição:** Total de erros (4xx, 5xx) no Traefik

**Query PromQL:**
```promql
sum(increase(traefik_service_requests_total{service=~'<service>.*', code=~'[45]..'}[600s]))
```

**Lógica:**
- Mesma query, mas filtra códigos 4xx e 5xx
- Representa erros no nível do proxy

**Exemplo:** `0` erros

---

### 3.3 Traefik RPS Average (Traefik RPS Avg)
**Descrição:** Taxa média de requisições por segundo no Traefik

**Cálculo:**
```
RPS = Total Requests / 600s
```

**Lógica:**
- Mesma abordagem do K6 RPS
- Derivado do total de requisições

**Exemplo:** `89985 / 600 = 149,98 RPS`

---

### 3.4 Traefik P95 Latency (Traefik P95 ms)
**Descrição:** Latência P95 medida pelo Traefik (em milissegundos)

**Query PromQL:**
```promql
histogram_quantile(0.95, sum(rate(traefik_service_request_duration_seconds_bucket{service=~'<service>.*'}[1m])) by (le)) * 1000
```

**Lógica:**
1. Range query com step de 15s durante os 600s
2. `histogram_quantile(0.95, ...)`: Calcula P95 de histograma
3. `rate(...[1m])`: Taxa de requisições em janelas de 1 minuto
4. Média de todos os valores P95 ao longo do tempo
5. Conversão para milissegundos (× 1000)

**Exemplo:** `0.01992 s (média) → 19,92 ms`

---

### 3.5 Traefik Average Latency (Traefik Avg ms)
**Descrição:** Latência média medida pelo Traefik (em milissegundos)

**Query PromQL:**
```promql
(sum(rate(traefik_service_request_duration_seconds_sum{service=~'<service>.*'}[1m])) / 
 sum(rate(traefik_service_request_duration_seconds_count{service=~'<service>.*'}[1m]))) * 1000
```

**Lógica:**
1. Range query com step de 15s
2. Calcula latência média: `sum / count`
3. Média de todos os valores ao longo do tempo
4. Conversão para milissegundos (× 1000)

**Exemplo:** `0.00610 s (média) → 6,10 ms`

---

### 3.6 Traefik Success Rate (Success %)
**Descrição:** Taxa de sucesso no Traefik

**Cálculo:**
```
Success % = (Total Reqs / (Total Reqs + Total Errors)) × 100
```

**Lógica:**
- Numerador: Requisições bem-sucedidas (2xx, 3xx)
- Denominador: Total de requisições (sucesso + erros)
- Formatação com vírgula decimal

**Exemplo:** `89985 / (89985 + 0) × 100 = 100,00%`

---

### 3.7 Threshold
**Descrição:** Indicador visual de aprovação (✅ ou ❌)

**Lógica:**
```
✅ se Success % >= 95%
❌ se Success % < 95%
```

---

## Janela Temporal

### Cálculo da Janela de Carga

**Estrutura do Teste K6:**
- Warmup: 5 minutos (300s)
- Load: 10 minutos (600s)
- **Total:** 15 minutos

**Extração do Timestamp:**
- Filename: `summary-2026-02-11_10-06-08-BR-8101.json`
- Timestamp extraído: `2026-02-11T10:06:08` (fim do teste)

**Cálculo da Janela:**
```
end_time = timestamp_from_filename
start_time = end_time - 600s
```

**Exemplo:**
- End: `10:06:08`
- Start: `09:56:08`
- Janela: `[09:56:08, 10:06:08]` (últimos 10 minutos)

---

## Formatação

### Números
- **Decimais:** Vírgula (padrão brasileiro) - `1,50` em vez de `1.50`
- **Percentuais:** Vírgula decimal - `99,99%`

### Unidades
- **CPU:** `core` (1024 MHz = 1 core)
- **Memória:** `MiB` (arredondado para inteiro)
- **Latência:** `ms` (milissegundos, 2 casas decimais)
- **RPS:** 2 casas decimais

### Ordenação
- Tabela Nomad: Ordenada por `CPU Alloc`, depois `Mem Alloc` (crescente)
- Tabelas K6/Traefik: Mesma ordem da tabela Nomad

---

## Validação

O script foi validado contra os dashboards Grafana:
- **K6 Dashboard:** Métricas P95/Avg alinham com `last_over_time by (method)`
- **Traefik Dashboard:** Métricas P95/Avg alinham com queries de histograma
- **Nomad Dashboard:** CPU/Mem alinham com `avg_over_time` de `cpu_total_ticks`

Consulte `validation_report.md` para detalhes da validação.

---

## Troubleshooting

### Métricas zeradas
- Verifique se o `exported_job` no Prometheus corresponde ao nome do job no `STACK_MAP`
- Confirme que o Prometheus tem dados para a janela temporal do teste

### Latências discrepantes
- K6 P95 usa `avg by (method)` - agrupa GET/POST antes de calcular média
- Dashboard pode usar `avg by (scenario)` - resulta em valores diferentes
- Ambas são válidas, mas `by (method)` é mais representativa

### RPS diferente entre K6 e Traefik
- K6 RPS: Perspectiva do cliente (inclui timeouts, dropped iterations)
- Traefik RPS: Perspectiva do proxy (apenas requisições que chegaram)
- Diferença pequena (<1%) é normal

---

## Referências

- **Script:** `generate_benchmark.py`
- **Guia de Uso:** `usage_guide.md` (em `.gemini/antigravity/brain/...`)
- **Validação:** `validation_report.md` (em `.gemini/antigravity/brain/...`)
- **Dashboards Grafana:**
  - K6: `monitoring/infra/grafana/dashboards/teste-performance/k6-performance.json`
  - Traefik: `monitoring/infra/grafana/dashboards/teste-performance/traefik-performance.json`
  - Nomad: `monitoring/infra/grafana/dashboards/teste-performance/nomad-performance.json`
