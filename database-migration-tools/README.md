# Opinião
- Liquibase bom para manter versionamento no github porem execução manual
- Bytebase oferece uma ui github para banco de dados muito util garantindo todo processo de code review, executando os scripts de forma automatizada e tbm oferecendo questoes como por exemplo autenticacao, agendamento de execucao
- Atlas ferramenta como se fosse o terraform do banco de ados, voce altera o estado e ele tenta gerar o script, mas achei perigoso e nos meus testes quando renomeie coluna ao inves de renomear deletou e criou uma nova, dando erro nos dados
- Flyway bom para manter versionamento no github porem execução manual e nao lida bem com condicoes

# Comparação: Liquibase, Bytebase, Atlas e Flyway

Neste projeto de demonstração, preparamos o ambiente para você testar o **Liquibase**, o **Bytebase** e o **Atlas** utilizando um banco PostgreSQL em comum.

## Como as ferramentas lidam com múltiplos ambientes (Dev, Test, Prod)?

Gerenciar massa de dados (como inserir usuários falsos apenas em `dev`) é uma preocupação padrão nessas ferramentas. A estratégia geral é separar a infraestrutura de *esquema* da infraestrutura de *dados*.

### 1. Liquibase (Contextos / Labels)
O Liquibase possui suporte nativo maravilhoso para isso através da tag `context`.
**Como funciona:**
Você adiciona `context="dev"` na definição do seu script (changeset). Quando rodar o Liquibase em Produção, você não passa nenhum contexto (ou passa `prod`), e ele ignora a inserção de teste. Quando roda na sua máquina ou no CI de testes, você passa o argumento `--contexts="dev"`.
*👉 Veja o arquivo `liquibase/changelog/db.changelog-master.sql` para um exemplo prático aplicado!*

### 2. Flyway (Separação por Pastas / Locations)
O Flyway não possui "contextos" nativos gratuitos granulares como o Liquibase por SQL puro, mas a solução adotada na comunidade é gerenciar pelas pastas (Locations).
**Como funciona:**
Você organiza os scripts em subpastas: `sql/common/` (para tabelas reais, que vai para produção) e `sql/dev/` (com scripts como `V999__massa.sql`). 
Na hora de rodar o script `./run-flyway.sh`, ele aceita um argumento de ambiente:
- `./run-flyway.sh prod`: Mapeia apenas `sql/common`.
- `./run-flyway.sh dev`: Mapeia `sql/common` E `sql/dev`.
*👉 Veja o script `flyway/run-flyway.sh` para ver como a lógica de shell faz essa seleção dinâmica.*

### 3. Atlas (Configuração de Envs no HCL)
No Atlas, isso é controlado pelo sistema de ambientes no arquivo `atlas.hcl`. Você criaria envs distintos: `env "dev"` e `env "prod"`. No ambiente `prod`, o atlas apenas sincroniza o esquema. No ambiente `dev`, você usaria *Data Scripts* (ou faria a aplicação cuidar do seed de dados conectando no banco). Como o Atlas é focado fortemente no layout DDL da tabela (schema), popular dados puramente DML muitas vezes é feito pós-migração.

### 4. Bytebase
Sendo voltado para governança visual, o Bytebase possui o conceito de **Tenants e Environments** nativamente na UI. Você categoriza os bancos entre "Test" e "Prod". Quando você submete um Ticket/Issue SQL, o analista aprova explicitamente para rolar no ambiente `Test`. Você mesmo restringe no painel para que aquele script de massa de dados nem sequer chegue até `Prod`. 


---

## 1. Abordagem e Foco
- **Liquibase**: Ferramenta clássica baseada em versão/CLI (imperativa e focada em migrações sequenciais). Focada em desenvolvedores e ciclo CI/CD. As mudanças são tratadas como scripts (SQL, XML, YAML) que devem ser rodados na ordem certa.
- **Flyway**: Muito semelhante ao Liquibase, baseada em versão e execução imperativa estritamente sequencial. Focada em simplicidade, lidando de forma excelente e super simples com arquivos `.sql` puros (`V1__...`, `V2__...`). É extremamente popular no ecossistema Java, mas muito usada em diversas stacks pela sua facilidade.
- **Atlas**: Ferramenta moderna que suporta tanto migração declarativa (como o Terraform) quanto versionada. Focada na automação do código e CI/CD moderno, com forte apelo a "Schema-as-Code" (esquemas como código). Inspeciona o estado atual e calcula o `diff` automaticamente.
- **Bytebase**: Plataforma visual focada em DBAs, DevOps e governança. Possui uma rica Interface Web centralizada com aprovações, controle de acesso e automação de linting.

## 2. Fluxo de Trabalho (Workflow)
- **Liquibase**:
  1. O desenvolvedor escreve scripts de `up` e `down` em uma pasta.
  2. O pipeline detecta e aplica `liquibase update`.
- **Flyway**:
  1. O desenvolvedor escreve scripts SQL prefixados rigorosamente por versão (ex: `V1__init.sql`).
  2. O Flyway (via CLI, pipeline ou inicialização da aplicação) executa os arquivos pendentes em ordem.
- **Atlas**:
  1. Pode trabalhar declarativamente: o desenvolvedor muda o esquema final em um arquivo (ex: `schema.sql` ou `atlas.hcl`).
  2. A ferramenta lê o banco alvo, compara com o arquivo desejado e gera/executa comandos SQL dinâmicos (diff) para sincronizar.
- **Bytebase**:
  1. O desenvolvedor submete um "Issue" via UI (ou GitOps).
  2. O Bytebase executa *linting* automático e aguarda a revisão de um humano.
  3. Após aprovado, o Bytebase aplica as modificações.

## 3. Resumo: Qual escolher?
- Escolha **Liquibase** se sua equipe prefere controle migração-a-migração explicita, usa vários formatos (xml/yaml) ou necessita de funcionalidade de rollback forte fora de SQL.
- Escolha **Flyway** se você quer simplicidade extrema baseada em scripts de SQL puros baseados em versionamento linear e controle via CLI.
- Escolha **Atlas** se sua equipe quer a agilidade do "Terraform para banco de dados" (declarativo), onde a ferramenta se vira para gerar os DIFFs e manter o banco no estado do código-fonte, ou deseja um CI robusto para as migrações.
- Escolha **Bytebase** se o gargalo é "quem aprova e quando" e você precisa de auditoria, painel visual e controle rígido corporativo.

---

## Como usar este repositório de testes

Subimos um `docker-compose` contendo o PostgreSQL alvo e a plataforma do Bytebase. O Liquibase, o Atlas e o Flyway estão configurados para rodar via CLI localmente através de scripts usando containers efêmeros.

1. **Inicie os bancos e serviços:**
   ```bash
   docker-compose up -d
   ```

2. **Testando o Liquibase:**
   Navegue até `liquibase/` e execute `./run-liquibase.sh` para rodar a migração tradicional (sequencial). Note que ele vai rodar um changeset específico para contexto "dev".

3. **Testando o Flyway:**
   Navegue até `flyway/` e execute `./run-flyway.sh` para rodar a migração baseada puramente em scripts SQL sequenciais (`V1__...`). Note que ele mapeia a pasta `sql-dev` como location para popular dados de teste.

4. **Testando o Atlas:**
   Navegue até `atlas/` e execute `./run-atlas.sh` para testar a abordagem declarativa (comparação de estado desejado vs atual).

5. **Testando o Bytebase:**
   Acesse a pasta `bytebase/` para ler as instruções de como configurar pela interface web. A interface já estará rodando em `http://localhost:8080`.
