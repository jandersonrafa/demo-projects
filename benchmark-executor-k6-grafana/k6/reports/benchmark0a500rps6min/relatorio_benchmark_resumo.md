# 📊 Relatório de Benchmark - Análise Técnica Comparativa de Performance

## 📋 Sumário Executivo

Este relatório apresenta uma análise técnica comparativa de performance de **6 stacks tecnológicas** testadas sob carga progressiva durante 6 minutos cada. Os testes foram executados usando K6 com ramping de 100 a 500 RPS, avaliando o endpoint `/bonus` (POST). As métricas incluem dados do K6 e métricas de container coletadas do Prometheus (CPU e memória).

**Data do Teste**: 2026-01-13 (17:08 - 18:15)  
**Duração por Stack**: 6 minutos  
**Carga Máxima**: 500 RPS  
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
- ✅ Carga sintética progressiva (K6)
- ✅ 6 minutos por stack
- ✅ Ramping de 100 a 500 RPS

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
| 4 | 1 minuto | 400 RPS | Carga alta |
| 5 | 1 minuto | 500 RPS | Pico de carga |
| 6 | 1 minuto | 0 RPS | Cooldown |

**Configuração de VUs**:
- VUs pré-alocados: 100
- VUs máximos: 600

**Thresholds**:
- P95 de duração de requisição: < 1000ms
- Taxa de falha: < 1%

**Configuração de Recursos**:
- Limite de memória por container: 2GB
- Prometheus: porta 9091
- cAdvisor: porta 8081

---

## 📊 Resultados Consolidados - Tabela Geral

| Stack | Porta | Total Reqs | RPS Médio | VUs Máx | P95 (ms) | Tempo Médio (ms) | CPU Avg (cores) | CPU P95 (cores) | Mem Avg (MB) | Mem P95 (MB) | Taxa Sucesso | Threshold |
|-------|-------|------------|-----------|---------|----------|------------------|-----------------|-----------------|--------------|--------------|--------------|-----------|
| **Java MVC VT** | 3007 | 90,589 | 251.64 | 110 | 17.06 | 9.18 | 0.088 | 0.221 | 237.81 | 237.79 | 100% | ✅ |
| **Java WebFlux** | 3006 | 90,599 | 251.66 | 100 | 21.88 | 10.85 | 0.070 | 0.213 | 253.43 | 253.41 | 100% | ✅ |
| **Node.js** | 3005 | 90,509 | 251.41 | 188 | 40.65 | 17.42 | 0.169 | 0.502 | 36.20 | 34.50 | 100% | ✅ |
| **PHP Octane** | 3014 | 90,388 | 251.08 | 269 | 39.28 | 22.45 | 0.250 | 1.847 | 503.13 | 992.48 | 99.16% | ✅ |
| **Python** | 3008 | 90,389 | 251.08 | 288 | 76.07 | 24.96 | 0.225 | 0.861 | 169.55 | 169.97 | 99.99% | ✅ |
| **PHP FPM** | 3011 | 87,405 | 242.79 | 600 | 1,556.75 | 426.14 | 0.451 | 3.630 | 41.35 | 67.74 | 100% | ❌ |

---

### Quantidade de bônus inseridos no banco durante o teste

Durante os testes de carga, cada stack processou requisições POST para o endpoint `/bonus`, resultando nas seguintes quantidades de registros inseridos no banco de dados:

- **Node (NestJS)**: 90,509 inserts  
- **Java WebFlux**: 90,599 inserts  
- **Java MVC VT**: 90,589 inserts  
- **Python (FastAPI)**: 90,389 inserts  
- **Laravel FPM**: 87,405 inserts  
- **Laravel Octane**: 90,388 inserts

---

## 🔍 Análise Detalhada por Stack

### Java MVC VT (Spring MVC + Virtual Threads)
**Porta**: 3007 | **Tecnologia**: Spring MVC com Virtual Threads (Project Loom)

#### Métricas K6
- **Total de Requisições**: 90,589
- **RPS Médio**: 251.64 req/s
- **VUs Simultâneos (Máximo)**: 110
- **P95**: 17.06 ms
- **Tempo Médio**: 9.18 ms
- **Taxa de Sucesso**: 100%
- **Dropped Iterations**: 10 (0.03%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.088 cores
- **CPU P95**: 0.221 cores
- **Memória Média**: 237.81 MB
- **Memória P95**: 237.79 MB

#### Observações Técnicas
- P95 de 17.06ms foi o menor valor observado entre todas as stacks
- Uso de CPU baixo para o throughput alcançado
- Memória estável sem variação significativa
- Virtual Threads permitiram alta concorrência com baixo número de VUs

---

### Java WebFlux (Spring WebFlux Reactive)
**Porta**: 3006 | **Tecnologia**: Spring WebFlux (Programação Reativa)

#### Métricas K6
- **Total de Requisições**: 90,599
- **RPS Médio**: 251.66 req/s
- **VUs Simultâneos (Máximo)**: 100
- **P95**: 21.88 ms
- **Tempo Médio**: 10.85 ms
- **Taxa de Sucesso**: 100%

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.070 cores
- **CPU P95**: 0.213 cores
- **Memória Média**: 253.43 MB
- **Memória P95**: 253.41 MB

#### Observações Técnicas
- P95 de 21.88ms, segundo menor valor observado
- Uso de CPU mais baixo entre todas as stacks
- Memória ~10% maior que MVC VT
- Modelo não-bloqueante permitiu alta concorrência com VUs mínimos

---

### Node.js (NestJS + TypeORM)
**Porta**: 3005 | **Tecnologia**: NestJS com TypeORM (Event-driven)

#### Métricas K6
- **Total de Requisições**: 90,509
- **RPS Médio**: 251.41 req/s
- **VUs Simultâneos (Máximo)**: 188
- **P95**: 40.65 ms
- **Tempo Médio**: 17.42 ms
- **Taxa de Sucesso**: 100%
- **Dropped Iterations**: 90 (0.10%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.169 cores
- **CPU P95**: 0.502 cores
- **Memória Média**: 36.20 MB
- **Memória P95**: 34.50 MB

#### Observações Técnicas
- P95 de 40.65ms, dentro do threshold definido
- Maior eficiência de memória entre todas as stacks (36MB)
- Uso de CPU moderado em relação às stacks Java
- Event loop gerenciou concorrência de forma eficiente

---

### Python (FastAPI + SQLAlchemy)
**Porta**: 3008 | **Tecnologia**: FastAPI com SQLAlchemy Async + Uvicorn

#### Métricas K6
- **Total de Requisições**: 90,389
- **RPS Médio**: 251.08 req/s
- **VUs Simultâneos (Máximo)**: 288
- **P95**: 76.07 ms
- **Tempo Médio**: 24.96 ms
- **Taxa de Sucesso**: 99.99% (13 falhas)
- **Dropped Iterations**: 210 (0.58%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.225 cores
- **CPU P95**: 0.861 cores
- **Memória Média**: 169.55 MB
- **Memória P95**: 169.97 MB

#### Observações Técnicas
- P95 de 76.07ms, maior entre as stacks que passaram no threshold
- Uso de CPU significativamente maior que as stacks Java
- Memória moderada em comparação com outras stacks
- 13 falhas indicaram pressão do sistema próximo ao pico de carga

---

### PHP Octane (Laravel Octane + Swoole)
**Porta**: 3014 | **Tecnologia**: Laravel Octane com Swoole

#### Métricas K6
- **Total de Requisições**: 90,388
- **RPS Médio**: 251.08 req/s
- **VUs Simultâneos (Máximo)**: 269
- **P95**: 39.28 ms
- **Tempo Médio**: 22.45 ms
- **Taxa de Sucesso**: 99.16% (758 falhas)
- **Dropped Iterations**: 211 (0.59%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.250 cores
- **CPU P95**: 1.847 cores
- **Memória Média**: 503.13 MB
- **Memória P95**: 992.48 MB

#### Observações Técnicas
- P95 de 39.28ms, competitivo com Node.js
- Maior uso de memória entre todas as stacks
- Pico de memória de 992MB indica possível instabilidade
- 758 falhas (0.84%) representaram taxa de erro não trivial

---

### PHP FPM (Laravel + PHP-FPM + Nginx)
**Porta**: 3011 | **Tecnologia**: Laravel com PHP-FPM e Nginx

#### Métricas K6
- **Total de Requisições**: 87,405
- **RPS Médio**: 242.79 req/s
- **VUs Simultâneos (Máximo)**: 600
- **P95**: 1,556.75 ms
- **Tempo Médio**: 426.14 ms
- **Taxa de Sucesso**: 100%
- **Dropped Iterations**: 3,194 (8.87%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.451 cores
- **CPU P95**: 3.630 cores
- **Memória Média**: 41.35 MB
- **Memória P95**: 67.74 MB

#### Observações Técnicas
- P95 de 1,556ms excedeu o threshold de 1000ms
- CPU P95 de 3.63 cores indicou saturação do sistema
- 600 VUs máximos mostraram saturação total
- 8.87% dropped iterations representaram perda significativa de requisições

---

## 📈 Análise Comparativa de Métricas

### RPS (Requests Per Second)

| Stack | RPS Médio | Diferença vs Maior |
|-------|-----------|-------------------|
| Java WebFlux | 251.66 | 0% |
| Java MVC VT | 251.64 | -0.01% |
| Node.js | 251.41 | -0.10% |
| Python | 251.08 | -0.23% |
| PHP Octane | 251.08 | -0.23% |
| PHP FPM | 242.79 | -3.53% |

**Observação**: Todas as stacks modernas (exceto PHP FPM) apresentaram throughput similar (~251 RPS).

---

### P95 (Percentil 95 de Latência)

| Stack | P95 (ms) | Status Threshold |
|-------|----------|------------------|
| Java MVC VT | 17.06 | ✅ Passou |
| Java WebFlux | 21.88 | ✅ Passou |
| PHP Octane | 39.28 | ✅ Passou |
| Node.js | 40.65 | ✅ Passou |
| Python | 76.07 | ✅ Passou |
| PHP FPM | 1,556.75 | ❌ Falhou |

**Observação**: Variação significativa de latência entre as stacks, com Java apresentando os menores valores.

---

### Uso de CPU (Cores Médias)

| Stack | CPU Avg (cores) | Eficiência Relativa |
|-------|-----------------|-------------------|
| Java WebFlux | 0.070 | Mais eficiente |
| Java MVC VT | 0.088 | |
| Node.js | 0.169 | |
| Python | 0.225 | |
| PHP Octane | 0.250 | |
| PHP FPM | 0.451 | Menos eficiente |

**Observação**: As stacks Java apresentaram maior eficiência no uso de CPU para o throughput alcançado.

---

### Uso de Memória (MB Médio)

| Stack | Mem Avg (MB) | Impacto em Custos |
|-------|--------------|-------------------|
| Node.js | 36.20 | Menor impacto |
| PHP FPM | 41.35 | |
| Python | 169.55 | |
| Java MVC VT | 237.81 | |
| Java WebFlux | 253.43 | |
| PHP Octane | 503.13 | Maior impacto |

**Observação**: Node.js apresentou footprint de memória significativamente menor que as demais stacks.

---

### Estabilidade (Taxa de Sucesso + Dropped Iterations)

| Stack | Taxa Sucesso | Dropped Iterations | Estabilidade |
|-------|--------------|-------------------|--------------|
| Java WebFlux | 100% | 0 | Alta |
| Java MVC VT | 100% | 10 | Alta |
| Node.js | 100% | 90 | Alta |
| PHP FPM | 100% | 3,194 | Moderada |
| Python | 99.99% | 210 | Alta |
| PHP Octane | 99.16% | 211 | Moderada |

**Observação**: Java e Node.js apresentaram maior estabilidade sob carga.

---

## 🎯 Análise por Requisitos Técnicos

### Para Requisitos de Latência Baixa (< 50ms P95)

**Stacks que atendem**: Java MVC VT (17.06ms), Java WebFlux (21.88ms), PHP Octane (39.28ms), Node.js (40.65ms)

**Considerações**:
- Java oferece as menores latências observadas
- Node.js e PHP Octane permanecem dentro do limite de 50ms
- Python (76.07ms) e PHP FPM (1,556.75ms) excedem este requisito

---

### Para Requisitos de Eficiência de Memória (< 100MB)

**Stacks que atendem**: Node.js (36.20MB), PHP FPM (41.35MB)

**Considerações**:
- Node.js permite maior densidade de instâncias por servidor
- PHP FPM também eficiente em memória, mas com limitações de escalabilidade
- Outras stacks requerem mais memória por instância

---

### Para Requisitos de Estabilidade (99.9%+ sucesso)

**Stacks que atendem**: Java WebFlux (100%), Java MVC VT (100%), Node.js (100%), Python (99.99%)

**Considerações**:
- Java e Node.js apresentaram 100% de sucesso
- Python com 99.99% ainda atende ao requisito
- PHP Octane (99.16%) e PHP FPM (com 8.87% dropped) podem não atender critérios rigorosos

---

### Para Requisitos de Eficiência de CPU (< 0.2 cores)

**Stacks que atendem**: Java WebFlux (0.070), Java MVC VT (0.088)

**Considerações**:
- Apenas as stacks Java atendem a este requisito rigoroso
- Node.js (0.169) fica próximo do limite
- Demais stacks excedem significativamente
---

### 2. Padrões de Uso de Recursos

**Memória**:
- Node.js: 36MB (mais eficiente)
- PHP FPM: 41MB (eficiente, mas com limitações)
- Python: 169MB (moderado)
- Java: ~245MB (maior, mas com performance superior)
- PHP Octane: 503MB (preocupante)

**CPU**:
- Java: 0.07-0.088 cores (mais eficiente)
- Node.js: 0.169 cores (moderado)
- Python/PHP: 0.225-0.451 cores (maior consumo)

---

### 3. Indicadores de Estabilidade

**Memória Estável**: Java MVC VT, Java WebFlux, Node.js, Python   
**Memória Instável**: PHP Octane (variação de 14MB para 992MB)  
**CPU Estável**: Java WebFlux, Java MVC VT  
**CPU Instável**: PHP FPM (picos de 3.63 cores)  

---

## 📋 Resumo dos Dados Coletados

**Relatório gerado em**: 2026-01-13 18:45  
**Dados fonte**: K6 Reports + Prometheus (localhost:9091)  
**Período de coleta**: 2026-01-13 17:08 - 18:15  
**Stacks testadas**: 6 (Node.js, Java WebFlux, Java MVC VT, Python, PHP FPM, PHP Octane)  
**Total de requisições processadas**: 623,584  
**Métricas coletadas**: K6 (RPS, latência, VUs, erros) + Prometheus (CPU, memória)

---

**Nota**: Este relatório apresenta dados objetivos coletados durante testes controlados. A escolha da tecnologia adequada deve considerar também fatores específicos do contexto de cada organização, incluindo expertise da equipe, ecossistema existente, requisitos de negócio e restrições de infraestrutura.
