1. Tipo de Replicação (Síncrona vs. Assíncrona)

   * Estratégia Atual (Assíncrona): A replicação é "otimista". O master-1 confirma a transação primeiro e depois
     a envia para o master-2. Há um pequeno atraso (lag) e não há garantia de que o master-2 recebeu a alteração
     no momento em que a aplicação recebe o "OK".
   * Group Replication (Quase-Síncrona): A replicação é "pessimista". Antes de uma transação ser confirmada no
     nó de origem, uma maioria dos nós do cluster precisa concordar e certificar que a transação não tem
     conflitos. Só então a aplicação recebe o "OK". Isso garante que a alteração está segura em múltiplos
     lugares.

  2. Gerenciamento de Conflitos

   * Estratégia Atual: Nenhum. Como você viu, se você inserir o mesmo dado em ambos os mestres, a replicação
     quebra e exige intervenção manual. A responsabilidade de evitar conflitos é totalmente da aplicação.
   * Group Replication: Automático. Se dois nós tentarem confirmar uma transação conflitante ao mesmo tempo, o
     cluster detecta o conflito. A primeira transação a ser validada passa, e a segunda é automaticamente 
     revertida (rollback) no nó de origem. A aplicação recebe um erro e pode tentar novamente, mas os dados no
     cluster nunca se tornam inconsistentes.

  3. Tolerância a Falhas (Failover)

   * Estratégia Atual: Manual. Se o master-1 falhar, a sua aplicação precisa ser manualmente (ou por scripts
     externos) redirecionada para o master-2. Não há um failover automático.
   * Group Replication: Automático. O cluster sabe quais membros estão online. Se um nó falha, ele é removido do
     grupo. Usando uma ferramenta como o MySQL Router, a sua aplicação pode ser redirecionada automaticamente
     para um nó saudável, sem intervenção manual.

  Resumo


  ┌────────────────┬───────────────────────────────────┬─────────────────────────────────────────┐
  │ Característica │ Master-to-Master (Atual)          │ InnoDB Cluster (Group Replication)      │
  ├────────────────┼───────────────────────────────────┼─────────────────────────────────────────┤
  │ Modelo         │ Assíncrono                        │ Quase-Síncrono                          │
  │ Conflitos      │ Quebram a replicação (manual)     │ Detectados e revertidos (automático)    │
  │ Failover       │ Manual                            │ Automático (com MySQL Router)           │
  │ Consistência   │ Eventual (pode divergir)          │ Forte (garantida no cluster)            │
  │ Ideal para     │ Cenários simples, backup, leitura │ Alta disponibilidade, sistemas críticos │
  └────────────────┴───────────────────────────────────┴─────────────────────────────────────────┘


  Em suma, a estratégia que usamos é mais antiga e frágil, adequada para cenários mais simples. Uma solução
  como o InnoDB Cluster é um verdadeiro sistema de alta disponibilidade e consistência de dados, muito mais
  robusto para ambientes de produção.
