# Análise Consolidada de Performance: 12 Stacks Tecnológicas

Esta análise cruza os dados dos benchmarks de Hardware (1000 RPS), Limites Locais (Swarm) e Limites em Nuvem (GCP).

## 1. Tabela Comparativa Geral

| Tecnologia | Max RPS (Local < 200ms) | Max RPS (GCP < 1000ms) | CPU Alocada (1000 RPS) | Memória Alocada (1000 RPS) | Eficiência (Custo/RPS) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Rust Axum** | 1200 | 2400 | 0.52 core | 512 MiB | ⭐ Alta |
| **Java Quarkus** | 1200 | 2400 | 1.04 core | 512 MiB | ⭐ Alta |
| **Java MVC VT** | 1000 | 2250 | 1.04 core | 512 MiB | ⭐ Alta |
| **Golang Gin** | 800 | 1600 | 4.00 core | 512 MiB | Média |
| **Node.js (Fastify)** | 1000 | 1300 | 2.00 core | 512 MiB | Média |
| **Java MVC (No VT)** | 600 | 1300 | 2.00 core | 512 MiB | Média |
| **.NET Core** | 800 | 1300 | 3.00 core | 512 MiB | Baixa |
| **Node.js (Express)** | 800 | 900 | 3.00 core | 512 MiB | Baixa |
| **Java WebFlux** | 800 | 800 | 2.00 core | 512 MiB | Média |
| **Python FastAPI** | 400 | 500 | 6.00 core | 1536 MiB | 🔴 Crítica |
| **PHP Octane** | 400 | 400 | 8.00 core | 6048 MiB | 🔴 Crítica |
| **PHP FPM** | 200 | 100 | 24.00 core | 18144 MiB | 🔴 Crítica |

---

## 2. Principais Conclusões da Análise

### A. O Triunfo da Eficiência (Rust & Quarkus)
Rust (Axum) e Java (Quarkus) são os vencedores indiscutíveis. Eles não apenas atingem os maiores RPS em ambos os ambientes, como o fazem com o **menor consumo de recursos**. A capacidade de dobrar a performance no GCP (de 1200 para 2400 RPS) indica que essas stacks conseguem extrair cada ciclo de CPU disponível de forma linear.

### B. O Impacto das Virtual Threads (Java MVC VT)
O Java MVC com Virtual Threads mostrou o maior salto proporcional no GCP (+125%). Ele saiu de um patamar intermediário (1000 RPS) para brigar diretamente no topo (2250 RPS). Isso comprova que a simplificação do modelo de concorrência permite que a stack escale muito melhor quando o ambiente de rede/I/O é mais favorável (como no GCP).

### C. O Enigma do Java WebFlux e Go
- **WebFlux:** Curiosamente não teve ganho no GCP, mantendo-se em 800 RPS. Isso pode sugerir que o modelo reativo já estava otimizado ao seu limite ou encontrou um gargalo específico de processamento que não foi aliviado pela infraestrutura da nuvem.
- **Go:** Embora precise de mais CPU alocada para estabilizar 1000 RPS (4 cores contra 1 de Quarkus), ele escala muito bem, dobrando sua performance no GCP.

### D. Cloud (GCP) vs Local (Swarm)
Em geral, os resultados no GCP foram superiores. Isso se deve a:
1. **CPU Steal/Overprovisioning:** Ambientes locais podem sofrer mais concorrência de CPU do que instâncias dedicadas de nuvem.
2. **Latência de Rede:** A comunicação entre instâncias e o banco de dados no GCP tende a ser mais otimizada, favorecendo stacks que gerenciam muitas conexões simultâneas.

### E. O Custo das Linguagens Interpretadas (Python/PHP)
A disparidade é brutal. Enquanto Rust precisa de **0.52 core** para 1000 RPS, o PHP FPM precisa de **24 cores**. Em termos financeiros, sustentar 1000 RPS com PHP FPM custa **~47x mais** do que com Rust ($864 vs $18). Mesmo com Octane (PHP) ou FastAPI (Python), a eficiência ainda é ordens de magnitude inferior às stacks compiladas.

---

## 3. Recomendações Baseadas nos Dados

1. **Para Aplicações de Alta Carga:** Priorizar **Rust** ou **Quarkus**. Se a equipe for Java, o Quarkus é a escolha óbvia pela eficiência de memória e CPU.
2. **Modernização Java:** Migrar de Java MVC tradicional para **Virtual Threads** é o upgrade mais barato e eficiente disponível (ganho massivo de performance sem mudar o paradigma de programação).
3. **Node.js:** Se usar Node, o **Fastify** é obrigatório para performance, superando o Express de forma consistente.
4. **Alerta de Cloud Bill:** Evitar Python ou PHP para fluxos de alta concorrência e baixa latência sem um plano de custos muito bem definido, pois o hardware "mínimo" exigido é extremamente agressivo.
---

## 4. Resumo por Stack e Validação de Resultados

Abaixo uma análise crítica da confiabilidade dos dados para cada tecnologia, comparando as expectativas de mercado com os números colhidos:

### 1. Rust Axum
- **Status:** 🟢 Altamente Condizente.
- **Análise:** Rust entregou o que se espera: performance de "metal" com consumo de memória irrisório (16MB). O fato de dobrar a performance no GCP com um SLA de latência mais frouxo (<1000ms) mostra que o limite é o I/O do ambiente, não o runtime.

### 2. Java Quarkus
- **Status:** 🟢 Altamente Condizente.
- **Análise:** O Quarkus prova que a compilação nativa/otimizada e o stack não-bloqueante permitem ao Java brigar com Rust. Os resultados são extremamente sólidos e estáveis em todos os testes.

### 3. Java MVC VT (Virtual Threads)
- **Status:** 🟢 Condizente / Destaque Positivo.
- **Análise:** Surpreendeu positivamente no GCP. O salto de 1000 para 2250 RPS valida a tese de que as Virtual Threads brilham quando há latência de rede envolvida (comum em nuvem), permitindo que threads leves esperem sem travar o core de CPU.

### 4. Golang Gin
- **Status:** 🟡 Risco de Over-provisioning no Teste de HW.
- **Análise:** No teste de 1000 RPS (Hardware), foram alocados 4 cores, mas o uso real foi de ~1.1 core. Go é conhecido por ser tão eficiente quanto Rust/Java em I/O. Os 1600 RPS no GCP são realistas, mas a stack pode ter sido "prejudicada" por uma configuração de recursos excessiva que mascara sua eficiência real em hardware mínimo.

### 5. Node.js (Fastify)
- **Status:** 🟢 Condizente.
- **Análise:** Fastify consistentemente superou o Express. O limite de 1300 RPS no GCP faz sentido para uma stack single-threaded (mesmo com worker threads, o event loop tem um teto).

### 6. Java MVC (Sem Virtual Threads)
- **Status:** 🟢 Condizente.
- **Análise:** O limite de 600 RPS no Swarm local vs 1300 no GCP reflete o gargalo clássico de thread pool. No GCP, com latência maior, o pool de threads do Java "tradicional" sofre mais, mas o limite total de RPS subiu pelo afrouxamento do SLA (P95 < 1000ms).

### 7. .NET Core
- **Status:** 🟢 Condizente.
- **Análise:** Performance sólida e média. .NET costuma ficar no pelotão de elite, mas aqui se manteve no grupo intermediário superior, o que é esperado para frameworks robustos com middleware padrão.

### 8. Node.js (Express)
- **Status:** 🟢 Condizente.
- **Análise:** O baixo ganho no GCP (800 -> 900 RPS) mostra que o Express atingiu seu teto de processamento. A sobrecarga interna do framework impede que ele aproveite a melhoria do ambiente tanto quanto o Fastify.

### 9. Java WebFlux
- **Status:** 🟡 Estranho / Baixo Ganho.
- **Análise:** Estagnou em 800 RPS em ambos os cenários. Sendo uma stack reativa, esperava-se que ela escalasse melhor no GCP (onde o I/O é mais intenso). Isso pode indicar um possível erro de tunning no Netty ou que o processamento interno da lógica de ordenação em memória se tornou o gargalo principal (CPU-bound).

### 10. Python FastAPI
- **Status:** 🟢 Condizente.
- **Análise:** 400-500 RPS é um número muito realista para Python em 1 core. O GIL (Global Interpreter Lock) e a natureza interpretada explicam a estabilidade no rodapé da tabela.

### 11. PHP Laravel Octane (Swoole/RoadRunner)
- **Status:** 🟢 Condizente.
- **Análise:** 400 RPS mostra uma evolução clara sobre o FPM, mas ainda sofre com a pesada inicialização do framework Laravel em cada worker. O resultado está dentro do esperado para a stack.

### 12. PHP Laravel FPM
- **Status:** 🔴 Risco de Erro de Configuração / Ambiente no GCP.
- **Análise:** Cair de 200 RPS (Local) para 100 RPS (GCP) é uma anomalia. O FPM é extremamente sensível à latência de rede e ao número de processos filhos. É provável que o tempo extra de rede no GCP tenha prendido os workers por mais tempo, esgotando o pool rapidamente, ou houve algum throttling específico nas instâncias do GCP para esse modelo multiprocessos.

---

## 5. Veredito Final

Os dados dão uma segurança de **90%** na tomada de decisão. As stacks de topo (Rust, Quarkus, Java VT) mostram consistência inabalável. O único ponto que merece uma revisão técnica antes de uma decisão crítica de arquitetura é o **Java WebFlux**, para entender por que não escalou como o Java VT, e o **PHP FPM**, que apresentou comportamento regressivo em nuvem.
