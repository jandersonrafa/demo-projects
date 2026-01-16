# 📉 Relatório de Benchmark - Resumo Executivo (2200 RPS - 24 Minutos)

## 📋 Sumário Executivo

Este documento resume os resultados do teste de carga de **24 minutos** com alvo de **2200 RPS**.

A análise foi corrigida para evidenciar o impacto das **Dropped Iterations** (requisições não enviadas), que mascaravam a falha de stacks como Python e PHP FPM.

---

## 🚦 Status Final (Métricas Reais)

| Stack | Taxa Real Sucesso* | RPS Útil | Dropped Iterations | Veredito |
|-------|---------------------|----------|--------------------|----------|
| **Java MVC VT** | **99.92%** | ~1,249 | ~1.4k (Baixo) | ✅ **Aprovado** |
| **Java WebFlux** | **99.84%** | ~1,248 | ~2.8k (Baixo) | ✅ **Aprovado** |
| **Java MVC** | **99.88%** | ~1,248 | ~2.2k (Baixo) | ✅ **Aprovado** |
| **PHP Octane** | 31.35% | ~392 | ~1.06M (Crítico) | ⚠️ **Instável** |
| **PHP FPM** | 28.54% | ~357 | ~1.28M (Crítico) | ❌ **Saturado** |
| **Python** | 28.07% | ~351 | ~1.29M (Crítico) | ❌ **Saturado** |
| **Node.js** | 8.43% | ~105 | ~39k (Colapso) | ❌ **Falha Total** |

*\*Taxa Real considera Sucesso / (Sucesso + Erros + Dropped).*

---

## 🔍 Principais Insights Revisados

1.  **A ilusão dos "0 erros"**: Python e PHP FPM reportaram 0 ou poucos erros HTTP, mas na verdade **deixaram de processar ~70% da carga** (Dropped Iterations). O sistema ficou tão lento que não aceitava novas requisições.

2.  **Resiliência Java**: Apenas as stacks Java conseguiram processar a carga (com perda desprezível de < 0.2%).

3.  **Falha "Fail-Fast" do Node**: O Node.js falhou com erros explícitos (5xx) em vez de timeouts longos. Embora a taxa de sucesso seja a pior (8%), o fail-fast é as vezes preferível ao "hang" do Python/PHP, mas requer tratamento de erro no cliente.

## 💡 Conclusão

Para suportar **2200 RPS** (ou mesmo 1000 RPS) nesta infraestrutura, **Java** é a única tecnologia aprovada. As demais stacks colapsaram ou saturaram severamente em ~350 RPS.
