# 📊 Relatório de Benchmark Java (Target 10,000 RPS)

## 📋 Sumário Executivo

Este relatório analisa o comportamento das stacks **Java** sob uma carga massiva de **10,000 RPS** durante **27 minutos**. O objetivo foi identificar o ponto de ruptura e a resiliência máxima da infraestrutura.

**Resultado**: O alvo de 10,000 RPS **não foi atingido**. A infraestrutura saturou completamente em torno de **2,300 RPS**.
- **Java MVC VT (Virtual Threads)**: Teve o maior throughput útil (~2,300 RPS).
- **Java MVC (Standard)**: Próximo ao VT (~2,200 RPS).
- **Java WebFlux**: **Colapso Crítico**. Além de descartar requisições, falhou em 71% das que tentou processar, resultando em um throughput útil pífio (~350 RPS).

---

## 📊 Resultados Consolidados

| Stack | Porta | Total Planejado | Sucesso (2xx) | Erro HTTP (5xx) | Dropped (Não enviadas) | RPS Real (Sucesso) | P95 Latency (ms) | CPU P95 (cores) | Mem P95 (MB) |
|-------|-------|-----------------|---------------|-----------------|------------------------|--------------------|------------------|-----------------|--------------|
| **Java MVC VT** | 3007 | ~9.6M | 3,756,292 | 25,272 | 5,821,435 | **2,307** | 3,677 | 1.86 | 713 |
| **Java MVC** | 3016 | ~9.6M | 3,585,878 | 33,465 | 5,983,656 | **2,205** | 3,467 | 1.71 | 720 |
| **Java WebFlux** | 3006 | ~9.6M | 562,601 | 1,428,022 | 7,612,376 | **347** ❌ | 3,362 | 1.59 | 772 |

---

## 🔍 Análise Detalhada dos Modos de Falha

### 1. Saturação Geral (O Teto de 2300 RPS)
Tanto o MVC Standard quanto o MVC VT atingiram um teto de processamento muito similar.
- **Sintoma**: Latência subiu para > 3 segundos. O K6 começou a descartar milhões de requisições (dropped iterations) porque o sistema não respondia a tempo.
- **Gargalo**: Dado que o CPU ficou em ~1.8 cores (de um limite provável de 2.0 ou do host), e a memória em ~700MB (longe dos 2GB), o gargalo provável é **I/O de Banco de Dados** (Postgres saturado de conexões/writes) ou **Rede Docker**. O Java processou o que pôde, o resto foi represado.

### 2. Virtual Threads vs Standard Threads
Sob saturação total:
- **VT** processou **~170 mil requisições a mais** que o Standard (+4.7%).
- Isso confirma que VT aproveita melhor os ciclos de CPU enquanto espera o I/O lento/saturado, espremendo um pouco mais de throughput da mesma infraestrutura.

### 3. O Colapso do WebFlux
O WebFlux teve o pior desempenho disparado.
- **Taxa de Erro de 71%**: De 2 milhões de requisições que entraram, 1.4 milhão retornaram erro (5xx).
- **Explicação**: Em cenários de sobrecarga extrema onde o Banco de Dados não responde, o modelo reativo acumula requisições em buffers de memória (Backpressure). Se os buffers enchem ou timeouts ocorrem em cascata, o sistema falha em massa. Ao contrário do modelo bloqueante (MVC) que simplesmente "para" (latência aumenta, throughput cai, mas não erro), o WebFlux tentou processar e falhou, desperdiçando recursos.

---

## 🏆 Conclusão para Cargas Massivas

1.  **Limite Físico**: A infraestrutura atual suporta no máximo **2,300 RPS** para inserts no banco `/bonus`. Tentar injetar 10,000 RPS apenas causa negação de serviço.
2.  **Resiliência**:
    - **MVC VT (Virtual Threads)** é a stack mais resiliente. Mantém o maior throughput possível sem gerar erros massivos, apenas lentidão (Graceful Degradation).
    - **WebFlux** mostrou-se frágil sob colapso de recursos externos (Banco), gerando erros em vez de apenas lentidão.

**Recomendação**: Para atingir 10k RPS, é necessário escalar o Banco de Dados (Sharding/Replicação) e aumentar recursos computacionais (Horizontal Scaling das APIs), pois uma única instância Java já saturou sua capacidade de I/O.
