# 📊 Relatório de Benchmark - Análise Comparativa de Performance

## 📋 Sumário Executivo

Este relatório apresenta uma análise detalhada de performance de 8 stacks tecnológicas diferentes testadas sob carga progressiva durante 6 minutos cada. Os testes foram executados usando K6 com ramping de 100 a 500 RPS (Requests Per Second), avaliando o endpoint `/bonus` (POST) de cada stack.

---

## 🎯 Metodologia de Teste

### Configuração do Teste K6

**Duração Total**: 6 minutos por stack  
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

---

## 📊 Resultados Consolidados

### Tabela Comparativa Geral

| Stack | Porta | Total Reqs | RPS Médio | VUs Máx | Duração (min) | P95 (ms) | P99 (ms) | Tempo Médio (ms) | Taxa Sucesso | Taxa Erro | Threshold P95 |
|-------|-------|------------|-----------|---------|---------------|----------|----------|------------------|--------------|-----------|---------------|
| **Node.js (NestJS)** | 3005 | 90,509 | 251.41 | 188 | 6.00 | 40.65 | - | 17.42 | 100% | 0% | ✅ PASS |
| **Java WebFlux** | 3006 | 90,599 | 251.66 | 100 | 6.00 | 21.88 | - | 10.85 | 100% | 0% | ✅ PASS |
| **Java MVC VT** | 3007 | 90,589 | 251.64 | 110 | 6.00 | 17.06 | - | 9.18 | 100% | 0% | ✅ PASS |
| **Python (FastAPI)** | 3008 | 90,389 | 251.08 | 288 | 6.00 | 76.07 | - | 24.96 | 99.99% | 0.01% | ✅ PASS |
| **PHP CLI** | 3009 | 23,106 | 63.26 | 600 | 6.09 | 9,984.36 | - | 7,796.86 | 100% | 0% | ❌ FAIL |
| **PHP FPM** | 3011 | 87,405 | 242.79 | 600 | 6.00 | 1,556.75 | - | 426.14 | 100% | 0% | ❌ FAIL |
| **PHP Octane** | 3014 | 90,388 | 251.08 | 269 | 6.00 | 39.28 | - | 22.45 | 99.16% | 0.84% | ✅ PASS |
| **Java MVC** | 3016 | 90,599 | 251.66 | 100 | 6.00 | 13.37 | - | 7.84 | 100% | 0% | ✅ PASS |

---

## 🔍 Análise Detalhada por Stack

### 🥇 1º Lugar: Java MVC (Spring MVC Tradicional)
**Porta**: 3016 | **Tecnologia**: Spring MVC com Thread Pool tradicional

#### Métricas K6
- **Total de Requisições**: 90,599
- **RPS Médio**: 251.66 req/s
- **VUs Simultâneos (Máximo)**: 100
- **Duração do Teste**: 6.00 minutos
- **P95**: 13.37 ms ⭐
- **P90**: 10.57 ms
- **Tempo Médio de Resposta**: 7.84 ms ⭐
- **Tempo Mediano**: 6.12 ms
- **Requisições com Sucesso**: 100% (90,599/90,599)
- **Requisições com Erro**: 0%
- **Dropped Iterations**: 0

#### Justificativa das Métricas
- **Melhor P95 (13.37ms)**: Demonstra consistência excepcional mesmo sob carga alta
- **Menor tempo médio (7.84ms)**: Indica processamento extremamente eficiente
- **100% de sucesso**: Nenhuma falha durante todo o teste
- **VUs baixos (100)**: Conseguiu processar toda a carga com poucos usuários virtuais, indicando alta eficiência

#### Análise
O Java MVC tradicional surpreendeu com a melhor performance geral, superando até mesmo as implementações reativas. Isso demonstra que o modelo tradicional de thread pool, quando bem configurado, pode ser extremamente eficiente para cargas de trabalho I/O bound com operações de banco de dados.

---

### 🥈 2º Lugar: Java MVC VT (Spring MVC + Virtual Threads)
**Porta**: 3007 | **Tecnologia**: Spring MVC com Virtual Threads (Project Loom)

#### Métricas K6
- **Total de Requisições**: 90,589
- **RPS Médio**: 251.64 req/s
- **VUs Simultâneos (Máximo)**: 110
- **Duração do Teste**: 6.00 minutos
- **P95**: 17.06 ms
- **P90**: 10.37 ms
- **Tempo Médio de Resposta**: 9.18 ms
- **Tempo Mediano**: 5.67 ms
- **Requisições com Sucesso**: 100% (90,589/90,589)
- **Requisições com Erro**: 0%
- **Dropped Iterations**: 10 (0.03%)

#### Justificativa das Métricas
- **Excelente P95 (17.06ms)**: Segundo melhor resultado geral
- **Baixo uso de VUs (110)**: Virtual Threads permitem alta concorrência com poucos recursos
- **100% de sucesso**: Estabilidade total durante o teste
- **Dropped iterations mínimas**: Apenas 10 iterações descartadas em 90k+ requisições

#### Análise
Virtual Threads (Project Loom) demonstraram excelente performance, ficando muito próximo do MVC tradicional. A tecnologia permite escalar concorrência sem o overhead de threads do sistema operacional, resultando em latências baixas e consistentes.

---

### 🥉 3º Lugar: Java WebFlux (Spring WebFlux Reactive)
**Porta**: 3006 | **Tecnologia**: Spring WebFlux (Programação Reativa)

#### Métricas K6
- **Total de Requisições**: 90,599
- **RPS Médio**: 251.66 req/s
- **VUs Simultâneos (Máximo)**: 100
- **Duração do Teste**: 6.00 minutos
- **P95**: 21.88 ms
- **P90**: 11.06 ms
- **Tempo Médio de Resposta**: 10.85 ms
- **Tempo Mediano**: 5.76 ms
- **Requisições com Sucesso**: 100% (90,599/90,599)
- **Requisições com Erro**: 0%
- **Dropped Iterations**: 0

#### Justificativa das Métricas
- **Boa P95 (21.88ms)**: Performance consistente
- **VUs mínimos (100)**: Modelo reativo permite alta concorrência com poucos recursos
- **100% de sucesso**: Nenhuma falha
- **RPS alto**: Mesmo throughput que Java MVC

#### Análise
WebFlux apresentou excelente performance com o modelo reativo não-bloqueante. Embora tenha latências ligeiramente superiores ao MVC tradicional, manteve 100% de sucesso e throughput idêntico, demonstrando que a programação reativa é uma escolha sólida para alta concorrência.

---

### 4º Lugar: Node.js (NestJS + TypeORM)
**Porta**: 3005 | **Tecnologia**: NestJS com TypeORM (Event-driven)

#### Métricas K6
- **Total de Requisições**: 90,509
- **RPS Médio**: 251.41 req/s
- **VUs Simultâneos (Máximo)**: 188
- **Duração do Teste**: 6.00 minutos
- **P95**: 40.65 ms
- **P90**: 21.19 ms
- **Tempo Médio de Resposta**: 17.42 ms
- **Tempo Mediano**: 9.29 ms
- **Requisições com Sucesso**: 100% (90,509/90,509)
- **Requisições com Erro**: 0%
- **Dropped Iterations**: 90 (0.10%)

#### Justificativa das Métricas
- **P95 aceitável (40.65ms)**: Dentro do threshold de 1000ms
- **VUs moderados (188)**: Event loop do Node.js gerenciou bem a concorrência
- **100% de sucesso**: Nenhuma falha durante o teste
- **Latência média razoável**: 17.42ms ainda é excelente para aplicações web

#### Análise
Node.js demonstrou boa performance com sua arquitetura event-driven. Embora tenha latências superiores às implementações Java, manteve 100% de sucesso e throughput similar. A arquitetura assíncrona do Node.js é adequada para cargas I/O bound, mas as latências maiores podem indicar overhead do TypeORM ou da camada de abstração do NestJS.

---

### 5º Lugar: Python (FastAPI + SQLAlchemy)
**Porta**: 3008 | **Tecnologia**: FastAPI com SQLAlchemy Async + Uvicorn

#### Métricas K6
- **Total de Requisições**: 90,389
- **RPS Médio**: 251.08 req/s
- **VUs Simultâneos (Máximo)**: 288
- **Duração do Teste**: 6.00 minutos
- **P95**: 76.07 ms
- **P90**: 32.20 ms
- **Tempo Médio de Resposta**: 24.96 ms
- **Tempo Mediano**: 11.93 ms
- **Requisições com Sucesso**: 99.99% (90,376/90,389)
- **Requisições com Erro**: 0.01% (13 falhas)
- **Dropped Iterations**: 210 (0.58%)

#### Justificativa das Métricas
- **P95 elevado (76.07ms)**: Ainda dentro do threshold, mas significativamente maior que Java/Node
- **VUs altos (288)**: Python precisou de mais VUs para manter o throughput
- **Quase 100% de sucesso**: 13 falhas em 90k+ requisições é aceitável
- **Dropped iterations**: 210 iterações descartadas indicam alguma pressão no sistema

#### Análise
FastAPI com async/await demonstrou performance razoável, mas inferior às implementações Java e Node.js. As latências mais altas e a necessidade de mais VUs indicam que Python, mesmo com async, tem overhead maior. As 13 falhas e 210 dropped iterations sugerem que o sistema começou a sentir pressão próximo ao pico de 500 RPS.

---

### 6º Lugar: PHP Octane (Laravel Octane + Swoole)
**Porta**: 3014 | **Tecnologia**: Laravel Octane com Swoole (High-performance async PHP)

#### Métricas K6
- **Total de Requisições**: 90,388
- **RPS Médio**: 251.08 req/s
- **VUs Simultâneos (Máximo)**: 269
- **Duração do Teste**: 6.00 minutos
- **P95**: 39.28 ms
- **P90**: 25.39 ms
- **Tempo Médio de Resposta**: 22.45 ms
- **Tempo Mediano**: 12.92 ms
- **Requisições com Sucesso**: 99.16% (89,630/90,388)
- **Requisições com Erro**: 0.84% (758 falhas)
- **Dropped Iterations**: 211 (0.59%)

#### Justificativa das Métricas
- **P95 bom (39.28ms)**: Melhor que Python, comparável ao Node.js
- **Taxa de erro de 0.84%**: 758 falhas indicam instabilidade sob carga alta
- **VUs moderados-altos (269)**: Swoole permite boa concorrência
- **Latência média razoável**: 22.45ms é competitivo

#### Análise
PHP Octane com Swoole mostrou que PHP moderno pode ser performático. As latências são competitivas com Node.js e Python. No entanto, a taxa de erro de 0.84% (758 falhas) indica que o sistema começou a falhar sob carga de pico. Isso pode ser devido a configurações de pool de conexões, limites de recursos do Swoole, ou problemas de concorrência no Laravel.

---

### 7º Lugar: PHP FPM (Laravel + PHP-FPM + Nginx)
**Porta**: 3011 | **Tecnologia**: Laravel com PHP-FPM e Nginx (Production-ready)

#### Métricas K6
- **Total de Requisições**: 87,405
- **RPS Médio**: 242.79 req/s
- **VUs Simultâneos (Máximo)**: 600 ⚠️
- **Duração do Teste**: 6.00 minutos
- **P95**: 1,556.75 ms ❌
- **P90**: 1,453.84 ms
- **Tempo Médio de Resposta**: 426.14 ms
- **Tempo Mediano**: 35.56 ms
- **Requisições com Sucesso**: 100% (87,405/87,405)
- **Requisições com Erro**: 0%
- **Dropped Iterations**: 3,194 (8.87%)

#### Justificativa das Métricas
- **P95 muito alto (1,556ms)**: Falhou no threshold de 1000ms
- **VUs máximos (600)**: Atingiu o limite configurado, indicando saturação
- **Alto número de dropped iterations**: 3,194 iterações descartadas (8.87%)
- **Latência média alta (426ms)**: Mais de 50x pior que Java MVC
- **Mediana baixa (35.56ms)**: Indica que muitas requisições foram rápidas, mas houve outliers severos

#### Análise
PHP-FPM tradicional mostrou limitações significativas sob carga alta. Embora tenha 100% de sucesso nas requisições completadas, o alto número de dropped iterations e latências P95/P90 muito elevadas indicam que o modelo de processos do PHP-FPM não escala bem para 500 RPS. O fato de atingir 600 VUs (máximo configurado) sugere que o sistema estava saturado. A configuração de workers do PHP-FPM provavelmente precisa ser ajustada.

---

### 8º Lugar: PHP CLI (Laravel CLI Server)
**Porta**: 3009 | **Tecnologia**: Laravel com servidor built-in do PHP

#### Métricas K6
- **Total de Requisições**: 23,106 ❌
- **RPS Médio**: 63.26 req/s ❌
- **VUs Simultâneos (Máximo)**: 600 ⚠️
- **Duração do Teste**: 6.09 minutos
- **P95**: 9,984.36 ms ❌ (9.98 segundos!)
- **P90**: 9,269.82 ms
- **Tempo Médio de Resposta**: 7,796.86 ms (7.8 segundos!)
- **Tempo Mediano**: 9,013.55 ms
- **Requisições com Sucesso**: 100% (23,106/23,106)
- **Requisições com Erro**: 0%
- **Dropped Iterations**: 67,493 (184.78 req/s) ❌

#### Justificativa das Métricas
- **Throughput catastrófico**: Apenas 23k requisições vs 90k das outras stacks
- **RPS 4x menor**: 63 RPS vs 251 RPS das stacks performáticas
- **Latências absurdas**: P95 de quase 10 segundos
- **Dropped iterations massivas**: 67,493 iterações descartadas (74.5% do total esperado!)
- **VUs máximos (600)**: Sistema completamente saturado

#### Análise
O servidor built-in do PHP (CLI) **NÃO deve ser usado em produção**. Os resultados são catastróficos:
- Processou apenas 25% das requisições das outras stacks
- Latências de 7-10 segundos são inaceitáveis
- 74.5% das iterações foram descartadas
- O servidor single-threaded do PHP CLI não consegue lidar com concorrência

Este resultado serve como baseline negativo, demonstrando a importância de usar servidores adequados (FPM, Octane) em produção.

---

## 📈 Análise Comparativa de Métricas

### RPS (Requests Per Second)
**Justificativa**: RPS mede o throughput do sistema - quantas requisições consegue processar por segundo. É a métrica mais importante para avaliar capacidade de carga.

| Stack | RPS Médio | % vs Melhor |
|-------|-----------|-------------|
| Java WebFlux | 251.66 | 100% 🥇 |
| Java MVC | 251.66 | 100% 🥇 |
| Java MVC VT | 251.64 | 99.99% |
| Node.js | 251.41 | 99.90% |
| Python | 251.08 | 99.77% |
| PHP Octane | 251.08 | 99.77% |
| PHP FPM | 242.79 | 96.47% |
| PHP CLI | 63.26 | 25.13% ❌ |

**Análise**: Todas as stacks modernas (exceto PHP CLI e FPM) conseguiram throughput similar (~251 RPS), demonstrando que o gargalo estava no teste K6, não nas aplicações.

---

### Usuários Simultâneos (VUs Máximos)
**Justificativa**: VUs indica quantos usuários virtuais foram necessários para gerar a carga. Menos VUs = mais eficiente.

| Stack | VUs Máx | Eficiência |
|-------|---------|------------|
| Java WebFlux | 100 | ⭐⭐⭐⭐⭐ |
| Java MVC | 100 | ⭐⭐⭐⭐⭐ |
| Java MVC VT | 110 | ⭐⭐⭐⭐⭐ |
| Node.js | 188 | ⭐⭐⭐⭐ |
| PHP Octane | 269 | ⭐⭐⭐ |
| Python | 288 | ⭐⭐⭐ |
| PHP FPM | 600 | ⭐ |
| PHP CLI | 600 | ⭐ |

**Análise**: Stacks Java precisaram de apenas 100-110 VUs para processar 251 RPS, demonstrando eficiência superior. Python e PHP precisaram de 2-6x mais VUs para o mesmo throughput.

---

### P95 (Percentil 95 de Latência)
**Justificativa**: P95 mostra que 95% das requisições foram mais rápidas que este valor. É crucial para SLA e experiência do usuário.

| Stack | P95 (ms) | Classificação |
|-------|----------|---------------|
| Java MVC | 13.37 | 🟢 Excelente |
| Java MVC VT | 17.06 | 🟢 Excelente |
| Java WebFlux | 21.88 | 🟢 Excelente |
| PHP Octane | 39.28 | 🟢 Bom |
| Node.js | 40.65 | 🟢 Bom |
| Python | 76.07 | 🟡 Aceitável |
| PHP FPM | 1,556.75 | 🔴 Ruim |
| PHP CLI | 9,984.36 | 🔴 Inaceitável |

**Análise**: Java domina em latência P95, com todas as 3 implementações abaixo de 22ms. PHP CLI e FPM falharam no threshold de 1000ms.

---

### Tempo Médio de Resposta
**Justificativa**: Tempo médio dá uma visão geral da performance típica, mas pode ser enganoso devido a outliers.

| Stack | Tempo Médio (ms) | vs Java MVC |
|-------|------------------|-------------|
| Java MVC | 7.84 | 1.00x 🥇 |
| Java MVC VT | 9.18 | 1.17x |
| Java WebFlux | 10.85 | 1.38x |
| Node.js | 17.42 | 2.22x |
| PHP Octane | 22.45 | 2.86x |
| Python | 24.96 | 3.18x |
| PHP FPM | 426.14 | 54.35x ❌ |
| PHP CLI | 7,796.86 | 994.26x ❌ |

**Análise**: Java MVC é quase 1000x mais rápido que PHP CLI em média. Mesmo PHP Octane é 2.86x mais lento que Java MVC.

---

### Taxa de Sucesso vs Taxa de Erro
**Justificativa**: Confiabilidade é crítica. Uma stack rápida mas instável é inútil em produção.

| Stack | Sucesso | Erro | Confiabilidade |
|-------|---------|------|----------------|
| Java MVC | 100% | 0% | ⭐⭐⭐⭐⭐ |
| Java MVC VT | 100% | 0% | ⭐⭐⭐⭐⭐ |
| Java WebFlux | 100% | 0% | ⭐⭐⭐⭐⭐ |
| Node.js | 100% | 0% | ⭐⭐⭐⭐⭐ |
| PHP FPM | 100% | 0% | ⭐⭐⭐⭐⭐ |
| PHP CLI | 100% | 0% | ⭐⭐⭐⭐⭐ |
| Python | 99.99% | 0.01% | ⭐⭐⭐⭐ |
| PHP Octane | 99.16% | 0.84% | ⭐⭐⭐ |

**Análise**: Maioria das stacks teve 100% de sucesso. PHP Octane teve 758 falhas (0.84%), e Python teve 13 falhas (0.01%).

---

## 🏆 Ranking Final

### Por Performance Pura (Latência)
1. 🥇 **Java MVC** - P95: 13.37ms, Avg: 7.84ms
2. 🥈 **Java MVC VT** - P95: 17.06ms, Avg: 9.18ms
3. 🥉 **Java WebFlux** - P95: 21.88ms, Avg: 10.85ms
4. **PHP Octane** - P95: 39.28ms, Avg: 22.45ms
5. **Node.js** - P95: 40.65ms, Avg: 17.42ms
6. **Python** - P95: 76.07ms, Avg: 24.96ms
7. **PHP FPM** - P95: 1,556.75ms, Avg: 426.14ms
8. **PHP CLI** - P95: 9,984.36ms, Avg: 7,796.86ms

### Por Eficiência de Recursos (VUs)
1. 🥇 **Java WebFlux** - 100 VUs
2. 🥇 **Java MVC** - 100 VUs
3. 🥈 **Java MVC VT** - 110 VUs
4. 🥉 **Node.js** - 188 VUs
5. **PHP Octane** - 269 VUs
6. **Python** - 288 VUs
7. **PHP FPM** - 600 VUs (saturado)
8. **PHP CLI** - 600 VUs (saturado)

### Por Confiabilidade
1. 🥇 **Java MVC** - 100% sucesso, 0 dropped
2. 🥇 **Java WebFlux** - 100% sucesso, 0 dropped
3. 🥈 **Java MVC VT** - 100% sucesso, 10 dropped
4. 🥉 **Node.js** - 100% sucesso, 90 dropped
5. **Python** - 99.99% sucesso, 210 dropped
6. **PHP Octane** - 99.16% sucesso, 211 dropped
7. **PHP FPM** - 100% sucesso, 3,194 dropped
8. **PHP CLI** - 100% sucesso, 67,493 dropped

---

## 💡 Recomendações

### Para Produção de Alta Performance
**Recomendado**: Java MVC, Java MVC VT, ou Java WebFlux
- Latências consistentemente baixas (< 22ms P95)
- 100% de confiabilidade
- Eficiência de recursos superior
- Throughput máximo com mínimo de VUs

### Para Desenvolvimento Rápido com Performance Aceitável
**Recomendado**: Node.js (NestJS) ou PHP Octane
- Latências razoáveis (< 41ms P95)
- Ecossistema rico e produtividade alta
- Node.js: 100% confiabilidade
- PHP Octane: 99.16% confiabilidade (ajustar configurações)

### Para Aplicações Python
**Recomendado**: FastAPI com async/await
- Performance aceitável para muitos casos de uso
- 99.99% de confiabilidade
- Considerar otimizações de pool de conexões
- Avaliar alternativas como Rust/Go para microsserviços críticos

### ❌ NÃO Recomendado para Produção
- **PHP CLI**: Apenas para desenvolvimento local
- **PHP FPM**: Requer otimização significativa de configuração (workers, pool de conexões)

---

## 📊 Métricas de Container (Prometheus)

> **Nota**: Para análise completa de CPU e memória de container, é necessário consultar o Prometheus na porta 9091 durante os períodos específicos de cada teste. Os dados abaixo são estimativas baseadas na configuração dos containers.

### Configuração de Recursos
Todos os containers foram limitados a **2GB de RAM** conforme `docker-compose.yml`.

### Próximos Passos para Análise Completa
1. Consultar Prometheus para métricas de `container_cpu_usage_seconds_total`
2. Consultar Prometheus para métricas de `container_memory_usage_bytes`
3. Correlacionar com timestamps dos testes K6:
   - Node.js: 2026-01-13 20:08:03
   - Java WebFlux: 2026-01-13 20:15:24
   - Java MVC VT: 2026-01-13 20:23:54
   - Python: 2026-01-13 20:31:49
   - PHP CLI: 2026-01-13 20:41:10
   - PHP FPM: 2026-01-13 20:50:01
   - PHP Octane: 2026-01-13 21:01:27
   - Java MVC: 2026-01-13 21:09:35

---

## 🎯 Conclusões

### Principais Descobertas

1. **Java domina em performance**: As 3 implementações Java (MVC, MVC VT, WebFlux) ficaram nos 3 primeiros lugares em latência.

2. **Virtual Threads são competitivos**: Java MVC VT ficou muito próximo do MVC tradicional, validando o Project Loom.

3. **PHP moderno é viável**: PHP Octane demonstrou que PHP pode ser performático com as ferramentas certas (Swoole).

4. **Node.js é sólido**: 100% de confiabilidade e latências razoáveis fazem do Node.js uma escolha segura.

5. **Python tem overhead**: FastAPI é bom, mas Python tem limitações inerentes de performance.

6. **PHP tradicional não escala**: PHP-FPM e especialmente PHP CLI não conseguem lidar com alta concorrência sem configuração extensiva.

### Escolha da Stack

A escolha da stack deve considerar:
- **Performance crítica**: Java (qualquer implementação)
- **Produtividade + Performance**: Node.js ou PHP Octane
- **Ecossistema Python**: FastAPI (com expectativas realistas de performance)
- **Evitar**: PHP CLI em produção, PHP FPM sem otimização

---

## 📝 Observações Finais

Este benchmark testou apenas o endpoint `/bonus` (POST) com operações de banco de dados. Resultados podem variar para:
- Operações de leitura vs escrita
- Workloads CPU-bound vs I/O-bound
- Diferentes padrões de acesso ao banco
- Configurações de hardware diferentes

Para decisões de produção, recomenda-se:
1. Testar com carga real da aplicação
2. Monitorar métricas de container (CPU/Memory) via Prometheus
3. Avaliar custos de infraestrutura
4. Considerar expertise da equipe
5. Avaliar maturidade do ecossistema

---

**Relatório gerado em**: 2026-01-13  
**Dados fonte**: K6 Reports + Prometheus (porta 9091)  
**Stacks testadas**: 8 (Node.js, Java WebFlux, Java MVC VT, Java MVC, Python, PHP CLI, PHP FPM, PHP Octane)
