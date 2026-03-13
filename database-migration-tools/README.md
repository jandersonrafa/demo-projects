# Opinião
- Liquibase bom para manter versionamento no github porem execução manual
- Bytebase oferece uma ui github para banco de dados muito util garantindo todo processo de code review, executando os scripts de forma automatizada e tbm oferecendo questoes como por exemplo autenticacao, agendamento de execucao
- Atlas ferramenta como se fosse o terraform do banco de ados, voce altera o estado e ele tenta gerar o script, mas achei perigoso e nos meus testes quando renomeie coluna ao inves de renomear deletou e criou uma nova, dando erro nos dados

# Comparação: Liquibase, Bytebase e Atlas

Neste projeto de demonstração, preparamos o ambiente para você testar o **Liquibase**, o **Bytebase** e o **Atlas** utilizando um banco PostgreSQL em comum.

## 1. Abordagem e Foco
- **Liquibase**: Ferramenta clássica baseada em versão/CLI (imperativa e focada em migrações sequenciais). Focada em desenvolvedores e ciclo CI/CD. As mudanças são tratadas como scripts (SQL, XML, YAML) que devem ser rodados na ordem certa.
- **Atlas**: Ferramenta moderna que suporta tanto migração declarativa (como o Terraform) quanto versionada. Focada na automação do código e CI/CD moderno, com forte apelo a "Schema-as-Code" (esquemas como código). Inspeciona o estado atual e calcula o `diff` automaticamente.
- **Bytebase**: Plataforma visual focada em DBAs, DevOps e governança. Possui uma rica Interface Web centralizada com aprovações, controle de acesso e automação de linting.

## 2. Fluxo de Trabalho (Workflow)
- **Liquibase**:
  1. O desenvolvedor escreve scripts de `up` e `down` em uma pasta.
  2. O pipeline detecta e aplica `liquibase update`.
- **Atlas**:
  1. Pode trabalhar declarativamente: o desenvolvedor muda o esquema final em um arquivo (ex: `schema.sql` ou `atlas.hcl`).
  2. A ferramenta lê o banco alvo, compara com o arquivo desejado e gera/executa comandos SQL dinâmicos (diff) para sincronizar.
- **Bytebase**:
  1. O desenvolvedor submete um "Issue" via UI (ou GitOps).
  2. O Bytebase executa *linting* automático e aguarda a revisão de um humano.
  3. Após aprovado, o Bytebase aplica as modificações.

## 3. Resumo: Qual escolher?
- Escolha **Liquibase** se sua equipe prefere controle migração-a-migração explicita (sequencial) de longa data.
- Escolha **Atlas** se sua equipe quer a agilidade do "Terraform para banco de dados" (declarativo), onde a ferramenta se vira para gerar os DIFFs e manter o banco no estado do código-fonte, ou deseja um CI robusto para as migrações.
- Escolha **Bytebase** se o gargalo é "quem aprova e quando" e você precisa de auditoria, painel visual e controle rígido corporativo.

---

## Como usar este repositório de testes

Subimos um `docker-compose` contendo o PostgreSQL alvo e a plataforma do Bytebase. O Liquibase e o Atlas estão configurados para rodar via CLI localmente através de scripts usando containers efêmeros.

1. **Inicie os bancos e serviços:**
   ```bash
   docker-compose up -d
   ```

2. **Testando o Liquibase:**
   Navegue até `liquibase/` e execute `./run-liquibase.sh` para rodar a migração tradicional (sequencial).

3. **Testando o Atlas:**
   Navegue até `atlas/` e execute `./run-atlas.sh` para testar a abordagem declarativa (comparação de estado desejado vs atual).

4. **Testando o Bytebase:**
   Acesse a pasta `bytebase/` para ler as instruções de como configurar pela interface web. A interface já estará rodando em `http://localhost:8080`.
