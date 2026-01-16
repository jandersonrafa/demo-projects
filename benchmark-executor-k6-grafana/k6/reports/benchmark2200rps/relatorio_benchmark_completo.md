# 📊 Relatório Final de Benchmark - Análise Completa de Performance (2200 RPS)

## 📋 Sumário Executivo

Este relatório apresenta uma análise detalhada de performance de **7 stacks tecnológicas** testadas sob carga extrema durante **24 minutos** (1440 segundos) cada. Os testes foram executados usando K6 com ramping até um alvo de **2200 RPS**, avaliando o endpoint `/bonus` (POST).

A análise foi refinada para considerar não apenas os erros HTTP, mas também as **Dropped Iterations** (requisições descartadas pelo gerador de carga por falta de resposta do sistema), que foram o principal modo de falha para Python e PHP.

**Data do Teste**: 2026-01-16  
**Duração por Stack**: 24 minutos (1440s)  
**Carga Alvo Configurada**: 2200 RPS  
**Endpoint Testado**: POST `/bonus`

---

## 📊 Resultados Consolidados - Tabela Geral (Corrigida)

| Stack | Porta | Total Planejado* | Sucesso (2xx) | Erro HTTP (5xx) | Dropped (Não enviadas) | Taxa Real Sucesso** | RPS Real (Sucesso) | P95 (ms) | CPU Avg (cores) | Mem P95 (MB) | Status |
|-------|-------|------------------|---------------|-----------------|------------------------|---------------------|--------------------|----------|-----------------|--------------|--------|
| **Java MVC VT** | 3007 | 1,800,000 | 1,798,522 | 0 | 1,477 | 99.92% | 1,249 | 23.81 | 0.83 | 442.69 | ✅ |
| **Java WebFlux** | 3006 | 1,800,000 | 1,797,154 | 0 | 2,845 | 99.84% | 1,248 | 21.64 | 0.80 | 303.58 | ✅ |
| **Java MVC** | 3016 | 1,800,000 | 1,797,767 | 0 | 2,232 | 99.88% | 1,248 | 89.49 | 0.78 | 436.88 | ✅ |
| **PHP Octane** | 3014 | 1,800,000 | 564,332 | 173,241 | 1,062,426 | 31.35% | 392 | 3,825 | 3.69 | 1,031.39 | ❌ |
| **PHP FPM** | 3011 | 1,800,000 | 513,681 | 0 | 1,286,318 | 28.54% | 357 | 5,251 | 2.72 | 89.30 | ❌ |
| **Python** | 3008 | 1,800,000 | 505,264 | 3,551 | 1,291,184 | 28.07% | 351 | 9,533 | 3.12 | 306.75 | ❌ |
| **Node.js** | 3005 | 1,800,000 | 151,757 | 1,608,690 | 39,552 | 8.43% | 105 | 23.14*** | 0.59 | 374.23 | ❌ |

*\*Total Planejado aproximado (sum of processed + dropped).*
*\*\*Taxa Real Sucesso = Sucesso / (Sucesso + Erro HTTP + Dropped).*
*\*\*\*P95 do Node.js é irrelevante devido à taxa de erro de 91%.*

---

## 🔍 Análise Detalhada dos Modos de Falha

### 1. Saturação por Backpressure (Python & PHP FPM)
Stacks como **Python (FastAPI)** e **PHP FPM** não apresentaram altas taxas de erro HTTP "explícitas" (5xx), mas falharam silenciosamente.
- **Sintoma**: O sistema ficou tão lento (latências de 5s a 10s) que o K6 não conseguiu enviar novas requisições.
- **Dados**:
    - Python teve **1.29 milhão de iterações descartadas**.
    - PHP FPM teve **1.28 milhão de iterações descartadas**.
- **Conclusão**: O throughput ficou limitado a ~350 RPS. Qualquer carga acima disso foi rejeitada por timeout ou engarrafamento na entrada.

### 2. Saturação por Erro + Backpressure (PHP Octane)
O **PHP Octane** tentou processar mais requisições que o FPM, mas a custo de estabilidade.
- **Dados**:
    - **173 mil erros HTTP** (provavelmente falhas de conexão com banco ou timeouts internos).
    - **1.06 milhão de iterações descartadas**.
    - Consumo de **1GB de RAM**.
- **Conclusão**: O Swoole/Octane aceita mais conexões, mas colapsa sob carga extrema se não houver recursos suficientes.

### 3. Colapso Total (Node.js)
O **Node.js** teve o pior comportamento para uma API crítica.
- **Dados**:
    - **1.6 milhão de erros HTTP** (91% das tentativas).
    - Baixo número de dropped iterations (39k) indica que o Node respondia *rapidamente*, mas respondia com **ERRO**.
- **Causa Provável**: Event loop starvation ou rejeição imediata de conexões por falta de file descriptors ou pool de conexões saturado. Diferente do Python que "travou", o Node "explodiu".

### 4. Resiliência (Java Stacks)
As stacks **Java** (MVC e WebFlux) processaram quase a totalidade da carga planejada para a capacidade da máquina.
- **Dados**:
    - Dropped iterations mínimas (~1.5k a 2.8k em 1.8M), representando < 0.2% de perda.
    - Zero erros HTTP.
    - RPS estável em ~1250 independentemente da implementação (MVC vs WebFlux).

---

## ⚖️ Comparative Deep Dive: Reactive (WebFlux) vs Virtual Threads

Uma dúvida comum é: *"O modelo Reativo (WebFlux) não deveria ser muito superior ao Imperativo, mesmo com Virtual Threads?"*

Neste benchmark, a performance foi muito próxima (**1248 vs 1249 RPS**). A explicação técnica é a **Convergência de Modelos de I/O**:

1.  **O Problema do Bloqueio**: Historicamente, WebFlux vencia porque não bloqueava threads do SO enquanto esperava o Banco de Dados. O Spring MVC tradicional bloqueava, esgotando o pool de threads.
2.  **A Solução das Virtual Threads**: Com o Java 21+, quando o código Imperativo (MVC VT) faz uma operação de banco bloqueante, a JVM **desmonta** a Virtual Thread e libera a Thread do SO para outro trabalho.
3.  **Resultado Prático**:
    -   **WebFlux**: Libera a thread via callback/code style.
    -   **Virtual Threads**: Libera a thread via JVM internal scheduling.
    -   **Efeito**: Ambos atingem a mesma eficiência de hardware (sem thread blocking).

**Diferenças Marginais**:
-   **WebFlux** ainda foi ligeiramente mais eficiente em CPU (0.80 vs 0.83 cores) e Latência (21ms vs 23ms) por não ter o overhead de "montar/desmontar" stacks de Virtual Threads.
-   **Conclusão**: O gargalo aqui foi o **Banco de Dados/Rede** (teto de ~1250 RPS), e não o modelo de processamento. Virtual Threads entregaram 95% da eficiência do WebFlux com 100% da simplicidade do código imperativo.

---

## 🔬 Deep Dive: Virtual Threads vs Platform Threads (Latência Cliente vs Servidor)

Uma investigação mais profunda foi realizada comparando a **Latência Externa (Cliente K6)** com a **Latência Interna (Servidor Prometheus)** para entender por que o Java MVC VT foi 4x mais rápido que o MVC Tradicional na visão do cliente.

| Stack | K6 (Cliente / Real) | Prometheus (Servidor / Interno) | Diferença (Overhead de Fila) |
|-------|---------------------|---------------------------------|------------------------------|
| **Java MVC VT (3007)** | **23.81 ms** | **7.60 ms** | ~16 ms |
| **Java MVC (3016)** | **89.49 ms** | **7.45 ms** | **~82 ms** |

### Insights Técnicos
1.  **Execução Idêntica**: Internamente, ambas as aplicações gastam o mesmo tempo (~7.5ms) para processar a regra de negócio e acessar o banco de dados. O código é o mesmo.
2.  **O Gargalo é a Fila**:
    -   No modelo **Tradicional (Platform Threads)**, sob alta carga (1250+ RPS), as requisições ficam presas na fila do pool de threads do SO, aguardando uma thread livre ou agendamento de CPU. Isso adicionou **82ms** de latência pura de espera.
    -   No modelo **Virtual Threads**, esse overhead é eliminado pois as threads são gerenciadas pela JVM (user-mode), permitindo milhões de threads leves sem overhead de contexto do SO.

**Conclusão**: Virtual Threads são essenciais para high-concurrency não porque "processam mais rápido", mas porque **eliminam a fila de espera** na porta da aplicação.

---

## 🏆 Rankings Finais (Ajustados)

### Por Taxa Real de Sucesso (Confiabilidade)
1.  🥇 **Java MVC VT** - 99.92%
2.  🥇 **Java MVC** - 99.88%
3.  🥇 **Java WebFlux** - 99.84%
4.  🥈 **PHP Octane** - 31.35% (Muitos erros e drops)
5.  🥉 **PHP FPM** - 28.54% (Muitos drops)
6.  **Python** - 28.07% (Muitos drops)
7.  **Node.js** - 8.43% (Maioria erros)

### Por Throughput Útil (RPS Sucesso)
1.  **Java (Todas)**: ~1,250 RPS
2.  **PHP Octane**: ~392 RPS
3.  **PHP FPM**: ~357 RPS
4.  **Python**: ~351 RPS
5.  **Node.js**: ~105 RPS

---

## 💡 Recomendação Revisada

Considerando os dados corrigidos de dropped iterations e a duração de 24 minutos:

1.  **Java é a única opção estável** para este perfil de carga. A diferença de confiabilidade (99.9% vs 31%) é abismal.
2.  **Python e PHP FPM** têm um teto rígido de performance (~350 RPS) nesta infraestrutura. Aumentar a carga além disso apenas aumenta a latência, sem ganho de vazão.
3.  **PHP Octane** é perigoso sem tuning, pois consome memória excessiva e gera erros, em vez de apenas travar (fail-unsafe).
4.  **Node.js** requer investigação profunda de configuração antes de ser considerado para alta concorrência.
