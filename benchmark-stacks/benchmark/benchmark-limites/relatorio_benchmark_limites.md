# 📊 Relatório de Benchmark: Limites de Performance por Stack

## 🎯 Escopo do Teste
O teste consiste em avaliar o comportamento das stacks em um cenário real de negócio através de dois endpoints principais:

1. **`POST /bonus` (Escrita/Processamento)**:
   - Valida se o cliente existe e está ativo no banco de dados.
   - Aplica uma regra de negócio: se o valor for > 100, aplica um bônus de 10%.
   - Registra o bônus com data de expiração (30 dias) e descrição formatada.
   - Persiste os dados no PostgreSQL.
2. **`GET /bonus/recents` (Leitura/Estresse de Memória)**:
   - Busca os últimos 100 registros do banco de dados.
   - **Ordenação em Memória**: A ordenação por data de criação é feita propositalmente na camada de aplicação (e não no banco) para estressar CPU e Memória.
   - Retorna apenas os 10 resultados mais recentes após o processamento.

---

## 🚀 Resumo Executivo
Este documento detalha o teste de performance realizado em diversas tecnologias (stacks) para identificar a **taxa máxima de requisições por segundo (RPS)** que cada uma suporta, mantendo a latência **P95 abaixo de 200ms**.

O teste focou em encontrar o "teto" de cada stack sob condições de hardware idênticas, utilizando uma estratégia de carga progressiva (ramping).

---

## 🛠️ Metodologia do Teste

### Infraestrutura e Hardware
Para garantir a isonomia, cada aplicação foi executada com exatamente os mesmos recursos:
- **CPU:** 1 Core
- **Memória RAM:** 1 GB
- **Instâncias:** 2 instâncias por stack, rodando em um orquestrador **HashiCorp Nomad**.

### Coleta de Métricas
As métricas foram coletadas e centralizadas em um servidor **Prometheus**, recebendo dados de duas fontes principais:
1. **Nomad:** Métricas de consumo de recursos do container (CPU/Memória).
2. **Traefik:** O ponto de entrada (Edge Router/Load Balancer) que forneceu as métricas de latência e throughput do tráfego real.

### Estratégia de Carga (k6)
O script de teste (`load-all.js`) utilizou o executor `ramping-arrival-rate` do k6:
- **Aquecimento (Warm-up):** O script escala a carga gradualmente. Foram ignorados os primeiros **8 minutos** de cada execução (utilizando `delayAbortEval`) para permitir o aquecimento da JVM, JIT e caches internos.
- **Escalonamento:** A carga inicia em 20 RPS e sobe em degraus (5,10,15, 25, 30, 50, 100, 150, 200, 300, 400, 500, 600, 700, 800...), com cada patamar durando entre 1 a 2 minutos.
- **Abort automático:** O teste é interrompido automaticamente se o threshold de latência for violado por um período sustentado, garantindo que o limite reportado seja o último patamar estável.
- **Repetibilidade:** Em casos de instabilidade inicial, os testes foram executados até 2 vezes para garantir que a stack estava devidamente aquecida.

---

## 🏆 Resultados Obtidos
A tabela abaixo lista o **RPS máximo** alcançado por cada stack mantendo o **P95 < 200ms**:

| Posição | Stack                              | RPS Máximo |
|:-------:|:-----------------------------------|:-----------|
| 🥇 1º   | **Rust**                           | 1200       |
| 🥈 2º   | **Java MVC (Virtual Threads)**     | 600        |
| 🥉 3º   | **Java Quarkus**                   | 400        |
| 4º      | **Node + NestJS + Fastify**        | 300        |
| 5º      | **.NET**                           | 300        |
| 6º      | **Golang**                         | 300        |
| 7º      | **Java MVC (Sem Virtual Threads)** | 200        |
| 8º      | **Node + NestJS + Express**        | 200        |
| 9º      | **Java WebFlux**                   | 150        |
| 10º     | **Python**                         | 100        |
| 11º     | **PHP + Laravel + Octane**         | 60         |
| 12º     | **PHP + Laravel + FPM**            | 30         |

---

## 🔍 Conclusões
- **Rust** demonstrou uma performance excepcional, atingindo o dobro do segundo colocado com os mesmos recursos.
- **Virtual Threads** no Java MVC teve um impacto significativo, triplicando a performance em relação ao modelo de threads tradicional.
- Stacks interpretadas como **Python** e **PHP** (mesmo com Octane) apresentaram limites consideravelmente menores neste cenário de alta concorrência e restrição de hardware (1 core).
