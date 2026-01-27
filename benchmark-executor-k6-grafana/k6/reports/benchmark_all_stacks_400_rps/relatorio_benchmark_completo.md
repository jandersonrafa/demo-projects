# 📊 Relatório de Benchmark - Análise Técnica Comparativa de Performance

## 📋 Sumário Executivo

Este relatório apresenta uma análise técnica comparativa de performance de **6 stacks tecnológicas** testadas sob carga constante de 400 RPS durante 10 minutos cada. Os testes foram executados usando K6, avaliando o endpoint `/bonus` (POST). As métricas incluem dados do K6 e métricas de container coletadas do Prometheus (CPU e memória).

**Data do Teste**: 2026-01-21 (15:38 - 16:45)
**Duração por Stack**: 10 minutos
**Carga Máxima**: 400 RPS
**Endpoint Testado**: POST `/bonus`
**Pool de conexões - Max configurado**: +- 15 conexões para cada stack

## Informações
- Métricas das aplicações durante o teste disponíveis em: `/relatorio_benchmark_grafana.md`
- Metodologia/métricas usadas para benchmark disponível em: `/relatorio_benchmark_metodologia_calculo.md`
- Relatórios de execução gerados pelo k6 disponível em: `/relatorios_execucao_k6`

### Escopo do Teste

**O que foi avaliado**:
- ✅ Endpoint POST `/bonus` com operações de banco
- ✅ Cálculo simples de bônus
- ✅ Uma operação de persistência e uma operação de Busca no Banco
- ✅ Carga sintética constante (K6)
- ✅ 10 minutos por stack
- ✅ Target de 400 RPS

**O que NÃO foi avaliado**:
- ❌ Operações de leitura (GET)
- ❌ Workloads CPU-bound intensivos
- ❌ Diferentes padrões de acesso ao banco
- ❌ Testes de longa duração (horas)
- ❌ Comportamento sob diferentes tipos de carga

---

## 🎯 Metodologia de Teste

**Thresholds**:
- P95 de duração de requisição: < 1000ms
- Taxa de falha (HTTP Errors): < 1%

**Configuração de Recursos**:
- Limite de memória por container: 2GB
- Prometheus: porta 9091
- cAdvisor: porta 8081

---

## 📊 Resultados Consolidados - Tabela Geral

| Stack | Porta | K6 Reqs Enviadas | K6 Drops | K6 Failed Requests (HTTP 500) | K6 RPS Médio | App RPS Médio | VUs Máx | P95 (ms) | Tempo Médio (ms) | CPU Avg (cores) | CPU P95 (cores) | Mem Avg (MB) | Mem P95 (MB) | Taxa Sucesso Real | Threshold |
|-------|-------|------------|--------------|-------------------------------|-----------|---------------|---------|----------|------------------|-----------------|-----------------|--------------|--------------|--------------|-----------|
| **Java MVC VT** | 3007 | 210,599 | 0 | 0 | 350.99 | 345.73 | 93 | 13.85 | 8.70 | 0.3343 | 0.4494 | 246.94 | 264.51 | 100.00% | ✅ |
| **Java WebFlux** | 3006 | 210,599 | 0 | 0 | 350.99 | 337.60 | 75 | 14.36 | 9.56 | 0.3183 | 0.3786 | 248.19 | 257.93 | 100.00% | ✅ |
| **Node.js** | 3005 | 210,599 | 0 | 4 | 350.99 | 345.92 | 400 | 24.98 | 16.42 | 0.6168 | 0.8770 | 102.39 | 128.38 | 99.99% | ✅ |
| **Python** | 3008 | 210,420 | 179 | 246 | 350.69 | 344.45 | 568 | 126.03 | 48.79 | 1.2136 | 2.0634 | 252.10 | 259.86 | 99.80% | ✅ |
| **PHP Octane** | 3014 | 210,534 | 65 | 14,821 | 350.88 | 74.32 | 447 | 83.68 | 32.09 | 1.3649 | 4.5409 | 323.81 | 650.38 | 92.94% | ❌ |
| **PHP FPM** | 3011 | 186,237 | 24,362 | 0 | 310.39 | 305.25 | 800 | 2,112.34 | 1,295.38 | 2.2719 | 6.7071 | 52.57 | 86.30 | 88.43% | ❌ |

**Notas da Tabela**:
- **K6 Reqs Enviadas**: Total de requisições HTTP que o K6 conseguiu enviar ao servidor
- **K6 Drops**: `dropped_iterations` - requisições que o K6 não conseguiu enviar (saturação do gerador de carga)
- **K6 Failed Requests (HTTP 500)**: Requisições enviadas que retornaram erro HTTP 500 (falha da aplicação)
- **K6 RPS Médio**: Requests per second medido pelo K6 (gerador de carga)
- **App RPS Médio**: Requests per second medido pela aplicação via Prometheus (`http_requests_total` ou `http_server_requests_seconds_count`)
- **Taxa Sucesso Real**: `(Reqs Enviadas - Failed Requests) / (Reqs Enviadas + Drops) × 100`
  - Considera tanto falhas de envio (drops) quanto falhas de processamento (HTTP 500)
- **PHP Octane**: Falhou devido a 14,821 erros HTTP 500 (7.04%), resultando em apenas 92.94% de sucesso real
- **PHP FPM**: Falhou por Latência P95 > 1000ms e 11.6% de drops, resultando em 88.43% de sucesso real

---

### Quantidade de bônus inseridos no banco durante o teste

Durante os testes de carga, cada stack processou requisições POST para o endpoint `/bonus`, resultando nas seguintes quantidades de registros (inserts estimados via K6 Reqs Sucesso):

- **Java WebFlux**: 210,599 inserts
- **Java MVC VT**: 210,599 inserts
- **Node (NestJS)**: 210,599 inserts
- **PHP Octane**: 210,534 inserts (requisições aceitas, porém check de sucesso indicou falhas HTTP)
- **Python (FastAPI)**: 210,420 inserts
- **Laravel FPM**: 186,237 inserts

---

## 🔍 Análise Detalhada por Stack

### Java MVC VT (Spring MVC + Virtual Threads)
**Porta**: 3007 | **Tecnologia**: Spring MVC com Virtual Threads (Project Loom)

#### Métricas K6
- **K6 Reqs Sucesso**: 210,599
- **K6 Reqs Erro (Drops)**: 0
- **RPS Médio**: 350.99 req/s
- **VUs Simultâneos (Máximo)**: 93
- **P95**: 13.85 ms
- **Tempo Médio**: 8.70 ms
- **Taxa de Sucesso (Capacidade)**: 100.00%
- **Erros HTTP (500)**: 0

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.3343 cores
- **CPU P95**: 0.4494 cores
- **Memória Média**: 246.94 MB
- **Memória P95**: 264.51 MB

#### Observações Técnicas
- Melhor desempenho de latência (8.70ms média).
- Uso eficientíssimo de CPU (0.33 cores) e baixo VUs (93).
- Virtual Threads brilharam mantendo o throughput estável sem drops.

---

### Java WebFlux (Spring WebFlux + WebFlux.fn)
**Porta**: 3006 | **Tecnologia**: Spring WebFlux com programação reativa

#### Métricas K6
- **K6 Reqs Sucesso**: 210,599
- **K6 Reqs Erro (Drops)**: 0
- **RPS Médio**: 350.99 req/s
- **VUs Simultâneos (Máximo)**: 75
- **P95**: 14.36 ms
- **Tempo Médio**: 9.56 ms
- **Taxa de Sucesso (Capacidade)**: 100.00%
- **Erros HTTP (500)**: 0

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.3183 cores
- **CPU P95**: 0.3786 cores
- **Memória Média**: 248.19 MB
- **Memória P95**: 257.93 MB

#### Observações Técnicas
- Menor uso de CPU (0.31 cores) e menor número de VUs (75).
- Desempenho quase idêntico ao VT, ligeiramente melhor em eficiência de recursos.

---

### Node.js (NestJS + TypeScript)
**Porta**: 3005 | **Tecnologia**: NestJS com TypeScript

#### Métricas K6
- **K6 Reqs Sucesso**: 210,599
- **K6 Reqs Erro (Drops)**: 0
- **RPS Médio**: 350.99 req/s
- **VUs Simultâneos (Máximo)**: 400
- **P95**: 24.98 ms
- **Tempo Médio**: 16.42 ms
- **Taxa de Sucesso (Capacidade)**: 100.00%
- **Erros HTTP (500)**: 4 (negligenciável)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.6168 cores
- **CPU P95**: 0.8770 cores
- **Memória Média**: 102.39 MB
- **Memória P95**: 128.38 MB

#### Observações Técnicas
- Latência excelente (P95 < 25ms).
- Baixíssimo consumo de memória (102 MB).
- Precisou de mais VUs (400) para manter a carga comparado ao Java.

---

### Python (FastAPI + SQLAlchemy)
**Porta**: 3008 | **Tecnologia**: FastAPI com SQLAlchemy Async + Uvicorn

#### Métricas K6
- **K6 Reqs Sucesso**: 210,420
- **K6 Reqs Erro (Drops)**: 179
- **RPS Médio**: 350.69 req/s
- **VUs Simultâneos (Máximo)**: 568
- **P95**: 126.03 ms
- **Tempo Médio**: 48.79 ms
- **Taxa de Sucesso (Capacidade)**: 99.91%
- **Erros HTTP (500)**: 246 (0.11%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 1.2136 cores
- **CPU P95**: 2.0634 cores
- **Memória Média**: 252.10 MB
- **Memória P95**: 259.86 MB

#### Observações Técnicas
- Passou nos thresholds, mas com latência maior (126ms).
- Alto consumo de CPU (1.2 cores) e VUs (568) indicando maior custo por request.

---

### PHP Octane (Laravel Octane + Swoole)
**Porta**: 3014 | **Tecnologia**: Laravel Octane com Swoole

#### Métricas K6
- **K6 Reqs Sucesso**: 210,534 (total de requisições HTTP enviadas)
- **K6 Reqs Erro (Drops)**: 65 (requisições não enviadas pelo K6)
- **RPS Médio**: 350.88 req/s
- **VUs Simultâneos (Máximo)**: 447
- **P95**: 83.68 ms
- **Tempo Médio**: 32.09 ms
- **Taxa de Sucesso (Capacidade)**: 99.97% (conseguiu enviar quase todas as requisições)
- **Erros HTTP 500**: 14,821 de 210,534 requisições = **7.04%** ❌

#### Métricas de Container (Prometheus)
- **CPU Médio**: 1.3649 cores
- **CPU P95**: 4.5409 cores
- **Memória Média**: 323.81 MB
- **Memória P95**: 650.38 MB

#### Observações Técnicas
- **Reprovado**: Taxa de erros HTTP de **7.04%** viola severamente o critério de qualidade (<1%).
- Das 210,534 requisições enviadas, 14,821 retornaram HTTP 500 (erro de aplicação).
- Latência P95 aceitável (83ms), mas a aplicação não conseguiu processar corretamente sob carga.
- Pico de CPU (4.5 cores) e memória (650 MB) indicam possível vazamento ou ineficiência sob estresse prolongado.
- Apenas 65 drops (0.03%), mostrando que o problema é na aplicação, não no gerador de carga.

---

### Laravel FPM (Nginx + PHP-FPM)
**Porta**: 3011 | **Tecnologia**: Nginx + PHP-FPM

#### Métricas K6
- **K6 Reqs Sucesso**: 186,237
- **K6 Reqs Erro (Drops)**: 24,362
- **RPS Médio**: 310.39 req/s
- **VUs Simultâneos (Máximo)**: 800
- **P95**: 2,112.34 ms
- **Tempo Médio**: 1,295.38 ms
- **Taxa de Sucesso (Capacidade)**: 88.43%
- **Erros HTTP (500)**: 0

#### Métricas de Container (Prometheus)
- **CPU Médio**: 2.2719 cores
- **CPU P95**: 6.7071 cores
- **Memória Média**: 52.57 MB
- **Memória P95**: 86.30 MB

#### Observações Técnicas
- **Reprovado**: Falência total sob carga de 400 RPS.
- Saturação de CPU (6.7 cores!).
- Latência média > 1s.
- Perda de ~12% da capacidade de carga (drops).

---

## 📈 Análise Comparativa de Métricas

### RPS (Requests Per Second)
Java e Node entregaram ~351 RPS constantes (target). Python e Octane acompanharam. FPM colapsou para 310 RPS.

### P95 (Percentil 95 de Latência)
1. **Java MVC VT**: 13.85 ms 🏆
2. **Java WebFlux**: 14.36 ms
3. **Node.js**: 24.98 ms
4. **PHP Octane**: 83.68 ms
5. **Python**: 126.03 ms
6. **PHP FPM**: 2,112.34 ms 💀

### Uso de CPU (Cores Médias)
1. **Java WebFlux**: 0.31 cores 🏆
2. **Java MVC VT**: 0.33 cores
3. **Node.js**: 0.61 cores
4. **Python**: 1.21 cores
5. **PHP Octane**: 1.36 cores
6. **PHP FPM**: 2.27 cores

### Estabilidade
- **Java/Node**: Robustez total (100% sucesso, 0 drops).
- **Python**: Estável, pequenos drops.
- **PHP Octane**: Rápido mas propenso a erros (7% falhas).
- **PHP FPM**: Inadequado para esta carga.

---

## 📋 Resumo dos Dados Coletados

**Relatório gerado em**: 2026-01-21
**Dados fonte**: K6 Reports + Prometheus (localhost:9091)
**Período de coleta**: 2026-01-21 15:38 - 16:45
**Stacks testadas**: 6
**Total de requisições processadas**: > 1.2 milhão
**Métricas coletadas**: K6 (RPS, latência, VUs, erros) + Prometheus (CPU, memória)
**Janela de coleta**: 10 minutos por stack (600 segundos)
