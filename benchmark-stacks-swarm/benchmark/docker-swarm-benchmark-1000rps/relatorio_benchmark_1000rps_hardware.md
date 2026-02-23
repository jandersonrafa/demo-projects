# Relatório de Benchmark: Requisitos de Hardware para 1000 RPS

## Escopo do Teste
O benchmark simula um fluxo de trabalho típico de backend através de dois endpoints:

1. **`POST /bonus` (Escrita)**: Exige validação de cliente em banco de dados, aplicação de regra de bônus condicional e persistência.
2. **`GET /bonus/recents` (Leitura + Processamento)**: Busca 100 registros do banco e realiza a ordenação por data **dentro da aplicação**. Este endpoint foi desenhado para medir a eficiência da linguagem em processamento de coleções e uso de memória sob carga.

---

## Resumo Executivo
Este documento analisa a eficiência de hardware de diferentes stacks tecnológicas ao sustentar uma carga constante de **1000 requisições por segundo (RPS)**, mantendo a latência **P95 abaixo de 200ms**.

O diferencial deste teste foi observar quanto de recurso (CPU e Memória) cada stack alocou e efetivamente consumiu sob uma carga de trabalho idêntica e pré-definida.

---

## Metodologia do Teste

### Estratégia de Carga (k6)
O script de teste (`load-all-swarm-1000rps.js`) seguiu um rigoroso processo de aquecimento e estabilização:
- **Aquecimento (Warm-up):** Uma fase inicial de **5 minutos** com carga progressiva (20 a 500 rate/s) para preparar o ambiente e as aplicações.
- **Carga Constante:** Após o aquecimento, foi aplicada uma carga fixa de **500 iterações/segundo** por **5 minutos**. Cada iteração realiza 2 chamadas (1 POST + 1 GET), totalizando exatamente **1000 RPS**.
- **Validação de SLA:** O threshold de sucesso foi definido como **P95 < 200ms** e taxa de erro inferior a **1%** durante a fase de carga real.

### Calibragem de hardware
Foram executadas repetitivas  baterias de testes calibrando o hardware até encontrar o hardware minímo de cada stack para atender o teste.

---

# Infraestrutura e Coleta
As aplicações rodaram no **Docker Swarm** com diferentes níveis de alocação de hardware para garantir a estabilidade do P95. As métricas foram coletadas via **Prometheus**, consolidando dados do Swarm (container) e do **Traefik** (edge router).
Segue abaixo diagrama explicando a infraestrutura envolvida no teste:

![alt text](infra-benchmark.png)

- 1 - Na máquina 01 execução do teste pelo K6 enviando chamadas
- 2 - Na máquina 02 as aplicações de cada stack rodando de forma separada atendendo as requisições, tendo como ponto de entrega Traefik
- 3 - Na máquina 02 persiste e busca bônus no postgres
- 4 - Na máquina 01 ambiente de monitoramento com prometheus consulta os endpoints swarm e traefik para coletar métricas
- 5 - Na máquina 01 Grafana expoe dashboards para visualizar as métricas durante o teste 

---
## Resultados Consolidados: Eficiência de Hardware (1000 RPS)

Abaixo, os dados de infraestrutura e performance coletados durante a execução estável de 1000 RPS:

### Infraestrutura e Consumo (Docker Swarm)

```BASH
Importante: Docker Swarm foi configurado usando medidas em cores para cada instância para simular um processador com menos ciclos do que o processador robusto da máquina. Ou seja 1 core alocado não é exatamente 1 core inteiro da máquina, pois se meu computador tiver velocidade de 4,3GHz ele vai usar uma fração da capacidade dependendo das limitações configuradas

```

| Stack | Instâncias | CPU Alocado (Total Ghz) | CPU Usado (Total Ghz) | Mem. Alocada (Total) | Mem. Usada (Total) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Rust Axum** | 2 | 0,52 core | **0,39 core** | 512 MiB | **16 MiB** |
| **Java Quarkus** | 2 | 1,04 core | 0,59 core | 512 MiB | 471 MiB |
| **Java MVC VT** | 2 | 1,04 core | **0,74 core** | 512 MiB | 504 MiB |
| **Java WebFlux** | 2 | 2,00 core | 1,35 core | 512 MiB | 479 MiB |
| **Node.js (Fastify)** | 2 | 2,00 core | 1,18 core | 512 MiB | 223 MiB |
| **Java MVC Without VT** | 2 | 2,00 core | 0,87 core | 512 MiB | 509 MiB |
| **Node.js (Express)** | 2 | 3,00 core | 1,41 core | 512 MiB | 232 MiB |
| **.NET Core** | 2 | 3,00 core | 1,70 core | 512 MiB | 187 MiB |
| **Golang Gin** | 2 | 4,00 core | **1,10 core** | 512 MiB | 32 MiB |
| **Python** | 3 | 6,00 core | 3,48 core | 1536 MiB | 749 MiB |
| **PHP Octane** | 8 | 8,00 core | 3,44 core | 6048 MiB | 2957 MiB |

### Performance de Rede (K6 & Traefik)

Todas as stacks listadas abaixo cumpriram o SLA de **P95 < 200ms** para 1000 RPS.

| Stack | P95 K6 (ms) | P95 Traefik (ms) | Sucesso % | Status |
| :--- | :---: | :---: | :---: | :---: |
| **Golang Gin** | 23,82 | 11,99 | 99,94% | ✅ |
| **Java Quarkus** | 42,46 | 9,84 | 99,80% | ✅ |
| **Rust Axum** | 46,25 | 36,45 | 99,64% | ✅ |
| **Node.js (Express)** | 62,83 | 48,82 | 99,82% | ✅ |
| **Python** | 65,55 | 37,29 | 99,69% | ✅ |
| **Java MVC Without VT** | 42,81 | 9,95 | 99,53% | ✅ |
| **PHP Octane** | 117,40 | 46,57 | 99,77% | ✅ |
| **Java WebFlux** | 137,05 | 71,12 | 99,74% | ✅ |
| **.NET Core** | 136,52 | 9,77 | 99,54% | ✅ |
| **Java MVC VT** | 138,25 | 20,30 | 99,72% | ✅ |
| **Node.js (Fastify)** | 182,56 | 44,17 | 99,57% | ✅ |

---

## 🔍 Conclusões Principais
1. **Eficiência Extrema:** O **Rust Axum** foi a stack mais eficiente, utilizando apenas **0,52 core** e meros **16 MiB** de RAM média para sustentar a carga total de 1000 RPS com excelente latência.
2. **Virtual Threads:** O **Java MVC VT** apresentou um consumo de CPU equilibrado (0,74 core) e latências consistentes, mostrando-se uma opção sólida e eficiente.
3. **Escalabilidade PHP:** O modelo **PHP Octane** exigiu a maior quantidade de hardware (8 instâncias, 8,00 core alocados e quase 3 GiB de RAM) para garantir que o P95 não ultrapassasse o limite de 200ms sob os mesmos 1000 RPS.
4. **Interpretadas vs Compiladas:** Stacks como Python e PHP requerem significativamente mais instâncias e CPU total para entregar o mesmo throughput com a latência desejada em comparação a Rust, Go ou Java.

