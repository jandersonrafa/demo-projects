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
- As aplicações utilizam pgbouncer como proxy para chegar até o banco de dados, o pgbouncer garante que todas as stacks tenham um limite de um pool de 15 conexões
- Foram realizados testes para encontrar as melhores configurações de numero de workers e threads para cada stack, os testes estão disponíveis em: `performance_calibragem_configs_500_rps`
    - python 6 workers
    - php-fpm 20 childrens
    - php-octane 15 workers
    - node 8 uv threads
    - java default threads


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

### Configuração do Teste K6

**Padrão de Carga**: Ramping Arrival Rate

| Fase | Duração | Target RPS | Descrição |
|------|---------|------------|-----------|
| 1 | 1 minuto | 100 RPS | Aquecimento inicial |
| 2 | 1 minuto | 200 RPS | Aumento gradual |
| 3 | 1 minuto | 300 RPS | Carga média |
| 4 | 1 minuto | 400 RPS | Pico de carga |
| 5 | 1 minuto | 400 RPS | Estabilização |
| 6 | 1 minuto | 0 RPS | Cooldown |

**Configuração de VUs**:
- VUs pré-alocados: 400
- VUs máximos: 800

**Thresholds**:
- P95 de duração de requisição: < 1000ms
- Taxa de falha: < 1%

**Configuração de Recursos**:
- Limite de memória por container: 2GB
- Prometheus: porta 9091
- cAdvisor: porta 8081

---



## 📊 Resultados Consolidados - Tabela Geral

| Stack | K6 Reqs | K6 Erros | App RPS Médio | P95 (ms) | Tempo Médio (ms) | CPU Avg | CPU P95 | Mem Avg | Mem P95 | Taxa Sucesso Real | Threshold |
|-------|------------|----------|---------------|----------|------------------|---------|---------|---------|---------|--------------|-----------|
| **Java MVC VT** | 210.599 | 0 | 345,73 | 13,85 | 8,70 | 0,3 core | 0,4 core | 247 MB | 265 MB | 100,00% | ✅ |
| **Java WebFlux** | 210.599 | 0 | 337,60 | 14,36 | 9,56 | 0,3 core | 0,4 core | 248 MB | 258 MB | 100,00% | ✅ |
| **Node.js** | 210.599 | 4 | 345,92 | 24,98 | 16,42 | 0,6 core | 0,9 core | 102 MB | 128 MB | 99,99% | ✅ |
| **Python** | 210.420 | 425 | 344,45 | 126,03 | 48,79 | 1,2 core | 2,1 core | 252 MB | 260 MB | 99,80% | ✅ |
| **PHP Octane** | 210.534 | 14.886 | 74,32 | 83,68 | 32,09 | 1,4 core | 4,5 core | 324 MB | 650 MB | 92,94% | ❌ |
| **PHP FPM** | 186.237 | 24.362 | 305,25 | 2.112,34 | 1.295,38 | 2,3 core | 6,7 core | 53 MB | 86 MB | 88,43% | ❌ |

**Notas da Tabela**:
- **K6 Reqs**: Total de requisições HTTP que o K6 conseguiu enviar ao servidor
- **K6 Erros**: Soma de `dropped_iterations` (saturação) e `http_req_failed` (erros 500)
- **App RPS Médio**: Requests per second medido pela aplicação via Prometheus (`http_requests_total` ou `http_server_requests_seconds_count`)
- **Taxa Sucesso Real**: `(K6 Reqs - Failed Requests) / (K6 Reqs + Drops) × 100`
- **PHP Octane**: Falhou devido a 14,821 erros HTTP 500 (7.04%)
- **PHP FPM**: Falhou por Latência P95 > 1000ms e 11.6% de drops

---

## 🔍 Análise Detalhada por Stack

### Java MVC VT (Spring MVC + Virtual Threads)
**Porta**: 3007 | **Tecnologia**: Spring MVC com Virtual Threads (Project Loom)

#### Métricas K6
- **K6 Reqs**: 210.599
- **K6 Drops**: 0
- **App RPS Médio**: 345,73 req/s
- **VUs Simultâneos (Máximo)**: 93
- **P95**: 13,85 ms
- **Tempo Médio**: 8,70 ms
- **Taxa de Sucesso (Capacidade)**: 100,00%
- **K6 Failed Requests (HTTP 500)**: 0

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0,3 core
- **CPU P95**: 0,4 core
- **Memória Média**: 247 MB
- **Memória P95**: 265 MB

#### Observações Técnicas
- Melhor desempenho de latência (8.70ms média).
- Uso eficiente de CPU (0.33 cores) e baixo VUs (93).
- Virtual Threads mantiveram o throughput estável sem drops.

---

### Java WebFlux (Spring WebFlux + WebFlux.fn)
**Porta**: 3006 | **Tecnologia**: Spring WebFlux com programação reativa

#### Métricas K6
- **K6 Reqs**: 210.599
- **K6 Drops**: 0
- **App RPS Médio**: 337,60 req/s
- **VUs Simultâneos (Máximo)**: 75
- **P95**: 14,36 ms
- **Tempo Médio**: 9,56 ms
- **Taxa de Sucesso (Capacidade)**: 100,00%
- **K6 Failed Requests (HTTP 500)**: 0

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0,3 core
- **CPU P95**: 0,4 core
- **Memória Média**: 248 MB
- **Memória P95**: 258 MB

#### Observações Técnicas
- Menor uso de CPU (0.31 cores) e menor número de VUs (75).
- Desempenho quase idêntico ao VT, ligeiramente melhor em eficiência de recursos.

---

### Node.js (NestJS + TypeScript)
**Porta**: 3005 | **Tecnologia**: NestJS com TypeScript

#### Métricas K6
- **K6 Reqs**: 210.599
- **K6 Drops**: 0
- **App RPS Médio**: 345,92 req/s
- **VUs Simultâneos (Máximo)**: 400
- **P95**: 24,98 ms
- **Tempo Médio**: 16,42 ms
- **Taxa de Sucesso (Capacidade)**: 99,99%
- **K6 Failed Requests (HTTP 500)**: 4

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0,6 core
- **CPU P95**: 0,9 core
- **Memória Média**: 102 MB
- **Memória P95**: 128 MB

#### Observações Técnicas
- Latência excelente (P95 < 25ms).
- Baixo consumo de memória (102 MB).
- Precisou de mais VUs (400) para manter a carga comparado ao Java.

---

### Python (FastAPI + SQLAlchemy)
**Porta**: 3008 | **Tecnologia**: FastAPI com SQLAlchemy Async + Uvicorn

#### Métricas K6
- **K6 Reqs**: 210.420
- **K6 Drops**: 179
- **App RPS Médio**: 344,45 req/s
- **VUs Simultâneos (Máximo)**: 568
- **P95**: 126,03 ms
- **Tempo Médio**: 48,79 ms
- **Taxa de Sucesso (Capacidade)**: 99,80%
- **K6 Failed Requests (HTTP 500)**: 246

#### Métricas de Container (Prometheus)
- **CPU Médio**: 1,2 core
- **CPU P95**: 2,1 core
- **Memória Média**: 252 MB
- **Memória P95**: 260 MB

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
- **Reprovado**: Taxa de erros HTTP de **7,04%** viola severamente o critério de qualidade (<1%).
- Das 210,534 requisições enviadas, 14,821 retornaram HTTP 500 (erro de aplicação).
- Latência P95 aceitável (83ms), mas a aplicação não conseguiu processar corretamente sob carga.
- Pico de CPU (4.5 cores) e memória (650 MB) indicam possível vazamento ou ineficiência sob estresse prolongado.
- Apenas 65 drops (0.03%), mostrando que o problema é na aplicação, não no gerador de carga.

---

### Laravel FPM (Nginx + PHP-FPM)
**Porta**: 3011 | **Tecnologia**: Nginx + PHP-FPM

#### Métricas K6
- **K6 Reqs**: 186.237
- **K6 Drops**: 24.362
- **App RPS Médio**: 305,25 req/s
- **VUs Simultâneos (Máximo)**: 800
- **P95**: 2.112,34 ms
- **Tempo Médio**: 1.295,38 ms
- **Taxa de Sucesso (Capacidade)**: 88,43%
- **K6 Failed Requests (HTTP 500)**: 0

#### Métricas de Container (Prometheus)
- **CPU Médio**: 2,3 core
- **CPU P95**: 6,7 core
- **Memória Média**: 53 MB
- **Memória P95**: 86 MB

#### Observações Técnicas
- **Reprovado**: Falência total sob carga de 400 RPS.
- Saturação de CPU (6.7 cores!).
- Latência média > 1s.
- Perda de ~12% da capacidade de carga (drops).

---

## 📈 Análise Comparativa de Métricas

### RPS (App Requests Per Second)

| Stack | App RPS |
|---|---:|
| **Node.js** | 345,92 |
| **Java MVC VT** | 345,73 |
| **Python** | 344,45 |
| **Java WebFlux** | 337,60 |
| **PHP FPM** | 305,25 |
| **PHP Octane** | 74,32 |

### P95 (Percentil 95 de Latência)

| Stack | P95 (ms) |
|---|---:|
| **Java MVC VT** | 13,85 ms |
| **Java WebFlux** | 14,36 ms |
| **Node.js** | 24,98 ms |
| **PHP Octane** | 83,68 ms |
| **Python** | 126,03 ms |
| **PHP FPM** | 2.112,34 ms |

### Uso de CPU (P95 em Cores)

| Stack | CPU P95 |
|---|---:|
| **Java WebFlux** | 0,4 core |
| **Java MVC VT** | 0,4 core |
| **Node.js** | 0,9 core |
| **Python** | 2,1 core |
| **PHP Octane** | 4,5 core |
| **PHP FPM** | 6,7 core |

### Uso de Memória (P95)

| Stack | Memória P95 |
|---|---:|
| **PHP FPM** | 86 MB |
| **Node.js** | 128 MB |
| **Java WebFlux** | 258 MB |
| **Python** | 260 MB |
| **Java MVC VT** | 265 MB |
| **PHP Octane** | 650 MB |

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
**Métricas coletadas**: K6 (RPS, latência, VUs, erros) + Prometheus (CPU,   memória)
**Janela de coleta**: 10 minutos por stack (600 segundos)  
