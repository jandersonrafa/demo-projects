# Testando o Bytebase

O container do Bytebase deve estar rodando na mesma rede do seu PostgreSQL. 

Para testar o fluxo de aprovação de migrações em interface visual:

1. Suba o ambiente (na raiz do projeto):
   ```bash
   docker-compose up -d
   ```

2. Acesse `http://localhost:8080`.
3. Ao abrir pela primeira vez, o Bytebase solicitará a criação de um usuário "Admin".
4. Vá em **"Environments"** e verifique os ambientes padrões (geralmente ele cria `Test` e `Prod`).
5. Vá em **"Instances"** -> **Add Instance**:
   - **Environment**: Selecione algum (ex: `Test`).
   - **Database Type**: `PostgreSQL`
   - **Host ou Endpoint**: `demo_postgres` *(O Bytebase enxerga o Postgres pelo hostname do container graças à network do Docker)*
   - **Port**: `5432`
   - **Username**: `demo_user`
   - **Password**: `demo_password`
   - Teste a conexão e salve.

6. Vá em **"Projects"** -> Novo Projeto e adicione o banco de dados `demo_db` ao seu projeto.
7. Com o banco de dados mapeado, clique em **"Issues"** ou "Database" -> **Alter Schema** e crie uma "Issue" preenchendo o código SQL (exemplo: `CREATE TABLE products (id INT PRIMARY KEY);`).
8. Você verá as etapas de `SQL Review`, onde ferramentas automáticas analisam seus comandos e possíveis violações de política antes que qualquer humano aprove a migração ou ela aplique no banco.
