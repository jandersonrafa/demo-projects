# Relatório de Benchmark Consolidado (Janela de Teste) - v3

Este relatório apresenta os resultados de performance isolados exatamente para o período em que cada teste de carga do k6 foi executado. O período foi detectado automaticamente através da métrica `k6_http_reqs_total` no Prometheus.

## Metodologia de Coleta
- **Janela de Execução**: Identificada individualmente para cada stack (aprox. 6 minutos).
- **RPS e Latência**: Dados extraídos dos relatórios JSON do k6.
- **CPU Peak**: Valor máximo da métrica `process_cpu_usage` (Java) durante a janela do teste.
- **Memory Peak**: Valor máximo de `jvm_memory_used_bytes` (Soma das áreas de Heap para Java), `php_memory_peak_usage_bytes` (PHP) ou `process_resident_memory_bytes` (Node/Python) durante a janela.

## Tabela de Resultados por Janela Temporal

| Stack | Período (Local) | RPS | P95 Latency | Pico CPU | Pico RAM |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Java MVC VT** | 17:12 - 17:18 | 126.61 | **14.29 ms** | 6.52% | 59.40 MB |
| **Java WebFlux** | 17:03 - 17:09 | 126.59 | 15.12 ms | 4.16% | 59.42 MB |
| **Java MVC** | 17:20 - 17:26 | 126.64 | 16.47 ms | 6.16% | 61.34 MB |
| **Node.js** | 16:55 - 17:00 | 126.60 | 19.62 ms | N/A* | 129.89 MB |
| **Laravel Octane** | 17:53 - 17:59 | 126.57 | 41.77 ms | N/A* | **24.00 MB** |
| **Laravel FPM** | 17:45 - 17:51 | 126.59 | 51.37 ms | N/A* |  2.00 MB*** |
| **Python FastAPI**| 17:28 - 17:34 | 105.91 | 4394.06 ms | N/A* | 82.02 MB |
| **Laravel CLI** | 17:37 - 17:43 | 61.11 | 4514.68 ms | N/A* |  2.00 MB*** |

*\* Dados de `process_cpu_usage` não disponíveis para estas runtimes no período solicitado via exportador padrão.*
*\*\* O Python apresentou falhas prematuras, mas a janela de monitoramento foi mantida para análise de recursos.*
*\*\*\* Valores reportados pelo driver de memória do PHP para processos individuais.*

## Análise de Destaques

### 1. Desempenho Isolado
Ao olhar apenas para a janela do teste, o **Java MVC VT** confirmou ser a stack mais rápida para os 95% das requisições (**14.29ms**), seguido de perto pelo **Java WebFlux**.

### 2. Eficiência Energética (CPU)
O **Java WebFlux** demonstrou a melhor eficiência de CPU (**4.16%**) para manter o RPS alvo (~126), comprovando a vantagem do modelo non-blocking para alto throughput com baixo custo computacional.

### 3. Gerenciamento de Memória Java
A análise detalhada do Heap Java revelou que as três stacks (WebFlux, MVC VT, MVC) operam com uma pegada de memória muito similar (**~60 MB**), indicando que para este cenário de negócio, a escolha do framework não impacta significativamente o consumo de RAM no monólito.

### 4. PHP e Escalabilidade
O **Laravel Octane** manteve-se consistente com latências baixas e consumo de memória moderado (**24 MB**), validando seu uso como a única opção PHP competitiva em performance bruta com Java/Node.

## Conclusão
A análise granular por janela confirmou que a infraestrutura se comportou de forma estável para as stacks de alto desempenho. O **Java WebFlux** continua sendo a recomendação para maior densidade de requisições por watt de CPU, enquanto o **Java MVC VT** entrega a menor latência absoluta em condições de carga.
