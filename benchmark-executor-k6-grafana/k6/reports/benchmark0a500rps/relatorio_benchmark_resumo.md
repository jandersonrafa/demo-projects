# 📊 Relatório de Benchmark - Análise Técnica Comparativa de Performance

## 📋 Sumário Executivo

Este relatório apresenta uma análise técnica comparativa de performance de **6 stacks tecnológicas** testadas sob carga progressiva durante 6 minutos cada. Os testes foram executados usando K6 com ramping de 100 a 500 RPS, avaliando o endpoint `/bonus` (POST). As métricas incluem dados do K6 e métricas de container coletadas do Prometheus (CPU e memória).

**Data do Teste**: 2026-01-13 (17:01 - 18:10)  
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
- ✅ 7 minutos por stack
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

| Stack | Porta | K6 Reqs Sucesso | K6 Reqs Erro | RPS Médio | VUs Máx | P95 (ms) | Tempo Médio (ms) | CPU Avg (cores) | CPU P95 (cores) | Mem Avg (MB) | Mem P95 (MB) | Taxa Sucesso | Threshold |
|-------|-------|------------|--------------|-----------|---------|----------|------------------|-----------------|-----------------|--------------|--------------|--------------|-----------|
| **Java MVC VT** | 3007 | 90,589 | 10 | 251.64 | 110 | 17.06 | 9.18 | 0.349 | 0.581 | 225.19 | 239.32 | 99.99% | ✅ |
| **Java WebFlux** | 3006 | 90,599 | 0 | 251.66 | 100 | 21.88 | 10.85 | 0.275 | 0.362 | 248.86 | 261.84 | 100.00% | ✅ |
| **Node.js** | 3005 | 90,509 | 90 | 251.41 | 188 | 40.65 | 17.42 | 0.466 | 0.896 | 78.87 | 116.82 | 99.90% | ✅ |
| **PHP Octane** | 3014 | 90,388 | 211 | 251.08 | 269 | 39.28 | 22.45 | 0.729 | 3.212 | 471.57 | 997.49 | 99.77% | ✅ |
| **Python** | 3008 | 90,389 | 210 | 251.08 | 288 | 76.07 | 24.96 | 0.695 | 1.719 | 165.72 | 170.82 | 99.77% | ✅ |
| **PHP FPM** | 3011 | 87,405 | 3,194 | 242.79 | 600 | 1,556.75 | 426.14 | 1.370 | 6.174 | 41.69 | 73.67 | 96.47% | ❌ |

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
- **K6 Reqs Sucesso**: 90,589
- **K6 Reqs Erro**: 10
- **RPS Médio**: 251.64 req/s
- **VUs Simultâneos (Máximo)**: 110
- **P95**: 17.06 ms
- **Tempo Médio**: 9.18 ms
- **Taxa de Sucesso**: 99.99%
- **K6 Reqs Erro**: 10 (0.01%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.349 cores
- **CPU P95**: 0.581 cores
- **Memória Média**: 225.19 MB
- **Memória P95**: 239.32 MB

#### Observações Técnicas
- P95 de 17.06ms, menor valor observado
- Uso de CPU baixo para o throughput alcançado
- Memória estável sem variação significativa
- Virtual Threads permitiram alta concorrência com baixo número de VUs

---

### Java WebFlux (Spring WebFlux + WebFlux.fn)
**Porta**: 3006 | **Tecnologia**: Spring WebFlux com programação reativa

#### Métricas K6
- **K6 Reqs Sucesso**: 90,599
- **K6 Reqs Erro**: 0
- **RPS Médio**: 251.66 req/s
- **VUs Simultâneos (Máximo)**: 100
- **P95**: 21.88 ms
- **Tempo Médio**: 10.85 ms
- **Taxa de Sucesso**: 100.00%
- **K6 Reqs Erro**: 0 (0.00%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.275 cores
- **CPU P95**: 0.362 cores
- **Memória Média**: 248.86 MB
- **Memória P95**: 261.84 MB

#### Observações Técnicas
- P95 de 21.88ms, segundo menor valor observado
- Uso de CPU mais baixo entre todas as stacks
- Memória ~17% maior que MVC tradicional
- Modelo não-bloqueante permitiu alta concorrência com VUs mínimos

---

### Node.js (NestJS + TypeScript)
**Porta**: 3005 | **Tecnologia**: NestJS com TypeScript

#### Métricas K6
- **K6 Reqs Sucesso**: 90,509
- **K6 Reqs Erro**: 90
- **RPS Médio**: 251.41 req/s
- **VUs Simultâneos (Máximo)**: 188
- **P95**: 40.65 ms
- **Tempo Médio**: 17.42 ms
- **Taxa de Sucesso**: 99.90%
- **K6 Reqs Erro**: 90 (0.10%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.466 cores
- **CPU P95**: 0.896 cores
- **Memória Média**: 78.87 MB
- **Memória P95**: 116.82 MB

#### Observações Técnicas
- P95 de 40.65ms, dentro do threshold definido
- Boa eficiência de memória entre todas as stacks (78.87MB)
- Uso de CPU moderado em relação às stacks Java
- Event loop gerenciou concorrência de forma eficiente

---

### Python (FastAPI + SQLAlchemy)
**Porta**: 3008 | **Tecnologia**: FastAPI com SQLAlchemy Async + Uvicorn

#### Métricas K6
- **K6 Reqs Sucesso**: 90,389
- **K6 Reqs Erro**: 210
- **RPS Médio**: 251.08 req/s
- **VUs Simultâneos (Máximo)**: 288
- **P95**: 76.07 ms
- **Tempo Médio**: 24.96 ms
- **Taxa de Sucesso**: 99.77%
- **K6 Reqs Erro**: 210 (0.24%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.695 cores
- **CPU P95**: 1.719 cores
- **Memória Média**: 165.72 MB
- **Memória P95**: 170.82 MB

#### Observações Técnicas
- P95 de 76.07ms, maior entre as stacks que passaram no threshold
- Uso de CPU maior comparado outras stacks
- Memória moderada em comparação com outras stacks
- 210 falhas nas chamadas, indicando pressão do sistema próximo ao pico de carga
- Teste variando de 4 para 6 workers tem potencial de chegar proximo a p95 com 43ms

---

### PHP Octane (Laravel Octane + Swoole)
**Porta**: 3014 | **Tecnologia**: Laravel Octane com Swoole

#### Métricas K6
- **K6 Reqs Sucesso**: 90,388
- **K6 Reqs Erro**: 211
- **RPS Médio**: 251.08 req/s
- **VUs Simultâneos (Máximo)**: 269
- **P95**: 39.28 ms
- **Tempo Médio**: 22.45 ms
- **Taxa de Sucesso**: 99.77%
- **K6 Reqs Erro**: 211 (0.24%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.729 cores
- **CPU P95**: 3.212 cores
- **Memória Média**: 471.57 MB
- **Memória P95**: 997.49 MB

#### Observações Técnicas
- P95 de 39.28ms, competitivo com Node.js
- Maior uso de memória entre todas as stacks
- Pico de memória de 997MB indica possível instabilidade
- 211 falhas representaram taxa de erro não trivial

---

### Laravel FPM (Nginx + PHP-FPM)
**Porta**: 3011 | **Tecnologia**: Nginx + PHP-FPM

#### Métricas K6
- **K6 Reqs Sucesso**: 87,405
- **K6 Reqs Erro**: 3,194
- **RPS Médio**: 242.79 req/s
- **VUs Simultâneos (Máximo)**: 600
- **P95**: 1,556.75 ms
- **Tempo Médio**: 426.14 ms
- **Taxa de Sucesso**: 100.00%
- **K6 Reqs Erro**: 3,194 (3.66%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 1.370 cores
- **CPU P95**: 6.174 cores
- **Memória Média**: 41.69 MB
- **Memória P95**: 73.67 MB

#### Observações Técnicas
- P95 de 1,556ms excedeu o threshold de 1000ms
- CPU P95 de 6.174 cores indicou saturação extrema do sistema
- 600 VUs máximos mostraram saturação total
- 3,194 dropped iterations representaram perda significativa de requisições

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
| Java WebFlux | 0.275 | Mais eficiente |
| Java MVC VT | 0.349 | |
| Node.js | 0.466 | |
| PHP Octane | 0.729 | |
| Python | 0.695 | |
| PHP FPM | 1.370 | Menos eficiente |

**Observação**: As stacks Java apresentaram maior eficiência no uso de CPU para o throughput alcançado.

---

### Uso de Memória (MB Médio)

| Stack | Mem Avg (MB) | Impacto em Custos |
|-------|--------------|-------------------|
| PHP FPM | 41.69 | Menor impacto |
| Node.js | 78.87 | |
| Python | 165.72 | |
| Java MVC VT | 225.19 | |
| Java WebFlux | 248.86 | |
| PHP Octane | 471.57 | Maior impacto |

**Observação**: PHP FPM apresentou footprint de memória menor que as demais stacks neste teste.

---

### Estabilidade (Taxa de Sucesso + Dropped Iterations)

| Stack | Taxa Sucesso | K6 Reqs Erro | Estabilidade |
|-------|--------------|-------------------|--------------|
| Java WebFlux | 100% | 0 | Alta |
| Java MVC VT | 99.99% | 10 | Alta |
| Node.js | 99.90% | 90 | Alta |
| Python | 99.77% | 210 | Alta |
| PHP Octane | 99.77% | 211 | Moderada |
| PHP FPM | 96.47% | 3,194 | Moderada |

**Observação**: Java e Node.js apresentaram maior estabilidade sob carga.

---

## 🎯 Análise por Requisitos Técnicos

### Para Requisitos de Latência Baixa (< 50ms P95)

**Stacks que atendem**: Java MVC VT (17.06ms), Java WebFlux (21.88ms), PHP Octane (39.28ms), Node.js (40.65ms)

**Considerações**:
- Java oferece as menores latências observadas
- Node.js e PHP Octane permanecem dentro do limite de 50ms
- Python (76.07ms), PHP FPM (1,556.75ms) excedem este requisito

---

### Para Requisitos de Eficiência de Memória (< 100MB)

**Stacks que atendem**: PHP FPM (41.69MB), Node.js (78.87MB)

**Considerações**:
- PHP FPM permite maior densidade de instâncias por servidor
- Node.js também eficiente em memória, mas com melhor performance
- Outras stacks requerem mais memória por instância

---

### Para Requisitos de Estabilidade (99.9%+ sucesso)

**Stacks que atendem**: Java WebFlux (100%), Java MVC VT (99.99%), Node.js (99.90%), Python (99.77%)

**Considerações**:
- Java e Node.js apresentaram > 99.9% de sucesso
- Python com 99.77% ainda atende ao requisito
- PHP Octane (99.77%) melhorou sua avaliação com esta métrica
- PHP FPM (96.47%) falha neste requisito devido aos drops

---

### Para Requisitos de Eficiência de CPU (< 0.5 cores)

**Stacks que atendem**: Java WebFlux (0.275), Java MVC VT (0.349), Node.js (0.466)

**Considerações**:
- As stacks Java atendem a este requisito com folga
- Node.js fica próximo do limite mas ainda eficiente
- Demais stacks excedem significativamente

---

## 📋 Resumo dos Dados Coletados

**Relatório gerado em**: 2026-01-14 17:20  
**Dados fonte**: K6 Reports + Prometheus (localhost:9091)  
**Período de coleta**: 2026-01-13 17:01 - 18:10  
**Stacks testadas**: 6 (Node.js, Java WebFlux, Java MVC VT, Python, PHP FPM, PHP Octane)  
**Total de requisições processadas**: 623,584  
**Métricas coletadas**: K6 (RPS, latência, VUs, erros) + Prometheus (CPU, memória)
**Janela de coleta**: 7 minutos por stack (420 segundos)

---

**Nota**: Este relatório apresenta dados objetivos coletados durante testes controlados. A escolha da tecnologia adequada deve considerar também fatores específicos do contexto de cada organização, incluindo expertise da equipe, ecossistema existente, requisitos de negócio e restrições de infraestrutura.
