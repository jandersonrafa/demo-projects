# Relatório de Benchmark - Comparativo de 8 Stacks

Este relatório apresenta uma comparação detalhada de desempenho entre 8 diferentes stacks tecnológicas, baseando-se nos testes de carga realizados com o k6.

## Sumário Executivo

O benchmark avaliou a capacidade de processamento (RPS), latência (média, mediana, P95 e máxima) e taxa de erro de cada implementação.

### Tabela Comparativa de Resultados

| Stack | RPS (Req/s) | Latência Média (ms) | Mediana (ms) | P95 (ms) | Latência Máx (ms) | Taxa de Erro (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Java MVC VT** | 126.61 | 10.26 | 7.68 | 14.29 | 726.29 | 0.00% |
| **Java WebFlux** | 126.59 | 10.80 | 6.88 | 15.12 | 1339.03 | 0.00% |
| **Java MVC** | 126.64 | 11.23 | 7.87 | 16.47 | 640.75 | 0.00% |
| **Node.js** | 126.60 | 13.88 | 8.94 | 19.62 | 840.99 | 0.00% |
| **Laravel Octane** | 126.57 | 18.02 | 10.70 | 41.77 | 1072.35 | 0.00% |
| **Laravel FPM** | 126.59 | 27.66 | 21.03 | 51.37 | 925.79 | 0.00% |
| **Python** | 105.91 | 547.00 | 13.81 | 4394.06 | 5564.02 | 0.00%* |
| **Laravel (Std)** | 61.11 | 3372.36 | 4382.09 | 4514.68 | 5002.85 | 0.00% |

*\* O Python apresentou uma taxa de erro residual de aproximadamente 0.0026%.*

## Análise de Desempenho

### 1. Liderança em Baixa Latência
As stacks Java dominam o topo do ranking de performance:
- **Java MVC VT (Virtual Threads)** obteve a melhor latência média (**10.26ms**).
- **Java WebFlux** obteve a melhor mediana (**6.88ms**), indicando uma consistência excepcional para a maioria das requisições.

### 2. Comparativo PHP (Laravel)
Há uma diferença drástica entre as configurações de PHP:
- **Laravel Octane** é a implementação PHP mais rápida, com latência média de **18.02ms**.
- **Laravel FPM** apresenta um desempenho sólido (**27.66ms**), sendo uma alternativa robusta ao Octane.
- **Laravel (Standard)** performou significativamente abaixo, com latência média superior a **3 segundos** e RPS limitado a **61**. Isso sugere que a configuração padrão sem otimizações de servidor (como Swoole ou RoadRunner no Octane) é o principal gargalo.

### 3. Node.js
O **Node.js** manteve-se no pelotão de elite, com resultados muito próximos ao Java, apresentando uma latência média de **13.88ms** e excelente estabilidade.

### 4. Python
O **Python** (FastAPI) apresentou um comportamento misto. Embora a mediana seja baixa (**13.81ms**), a média foi puxada para cima (**547ms**) devido a picos de latência muito altos (P95 de **4.39s**), além de ter sido a única stack a apresentar erros durante o teste, indicando instabilidade sob a carga aplicada.

## Conclusão

Para cenários que exigem a maior performance bruta e menor latência, o **Java (MVC VT ou WebFlux)** e o **Node.js** são as opções mais indicadas. No ecossistema PHP, o uso do **Laravel Octane** é indispensável para parear com as demais tecnologias de alta performance. O Python e o Laravel padrão demonstraram necessidade de ajustes de infraestrutura ou configuração para suportar a mesma carga com a mesma eficiência das demais.
