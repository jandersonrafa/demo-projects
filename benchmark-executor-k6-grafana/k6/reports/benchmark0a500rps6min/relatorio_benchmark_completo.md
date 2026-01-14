# 📊 Relatório Final de Benchmark - Análise Completa de Performance

## 📋 Sumário Executivo

Este relatório apresenta uma análise detalhada de performance de **8 stacks tecnológicas** testadas sob carga progressiva durante 6 minutos cada. Os testes foram executados usando K6 com ramping de 100 a 500 RPS, avaliando o endpoint `/bonus` (POST). As métricas incluem dados do K6 e métricas de container coletadas do Prometheus (CPU e memória).

**Data do Teste**: 2026-01-13 (17:08 - 18:15)  
**Duração por Stack**: 6 minutos  
**Carga Máxima**: 500 RPS  
**Endpoint Testado**: POST `/bonus`

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
| 5 | 1 minuto | 500 RPS | 🎯 Pico de carga |
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
| **Java MVC** | 3016 | 90,599 | 251.66 | 100 | 13.37 | 7.84 | 0.059 | 0.231 | 228.66 | 228.59 | 100% | ✅ |
| **Java MVC VT** | 3007 | 90,589 | 251.64 | 110 | 17.06 | 9.18 | 0.088 | 0.221 | 237.81 | 237.79 | 100% | ✅ |
| **Java WebFlux** | 3006 | 90,599 | 251.66 | 100 | 21.88 | 10.85 | 0.070 | 0.213 | 253.43 | 253.41 | 100% | ✅ |
| **Node.js** | 3005 | 90,509 | 251.41 | 188 | 40.65 | 17.42 | 0.169 | 0.502 | 36.20 | 34.50 | 100% | ✅ |
| **PHP Octane** | 3014 | 90,388 | 251.08 | 269 | 39.28 | 22.45 | 0.250 | 1.847 | 503.13 | 992.48 | 99.16% | ✅ |
| **Python** | 3008 | 90,389 | 251.08 | 288 | 76.07 | 24.96 | 0.225 | 0.861 | 169.55 | 169.97 | 99.99% | ✅ |
| **PHP FPM** | 3011 | 87,405 | 242.79 | 600 | 1,556.75 | 426.14 | 0.451 | 3.630 | 41.35 | 67.74 | 100% | ❌ |
| **PHP CLI** | 3009 | 23,106 | 63.26 | 600 | 9,984.36 | 7,796.86 | 0.459 | 2.060 | 47.08 | 70.54 | 100% | ❌ |

---

### Quantidade de bônus inseridos no banco durante o teste

Durante os testes de carga, cada stack processou requisições POST para o endpoint `/bonus`, resultando nas seguintes quantidades de registros inseridos no banco de dados:

- **Node (NestJS)**: 90509 mil inserts  
- **Java WebFlux**: 90599 mil inserts  
- **Java MVC VT**: 90589 mil inserts  
- **Java MVC**: 90599 mil inserts  
- **Python (FastAPI)**: 90376 mil inserts  
- **Laravel (CLI)**: 22642 mil inserts  
- **Laravel FPM**: 87405 mil inserts  
- **Laravel Octane**: 89630 mil inserts

---

## 🔍 Análise Detalhada por Stack

### 🥇 1º Lugar: Java MVC (Spring MVC Tradicional)
**Porta**: 3016 | **Tecnologia**: Spring MVC com Thread Pool tradicional

#### Métricas K6
- **Total de Requisições**: 90,599
- **RPS Médio**: 251.66 req/s
- **VUs Simultâneos (Máximo)**: 100
- **P95**: 13.37 ms ⭐ (Melhor)
- **P90**: 10.57 ms
- **Tempo Médio**: 7.84 ms ⭐ (Melhor)
- **Tempo Mediano**: 6.12 ms
- **Taxa de Sucesso**: 100%
- **Dropped Iterations**: 0

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.059 cores ⭐ (Mais eficiente)
- **CPU P95**: 0.231 cores
- **Memória Média**: 228.66 MB
- **Memória P95**: 228.59 MB
- **Estabilidade de Memória**: Excelente (variação mínima)

#### Justificativa das Métricas
- **Melhor P95 (13.37ms)**: Latência mais consistente de todas as stacks
- **Menor CPU médio (0.059 cores)**: Processamento extremamente eficiente
- **Memória estável (~229MB)**: Sem vazamentos ou picos
- **VUs mínimos (100)**: Alta eficiência de concorrência

#### Análise
Java MVC tradicional surpreendeu com a melhor performance geral. O modelo de thread pool, quando bem configurado com connection pooling (500 conexões), demonstra eficiência excepcional para workloads I/O-bound.

---

### 🥈 2º Lugar: Java MVC VT (Spring MVC + Virtual Threads)
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

#### Justificativa das Métricas
- **Excelente P95 (17.06ms)**: Segundo melhor resultado
- **CPU eficiente**: Apenas 49% mais CPU que MVC tradicional
- **Memória estável**: Virtual Threads não adicionam overhead significativo
- **VUs baixos (110)**: Virtual Threads permitem alta concorrência com poucos recursos

#### Análise
Virtual Threads demonstraram performance quase idêntica ao MVC tradicional, validando o Project Loom como evolução natural do Java para alta concorrência.

---

### 🥉 3º Lugar: Java WebFlux (Spring WebFlux Reactive)
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
- **Memória Média**: 253.43 MB (maior que MVC/VT)
- **Memória P95**: 253.41 MB

#### Justificativa das Métricas
- **Boa P95 (21.88ms)**: Dentro do esperado para modelo reativo
- **CPU eficiente**: Segundo melhor em uso de CPU
- **Memória maior**: Overhead do modelo reativo (~10% mais que MVC)
- **VUs mínimos (100)**: Modelo não-bloqueante permite alta concorrência

#### Análise
WebFlux apresentou excelente performance, mas com overhead de memória. O modelo reativo é ideal quando se precisa de alta concorrência com I/O não-bloqueante.

---

### 4º Lugar: Node.js (NestJS + TypeORM)
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
- **Memória Média**: 36.20 MB ⭐ (Menor memória)
- **Memória P95**: 34.50 MB

#### Justificativa das Métricas
- **P95 aceitável (40.65ms)**: Dentro do threshold
- **CPU moderado**: 2.9x mais que Java MVC
- **Memória mínima (36MB)**: Node.js é extremamente eficiente em memória
- **VUs moderados (188)**: Event loop gerencia bem a concorrência

#### Análise
Node.js demonstrou excelente eficiência de memória e boa performance geral. A arquitetura event-driven é adequada para I/O-bound, mas tem overhead de CPU comparado ao Java.

---

### 5º Lugar: Python (FastAPI + SQLAlchemy)
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

#### Justificativa das Métricas
- **P95 elevado (76.07ms)**: Overhead do Python
- **CPU alto**: 3.8x mais que Java MVC
- **Memória moderada**: 169MB é razoável
- **VUs altos (288)**: Python precisa de mais VUs para manter throughput
- **13 falhas**: Indica pressão no sistema próximo ao pico

#### Análise
FastAPI com async/await demonstrou performance razoável, mas Python tem limitações inerentes de performance. As 13 falhas e CPU elevado indicam que o sistema começou a sentir pressão em 500 RPS.

---

### 6º Lugar: PHP Octane (Laravel Octane + Swoole)
**Porta**: 3014 | **Tecnologia**: Laravel Octane com Swoole

#### Métricas K6
- **Total de Requisições**: 90,388
- **RPS Médio**: 251.08 req/s
- **VUs Simultâneos (Máximo)**: 269
- **P95**: 39.28 ms
- **Tempo Médio**: 22.45 ms
- **Taxa de Sucesso**: 99.16% (758 falhas) ⚠️
- **Dropped Iterations**: 211 (0.59%)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.250 cores
- **CPU P95**: 1.847 cores
- **Memória Média**: 503.13 MB
- **Memória P95**: 992.48 MB ⚠️ (Pico alto)

#### Justificativa das Métricas
- **P95 bom (39.28ms)**: Competitivo com Node.js
- **CPU moderado-alto**: Swoole tem overhead
- **Memória alta e instável**: Pico de 992MB indica possível leak ou pool mal configurado
- **758 falhas (0.84%)**: Instabilidade sob carga de pico
- **Variação de memória**: De 14MB a 995MB indica problema

#### Análise
PHP Octane mostrou que PHP moderno pode ser performático, mas a taxa de erro de 0.84% e o pico de memória de 992MB indicam problemas de estabilidade. Provavelmente relacionado a configurações de pool de conexões ou limites do Swoole.

---

### 7º Lugar: PHP FPM (Laravel + PHP-FPM + Nginx)
**Porta**: 3011 | **Tecnologia**: Laravel com PHP-FPM e Nginx

#### Métricas K6
- **Total de Requisições**: 87,405 (3.5% menos)
- **RPS Médio**: 242.79 req/s
- **VUs Simultâneos (Máximo)**: 600 ⚠️ (Saturado)
- **P95**: 1,556.75 ms ❌ (Falhou threshold)
- **Tempo Médio**: 426.14 ms
- **Taxa de Sucesso**: 100%
- **Dropped Iterations**: 3,194 (8.87%) ❌

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.451 cores
- **CPU P95**: 3.630 cores ❌ (Pico muito alto)
- **Memória Média**: 41.35 MB
- **Memória P95**: 67.74 MB

#### Justificativa das Métricas
- **P95 muito alto (1,556ms)**: Falhou no threshold de 1000ms
- **CPU P95 altíssimo (3.63 cores)**: Picos indicam saturação
- **VUs máximos (600)**: Sistema completamente saturado
- **8.87% dropped iterations**: Alto número de requisições descartadas
- **Mediana baixa (35.56ms)**: Muitas requisições rápidas, mas outliers severos

#### Análise
PHP-FPM tradicional mostrou limitações significativas. O modelo de processos não escala bem para 500 RPS sem configuração extensiva de workers e pool de conexões. O fato de atingir 600 VUs indica saturação total.

---

### 8º Lugar: PHP CLI (Laravel CLI Server)
**Porta**: 3009 | **Tecnologia**: Laravel com servidor built-in do PHP

#### Métricas K6
- **Total de Requisições**: 23,106 ❌ (74.5% menos)
- **RPS Médio**: 63.26 req/s ❌ (4x menor)
- **VUs Simultâneos (Máximo)**: 600 ⚠️ (Saturado)
- **P95**: 9,984.36 ms ❌ (9.98 segundos!)
- **Tempo Médio**: 7,796.86 ms (7.8 segundos!)
- **Taxa de Sucesso**: 100% (das que completaram)
- **Dropped Iterations**: 67,493 ❌ (184.78 req/s)

#### Métricas de Container (Prometheus)
- **CPU Médio**: 0.459 cores
- **CPU P95**: 2.060 cores
- **Memória Média**: 47.08 MB
- **Memória P95**: 70.54 MB

#### Justificativa das Métricas
- **Throughput catastrófico**: Apenas 25% das requisições processadas
- **Latências absurdas**: P95 de quase 10 segundos
- **74.5% dropped iterations**: Maioria das requisições descartadas
- **VUs máximos (600)**: Sistema completamente saturado
- **CPU/Memória moderados**: Recursos não são o problema, é a arquitetura

#### Análise
O servidor built-in do PHP **NÃO deve NUNCA ser usado em produção**. O servidor single-threaded não consegue lidar com concorrência. Este resultado serve como baseline negativo.

---

## 📈 Análise Comparativa de Métricas

### RPS (Requests Per Second)
**Justificativa**: RPS mede o throughput - quantas requisições o sistema processa por segundo. É a métrica mais importante para avaliar capacidade de carga.

| Stack | RPS Médio | % vs Melhor | Classificação |
|-------|-----------|-------------|---------------|
| Java WebFlux | 251.66 | 100% | 🥇 |
| Java MVC | 251.66 | 100% | 🥇 |
| Java MVC VT | 251.64 | 99.99% | 🥈 |
| Node.js | 251.41 | 99.90% | 🥉 |
| Python | 251.08 | 99.77% | 4º |
| PHP Octane | 251.08 | 99.77% | 4º |
| PHP FPM | 242.79 | 96.47% | 6º |
| PHP CLI | 63.26 | 25.13% | 8º ❌ |

**Análise**: Todas as stacks modernas (exceto PHP CLI e FPM) conseguiram throughput similar (~251 RPS), demonstrando que o gargalo estava no teste K6, não nas aplicações.

---

### P95 (Percentil 95 de Latência)
**Justificativa**: P95 mostra que 95% das requisições foram mais rápidas que este valor. É crucial para SLA e experiência do usuário.

| Stack | P95 (ms) | vs Java MVC | Classificação |
|-------|----------|-------------|---------------|
| Java MVC | 13.37 | 1.00x | 🟢 Excelente |
| Java MVC VT | 17.06 | 1.28x | 🟢 Excelente |
| Java WebFlux | 21.88 | 1.64x | 🟢 Excelente |
| PHP Octane | 39.28 | 2.94x | 🟢 Bom |
| Node.js | 40.65 | 3.04x | 🟢 Bom |
| Python | 76.07 | 5.69x | 🟡 Aceitável |
| PHP FPM | 1,556.75 | 116.47x | 🔴 Ruim |
| PHP CLI | 9,984.36 | 746.88x | 🔴 Inaceitável |

**Análise**: Java domina em latência P95. PHP CLI é 747x mais lento que Java MVC!

---

### Uso de CPU (Cores Médias)
**Justificativa**: CPU médio indica eficiência de processamento. Menos CPU para mesmo throughput = mais eficiente.

| Stack | CPU Avg (cores) | vs Java MVC | Eficiência |
|-------|-----------------|-------------|------------|
| Java MVC | 0.059 | 1.00x | ⭐⭐⭐⭐⭐ |
| Java WebFlux | 0.070 | 1.19x | ⭐⭐⭐⭐⭐ |
| Java MVC VT | 0.088 | 1.49x | ⭐⭐⭐⭐ |
| Node.js | 0.169 | 2.86x | ⭐⭐⭐ |
| Python | 0.225 | 3.81x | ⭐⭐⭐ |
| PHP Octane | 0.250 | 4.24x | ⭐⭐ |
| PHP FPM | 0.451 | 7.64x | ⭐ |
| PHP CLI | 0.459 | 7.78x | ⭐ |

**Análise**: Java é 3-8x mais eficiente em CPU que outras stacks. Node.js é surpreendentemente eficiente para uma linguagem interpretada.

---

### Uso de CPU P95 (Picos de CPU)
**Justificativa**: CPU P95 mostra picos de uso. Picos muito altos indicam saturação ou ineficiência sob carga.

| Stack | CPU P95 (cores) | Estabilidade |
|-------|-----------------|--------------|
| Java WebFlux | 0.213 | ⭐⭐⭐⭐⭐ Excelente |
| Java MVC VT | 0.221 | ⭐⭐⭐⭐⭐ Excelente |
| Java MVC | 0.231 | ⭐⭐⭐⭐⭐ Excelente |
| Node.js | 0.502 | ⭐⭐⭐⭐ Bom |
| Python | 0.861 | ⭐⭐⭐ Aceitável |
| PHP Octane | 1.847 | ⭐⭐ Moderado |
| PHP CLI | 2.060 | ⭐ Ruim |
| PHP FPM | 3.630 | ⭐ Muito Ruim |

**Análise**: Java mantém CPU estável mesmo sob pico. PHP FPM tem picos de 3.63 cores, indicando saturação.

---

### Uso de Memória (MB Médio)
**Justificativa**: Memória média indica footprint da aplicação. Menos memória = mais instâncias por servidor.

| Stack | Mem Avg (MB) | Eficiência | Custo/Instância |
|-------|--------------|------------|-----------------|
| Node.js | 36.20 | ⭐⭐⭐⭐⭐ | Muito Baixo |
| PHP FPM | 41.35 | ⭐⭐⭐⭐⭐ | Muito Baixo |
| PHP CLI | 47.08 | ⭐⭐⭐⭐ | Baixo |
| Python | 169.55 | ⭐⭐⭐ | Moderado |
| Java MVC | 228.66 | ⭐⭐ | Moderado-Alto |
| Java MVC VT | 237.81 | ⭐⭐ | Moderado-Alto |
| Java WebFlux | 253.43 | ⭐⭐ | Alto |
| PHP Octane | 503.13 | ⭐ | Muito Alto |

**Análise**: Node.js é campeão em eficiência de memória (36MB). Java usa ~230MB mas entrega melhor performance. PHP Octane usa 503MB em média, o que é preocupante.

---

### Uso de Memória P95 (Picos de Memória)
**Justificativa**: Memória P95 mostra picos. Picos muito altos podem indicar memory leaks ou pool mal configurado.

| Stack | Mem P95 (MB) | Variação | Estabilidade |
|-------|--------------|----------|--------------|
| Node.js | 34.50 | Estável | ⭐⭐⭐⭐⭐ |
| PHP FPM | 67.74 | Moderada | ⭐⭐⭐⭐ |
| PHP CLI | 70.54 | Moderada | ⭐⭐⭐⭐ |
| Python | 169.97 | Estável | ⭐⭐⭐⭐⭐ |
| Java MVC | 228.59 | Estável | ⭐⭐⭐⭐⭐ |
| Java MVC VT | 237.79 | Estável | ⭐⭐⭐⭐⭐ |
| Java WebFlux | 253.41 | Estável | ⭐⭐⭐⭐⭐ |
| PHP Octane | 992.48 | ⚠️ ALTA | ⭐ Ruim |

**Análise**: PHP Octane tem pico de 992MB (quase 1GB!), indicando possível memory leak ou pool mal configurado. Variação de 14MB a 995MB é alarmante.

---

### Eficiência de Recursos (VUs Necessários)
**Justificativa**: VUs indica quantos usuários virtuais foram necessários para gerar a carga. Menos VUs = mais eficiente.

| Stack | VUs Máx | Eficiência | RPS/VU |
|-------|---------|------------|--------|
| Java WebFlux | 100 | ⭐⭐⭐⭐⭐ | 2.52 |
| Java MVC | 100 | ⭐⭐⭐⭐⭐ | 2.52 |
| Java MVC VT | 110 | ⭐⭐⭐⭐⭐ | 2.29 |
| Node.js | 188 | ⭐⭐⭐⭐ | 1.34 |
| PHP Octane | 269 | ⭐⭐⭐ | 0.93 |
| Python | 288 | ⭐⭐⭐ | 0.87 |
| PHP FPM | 600 | ⭐ | 0.40 |
| PHP CLI | 600 | ⭐ | 0.11 |

**Análise**: Java processa 2.52 RPS por VU. PHP CLI processa apenas 0.11 RPS por VU (23x menos eficiente).

---

### Confiabilidade (Taxa de Sucesso)
**Justificativa**: Confiabilidade é crítica. Uma stack rápida mas instável é inútil em produção.

| Stack | Sucesso | Erro | Dropped | Confiabilidade |
|-------|---------|------|---------|----------------|
| Java MVC | 100% | 0% | 0 | ⭐⭐⭐⭐⭐ |
| Java WebFlux | 100% | 0% | 0 | ⭐⭐⭐⭐⭐ |
| Java MVC VT | 100% | 0% | 10 | ⭐⭐⭐⭐⭐ |
| Node.js | 100% | 0% | 90 | ⭐⭐⭐⭐⭐ |
| PHP FPM | 100% | 0% | 3,194 | ⭐⭐⭐ |
| PHP CLI | 100% | 0% | 67,493 | ⭐ |
| Python | 99.99% | 0.01% | 210 | ⭐⭐⭐⭐ |
| PHP Octane | 99.16% | 0.84% | 211 | ⭐⭐⭐ |

**Análise**: Java e Node.js têm 100% de sucesso. PHP Octane teve 758 falhas (0.84%). PHP CLI descartou 74.5% das requisições.

---

## 🏆 Rankings Finais

### Por Performance Pura (Latência P95)
1. 🥇 **Java MVC** - 13.37ms
2. 🥈 **Java MVC VT** - 17.06ms
3. 🥉 **Java WebFlux** - 21.88ms
4. **PHP Octane** - 39.28ms
5. **Node.js** - 40.65ms
6. **Python** - 76.07ms
7. **PHP FPM** - 1,556.75ms ❌
8. **PHP CLI** - 9,984.36ms ❌

### Por Eficiência de CPU
1. 🥇 **Java MVC** - 0.059 cores
2. 🥈 **Java WebFlux** - 0.070 cores
3. 🥉 **Java MVC VT** - 0.088 cores
4. **Node.js** - 0.169 cores
5. **Python** - 0.225 cores
6. **PHP Octane** - 0.250 cores
7. **PHP FPM** - 0.451 cores
8. **PHP CLI** - 0.459 cores

### Por Eficiência de Memória
1. 🥇 **Node.js** - 36.20 MB
2. 🥈 **PHP FPM** - 41.35 MB
3. 🥉 **PHP CLI** - 47.08 MB
4. **Python** - 169.55 MB
5. **Java MVC** - 228.66 MB
6. **Java MVC VT** - 237.81 MB
7. **Java WebFlux** - 253.43 MB
8. **PHP Octane** - 503.13 MB ⚠️

### Por Estabilidade de Memória
1. 🥇 **Node.js** - 34.50 MB P95 (estável)
2. 🥈 **Java MVC** - 228.59 MB P95 (estável)
3. 🥉 **Java MVC VT** - 237.79 MB P95 (estável)
4. **Java WebFlux** - 253.41 MB P95 (estável)
5. **Python** - 169.97 MB P95 (estável)
6. **PHP FPM** - 67.74 MB P95
7. **PHP CLI** - 70.54 MB P95
8. **PHP Octane** - 992.48 MB P95 ❌ (instável)

### Por Confiabilidade
1. 🥇 **Java MVC** - 100%, 0 dropped
2. 🥇 **Java WebFlux** - 100%, 0 dropped
3. 🥈 **Java MVC VT** - 100%, 10 dropped
4. 🥉 **Node.js** - 100%, 90 dropped
5. **Python** - 99.99%, 210 dropped
6. **PHP Octane** - 99.16%, 211 dropped
7. **PHP FPM** - 100%, 3,194 dropped
8. **PHP CLI** - 100%, 67,493 dropped ❌

### Ranking Geral (Ponderado)
Considerando performance, eficiência, estabilidade e confiabilidade:

1. 🥇 **Java MVC** - Campeão absoluto
2. 🥈 **Java MVC VT** - Excelente em tudo
3. 🥉 **Java WebFlux** - Ótima performance reativa
4. **Node.js** - Melhor em memória, bom em performance
5. **Python** - Performance aceitável, algumas falhas
6. **PHP Octane** - Performance boa, mas instável
7. **PHP FPM** - Problemas de escalabilidade
8. **PHP CLI** - Não usar em produção

---

## 💡 Recomendações Baseadas em Dados

### Para Produção de Alta Performance
**Recomendado**: Java MVC, Java MVC VT, ou Java WebFlux

**Justificativa**:
- ✅ Latências P95 < 22ms (13-22ms)
- ✅ 100% de confiabilidade
- ✅ CPU eficiente (0.059-0.088 cores)
- ✅ Memória estável (~230-253MB)
- ✅ Throughput máximo com VUs mínimos (100-110)

**Quando usar cada um**:
- **Java MVC**: Melhor performance absoluta, ideal para APIs REST tradicionais
- **Java MVC VT**: Futuro do Java, performance quase idêntica ao MVC, código mais simples
- **Java WebFlux**: Quando precisa de streaming reativo ou integração com sistemas reativos

---

### Para Desenvolvimento Rápido com Performance Aceitável
**Recomendado**: Node.js (NestJS)

**Justificativa**:
- ✅ Latência P95 aceitável (40.65ms)
- ✅ 100% de confiabilidade
- ✅ Memória mínima (36MB) - permite mais instâncias
- ✅ Ecossistema rico e produtividade alta
- ✅ CPU moderado (0.169 cores)

**Quando usar**:
- Equipe com expertise em JavaScript/TypeScript
- Prototipagem rápida
- Aplicações com requisitos de performance moderados (< 100ms P95)
- Quando custo de memória é crítico

---

### Para Aplicações Python
**Recomendado**: FastAPI com async/await (com ressalvas)

**Justificativa**:
- ⚠️ Latência P95 elevada (76.07ms)
- ⚠️ 13 falhas em 90k requisições (99.99% sucesso)
- ⚠️ CPU alto (0.225 cores - 3.8x mais que Java)
- ✅ Memória moderada (169MB)

**Quando usar**:
- Equipe com expertise em Python
- Aplicações com requisitos de performance moderados
- Quando ecossistema Python é necessário (ML, Data Science)

**Otimizações necessárias**:
- Ajustar pool de conexões do banco
- Considerar usar Gunicorn com múltiplos workers
- Monitorar e otimizar queries do SQLAlchemy
- Para microsserviços críticos, considerar Rust/Go

---

### Para PHP Moderno
**Recomendado**: PHP Octane (com otimizações CRÍTICAS)

**Justificativa**:
- ✅ Latência P95 competitiva (39.28ms)
- ❌ 758 falhas (99.16% sucesso) - INACEITÁVEL
- ❌ Memória instável (14MB → 992MB) - CRÍTICO
- ⚠️ CPU moderado-alto (0.250 cores)

**Otimizações OBRIGATÓRIAS antes de produção**:
1. **Investigar memory leak**: Pico de 992MB é alarmante
2. **Ajustar pool de conexões**: Provavelmente causa das 758 falhas
3. **Configurar limites do Swoole**: Workers, max requests, etc.
4. **Monitorar memória**: Implementar health checks e restart automático
5. **Load testing extensivo**: Validar estabilidade em produção

**Quando usar**:
- Equipe com expertise em PHP
- Após resolver problemas de memória e confiabilidade
- Quando precisa de performance PHP moderna

---

### ❌ NÃO Recomendado para Produção

#### PHP FPM (sem otimização extensiva)
**Problemas**:
- ❌ P95 de 1,556ms (falhou threshold)
- ❌ 8.87% dropped iterations
- ❌ CPU P95 de 3.63 cores (saturação)
- ❌ 600 VUs (saturado)

**Pode ser usado SE**:
- Otimizar workers do PHP-FPM (pm.max_children, pm.start_servers, etc.)
- Implementar connection pooling via PgBouncer
- Limitar carga a < 200 RPS
- Monitoramento extensivo

#### PHP CLI
**NUNCA usar em produção**:
- ❌ Apenas 25% de throughput
- ❌ P95 de 9.98 segundos
- ❌ 74.5% dropped iterations
- ❌ Servidor single-threaded

**Uso adequado**: Apenas desenvolvimento local

---

## 📊 Insights Técnicos

### 1. Java é Imbatível em Performance
- **3 primeiros lugares** em latência
- **Mais eficiente em CPU** (0.059-0.088 cores)
- **100% de confiabilidade** em todas as implementações
- **Memória estável** sem leaks

**Por quê?**:
- JIT compiler otimiza código em runtime
- Garbage Collector moderno (G1GC, ZGC)
- Thread pool bem otimizado
- Connection pooling eficiente (HikariCP)

### 2. Virtual Threads são o Futuro
- **Performance quase idêntica** ao MVC tradicional (17.06ms vs 13.37ms)
- **Código mais simples** (sem callbacks, sem reactive)
- **Mesma eficiência de CPU** (0.088 vs 0.059 cores)
- **Sem overhead de memória** significativo

**Conclusão**: Migrar para Virtual Threads quando disponível (Java 21+)

### 3. Node.js é Campeão em Memória
- **36MB de memória** vs 229MB do Java
- **6.3x mais eficiente** em memória
- Permite **6x mais instâncias** por servidor

**Trade-off**:
- CPU 2.9x maior que Java
- Latência 3x maior que Java

**Quando vale a pena**: Quando memória é gargalo (containers, serverless)

### 4. PHP Octane Precisa de Atenção
- **Performance competitiva** (39.28ms P95)
- **Problema crítico de memória**: 14MB → 992MB
- **758 falhas** indicam instabilidade

**Hipóteses**:
1. Memory leak no Swoole ou Laravel
2. Pool de conexões mal configurado
3. Objetos não sendo liberados entre requisições
4. Limite de workers insuficiente

**Ação**: Investigação profunda antes de produção

### 5. Python Tem Limitações Inerentes
- **GIL (Global Interpreter Lock)** limita concorrência
- **CPU 3.8x maior** que Java para mesmo throughput
- **13 falhas** indicam pressão no sistema

**Quando Python faz sentido**:
- Ecossistema necessário (ML, Data Science)
- Performance não é crítica (< 100ms P95 aceitável)
- Equipe com expertise Python

**Alternativas para microsserviços críticos**: Rust, Go

### 6. Connection Pooling é Crítico
Todas as stacks Java usam **HikariCP com 500 conexões**:
- Permite reutilizar conexões TCP
- Evita overhead de criação de conexões
- HTTP Keep-Alive mantém conexões persistentes

**Resultado**: Latências consistentemente baixas

### 7. PHP FPM Não Escala Sem Otimização
- **Modelo de processos** não escala bem
- **Cada requisição = novo processo** (ou pool limitado)
- **Sem connection pooling** nativo

**Solução**:
- Usar PgBouncer para pool de conexões
- Otimizar pm.max_children, pm.start_servers
- Considerar migrar para PHP Octane

---

## 🎯 Conclusões Finais

### Principais Descobertas

1. **Java domina em performance**: As 3 implementações Java ficaram nos 3 primeiros lugares em latência (13-22ms P95).

2. **Virtual Threads são competitivos**: Java MVC VT ficou muito próximo do MVC tradicional, validando o Project Loom.

3. **Node.js é eficiente em memória**: 36MB vs 229MB do Java, permitindo 6x mais instâncias.

4. **PHP Octane é promissor mas instável**: Performance boa (39ms P95), mas 758 falhas e pico de 992MB são críticos.

5. **Python tem overhead**: FastAPI é bom, mas CPU 3.8x maior e 13 falhas indicam limitações.

6. **PHP FPM não escala**: P95 de 1,556ms e 8.87% dropped iterations sem otimização extensiva.

7. **PHP CLI é inaceitável**: Apenas para desenvolvimento local.

---

### Matriz de Decisão

| Requisito | Stack Recomendada | Justificativa |
|-----------|-------------------|---------------|
| **Performance Máxima** | Java MVC | P95: 13.37ms, CPU: 0.059 cores |
| **Código Moderno** | Java MVC VT | Virtual Threads, P95: 17.06ms |
| **Streaming Reativo** | Java WebFlux | Modelo reativo, P95: 21.88ms |
| **Eficiência de Memória** | Node.js | 36MB, 6x mais instâncias |
| **Produtividade** | Node.js | Ecossistema rico, P95: 40.65ms |
| **Ecossistema Python** | FastAPI | P95: 76.07ms, 99.99% sucesso |
| **PHP Moderno** | PHP Octane* | *Após resolver memory leak |
| **Desenvolvimento Local** | PHP CLI | Apenas dev, nunca produção |

---

### Próximos Passos

1. **Para Java**: Implementar em produção com monitoramento
2. **Para Node.js**: Otimizar TypeORM, considerar Prisma
3. **Para Python**: Ajustar pool de conexões, monitorar falhas
4. **Para PHP Octane**: **CRÍTICO** - Investigar memory leak antes de produção
5. **Para PHP FPM**: Otimizar workers ou migrar para Octane
6. **Para todos**: Implementar APM (Application Performance Monitoring)

---

## 📝 Observações Finais

### Limitações deste Benchmark

Este benchmark testou apenas:
- ✅ Endpoint POST `/bonus` com operações de banco
- ✅ Carga sintética (K6)
- ✅ 6 minutos por stack
- ✅ Ramping de 100 a 500 RPS

**NÃO testou**:
- ❌ Operações de leitura (GET)
- ❌ Workloads CPU-bound
- ❌ Diferentes padrões de acesso ao banco
- ❌ Testes de longa duração (stress test de horas)
- ❌ Testes de recuperação (chaos engineering)

### Recomendações para Decisões de Produção

1. **Testar com carga real**: Padrões de uso da sua aplicação
2. **Monitorar métricas de container**: CPU, memória, I/O via Prometheus/Grafana
3. **Avaliar custos de infraestrutura**: Instâncias, memória, CPU
4. **Considerar expertise da equipe**: Produtividade > Performance absoluta
5. **Avaliar maturidade do ecossistema**: Bibliotecas, frameworks, comunidade
6. **Implementar observabilidade**: Logs, métricas, traces (OpenTelemetry)
7. **Fazer testes A/B em produção**: Canary deployments

---

**Relatório gerado em**: 2026-01-13 18:45  
**Dados fonte**: K6 Reports + Prometheus (localhost:9091)  
**Período de coleta**: 2026-01-13 17:08 - 18:15  
**Stacks testadas**: 8 (Node.js, Java WebFlux, Java MVC VT, Java MVC, Python, PHP CLI, PHP FPM, PHP Octane)  
**Total de requisições processadas**: 623,584  
**Métricas coletadas**: K6 (RPS, latência, VUs, erros) + Prometheus (CPU, memória)
