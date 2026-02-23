# Relatório de Benchmark: Requisitos de Hardware para 150 RPS

## Escopo do Teste
O benchmark simula um fluxo de trabalho típico de backend através de dois endpoints:

1. **`POST /bonus` (Escrita)**: Exige validação de cliente em banco de dados, aplicação de regra de bônus condicional e persistência.
2. **`GET /bonus/recents` (Leitura + Processamento)**: Busca 100 registros do banco e realiza a ordenação por data **dentro da aplicação**. Este endpoint foi desenhado para medir a eficiência da linguagem em processamento de coleções e uso de memória sob carga.

---

## Resumo Executivo
Este documento analisa a eficiência de hardware de diferentes stacks tecnológicas ao sustentar uma carga constante de **150 requisições por segundo (RPS)**, mantendo a latência **P95 abaixo de 200ms**.

O diferencial deste teste foi observar quanto de recurso (CPU e Memória) cada stack alocou e efetivamente consumiu sob uma carga de trabalho idêntica e pré-definida.

---

## Metodologia do Teste

### Estratégia de Carga (k6)
O script de teste (`load-all-150rps.js`) seguiu um rigoroso processo de aquecimento e estabilização:
- **Aquecimento (Warm-up):** Uma fase inicial de **5 minutos** com carga progressiva (10 a 75 rate/s) para preparar o ambiente e as aplicações.
- **Carga Constante:** Após o aquecimento, foi aplicada uma carga fixa de **75 iterações/segundo** por **10 minutos**. Cada iteração realiza 2 chamadas (1 POST + 1 GET), totalizando exatamente **150 RPS**.
- **Validação de SLA:** O threshold de sucesso foi definido como **P95 < 200ms** e taxa de erro inferior a **1%** durante a fase de carga real.

### Calibragem de hardware
Foram executadas repetitivas  baterias de testes calibrando o hardware até encontrar o hardware minímo de cada stack para atender o teste.

---

# Infraestrutura e Coleta
As aplicações rodaram no **Nomad** com diferentes níveis de alocação de hardware para garantir a estabilidade do P95. As métricas foram coletadas via **Prometheus**, consolidando dados do Nomad (container) e do **Traefik** (edge router).
Segue abaixo diagrama explicando a infraestrutura envolvida no teste:

![alt text](infra-benchmark.png)

- 1 - Na máquina 01 execução do teste pelo K6 enviando chamadas
- 2 - Na máquina 02 as aplicações de cada stack rodando de forma separada atendendo as requisições, tendo como ponto de entrega Traefik
- 3 - Na máquina 02 persiste e busca bônus no postgres
- 4 - Na máquina 01 ambiente de monitoramento com prometheus consulta os endpoints nomad e traefik para coletar métricas
- 5 - Na máquina 01 Grafana expoe dashboards para visualizar as métricas durante o teste 

---
## Resultados Consolidados: Eficiência de Hardware (150 RPS)

Abaixo, os dados de infraestrutura e performance coletados durante a execução estável de 150 RPS:

### Infraestrutura e Consumo (Nomad)

```BASH
Importante: Nomad foi configurado usando medidas Mhz para cada instância para simular um processador com menos ciclos do que o processador robusto da máquina. Ou seja 1024 mhz não é exatamente 1 core, pois se meu computador tiver velocidade de 4,3GHz ele vai usar 23% da capacidade de 1 core

```

| Stack | Instâncias | CPU Alocado (Total Ghz) | CPU Usado (Total Ghz) | Mem. Alocada (Total) | Mem. Usada (Total) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Rust Axum** | 1 | 0,50 Ghz | **0,50 Ghz** | 256 MiB | **3 MiB** |
| **Java MVC VT** | 1 | 1,50 Ghz | **0,99 Ghz** | 512 MiB | 277 MiB |
| **Golang Gin** | 1 | 1,50 Ghz | **0,99 Ghz** | 512 MiB | 40 MiB |
| **Node.js** | 1 | 1,50 Ghz | 1,36 Ghz | 256 MiB | 209 MiB |
| **Java Quarkus** | 1 | 1,50 Ghz | 0,64 Ghz | 512 MiB | 189 MiB |
| **.NET Core** | 1 | 1,50 Ghz | 1,46 Ghz | 512 MiB | 192 MiB |
| **Java WebFlux** | 1 | 2,50 Ghz | 1,44 Ghz | 256 MiB | 238 MiB |
| **Python** | 2 | 3,00 Ghz | 2,20 Ghz | 1024 MiB | 437 MiB |
| **PHP Octane** | 2 | 4,50 Ghz | 2,80 Ghz | 2560 MiB | 1002 MiB |
| **PHP FPM** | 6 | 13,50 Ghz | 5,10 Ghz | 3072 MiB | 442 MiB |

### Performance de Rede (K6 & Traefik)

Todas as stacks listadas abaixo cumpriram o SLA de **P95 < 200ms** para 150 RPS.

| Stack | P95 K6 (ms) | P95 Traefik (ms) | Sucesso % | Status |
| :--- | :---: | :---: | :---: | :---: |
| **Java WebFlux** | 16,31 | 9,67 | 99,98% | ✅ |
| **Java Quarkus** | 23,24 | 9,66 | 99,95% | ✅ |
| **Java MVC VT** | 26,66 | 9,83 | 99,99% | ✅ |
| **Rust Axum** | 28,87 | 18,66 | 99,97% | ✅ |
| **Golang Gin** | 34,99 | 9,92 | 99,95% | ✅ |
| **Python** | 45,61 | 26,85 | 99,95% | ✅ |
| **Node.js** | 51,49 | 14,26 | 99,96% | ✅ |
| **.NET Core** | 88,97 | 79,25 | 99,95% | ✅ |
| **PHP Octane** | 115,37 | 63,70 | 99,98% | ✅ |
| **PHP FPM** | 124,31 | 69,70 | 99,81% | ✅ |

---

## 🔍 Conclusões Principais
1. **Eficiência Extrema:** O **Rust Axum** foi a stack mais eficiente, utilizando apenas **0.5 Ghz** e meros **3 MB** de RAM média para sustentar a carga total de 150 RPS com excelente latência.
2. **Virtual Threads:** O **Java MVC VT** apresentou um consumo de CPU equilibrado (0.99 Ghz) e latências consistentes, mostrando-se uma opção sólida e eficiente.
3. **Escalabilidade PHP:** O modelo **PHP FPM** exigiu a maior quantidade de hardware (6 instâncias, 13,5 Ghz alocados) para garantir que o P95 não ultrapassasse o limite de 200ms sob os mesmos 150 RPS.
4. **Interpretadas vs Compiladas:** Stacks como Python e PHP requerem significativamente mais instâncias e CPU total para entregar o mesmo throughput com a latência desejada em comparação a Rust, Go ou Java.