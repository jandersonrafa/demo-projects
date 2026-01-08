# Replicação Master-to-Master de MySQL com Docker

Este projeto configura uma replicação master-to-master (mestre-mestre) de MySQL usando Docker and Docker Compose.
Essa replicação consiste na verdade em um macete onde ambos os bancos de dados esta configurados com master-to-slave, um sendo o slave do outro.

Essa replicação funciona e aplica além de dml também ddl, porém eu tive problemas de conflitos de id quando inseri em ambos os lados o mesmo id em uma tabela, quando isso ocorreu ele parou a replicação e eu precisei falar para ele skipar a transação, dessa forma os bancos ficaram com dados divergentes.



## Pré-requisitos

- Docker
- Docker Compose (geralmente incluído com o Docker Desktop ou instalado como um plugin `docker compose`)

## Configuração

1.  **Arquivos de Configuração:**

    Crie um diretório `config` e os seguintes arquivos de configuração dentro dele.

    `config/master1.cnf`:
    ```ini
    [mysqld]
    server-id=1
    log-bin=mysql-bin
    binlog-do-db=my_database
    relay-log=mysql-relay-bin
    log-slave-updates=1
    read-only=0
    ```

    `config/master2.cnf`:
    ```ini
    [mysqld]
    server-id=2
    log-bin=mysql-bin
    binlog-do-db=my_database
    relay-log=mysql-relay-bin
    log-slave-updates=1
    read-only=0
    ```

2.  **Docker Compose:**

    Crie um arquivo `docker-compose.yml`:

    ```yaml
    version: '3.7'

    services:
      mysql-master-1:
        image: mysql:5.7
        container_name: mysql-master-1
        ports:
          - "3306:3306"
        environment:
          MYSQL_ROOT_PASSWORD: my-secret-pw
          MYSQL_DATABASE: my_database
          MYSQL_USER: my_user
          MYSQL_PASSWORD: my_password
        volumes:
          - ./config/master1.cnf:/etc/mysql/conf.d/my.cnf
        networks:
          - replication-net

      mysql-master-2:
        image: mysql:5.7
        container_name: mysql-master-2
        ports:
          - "3307:3306"
        environment:
          MYSQL_ROOT_PASSWORD: my-secret-pw
          MYSQL_DATABASE: my_database
          MYSQL_USER: my_user
          MYSQL_PASSWORD: my_password
        volumes:
          - ./config/master2.cnf:/etc/mysql/conf.d/my.cnf
        networks:
          - replication-net

    networks:
      replication-net:
    ```

## Executando o Ambiente

Inicie os contêineres usando o Docker Compose:

```bash
docker compose up -d
```

## Configuração da Replicação

Após os contêineres estarem em execução, execute os seguintes comandos para configurar a replicação master-to-master.

1.  **Criar Usuário de Replicação:**

    No `mysql-master-1`:
    ```bash
    docker exec mysql-master-1 mysql -uroot -pmy-secret-pw -e "CREATE USER 'repl'@'%' IDENTIFIED BY 'password'; GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%'; FLUSH PRIVILEGES;"
    ```

    No `mysql-master-2`:
    ```bash
    docker exec mysql-master-2 mysql -uroot -pmy-secret-pw -e "CREATE USER 'repl'@'%' IDENTIFIED BY 'password'; GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%'; FLUSH PRIVILEGES;"
    ```

2.  **Configurar a Replicação:**

    Primeiro, obtenha o status do master de ambos os contêineres para encontrar o arquivo de log e a posição.

    Obter status do `mysql-master-1`:
    ```bash
    docker exec mysql-master-1 mysql -uroot -pmy-secret-pw -e "SHOW MASTER STATUS;"
    ```

    Obter status do `mysql-master-2`:
    ```bash
    docker exec mysql-master-2 mysql -uroot -pmy-secret-pw -e "SHOW MASTER STATUS;"
    ```

    Use os valores de `File` e `Position` da saída dos comandos acima para executar os seguintes comandos `CHANGE MASTER TO`.
    *(Nota: Os valores `mysql-bin.000003` e `747` são exemplos e podem ser diferentes na sua configuração.)*

    No `mysql-master-2` (apontando para o `mysql-master-1`):
    ```bash
    docker exec mysql-master-2 mysql -uroot -pmy-secret-pw -e "CHANGE MASTER TO MASTER_HOST='mysql-master-1', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=747;"
    ```

    No `mysql-master-1` (apontando para o `mysql-master-2`):
    ```bash
    docker exec mysql-master-1 mysql -uroot -pmy-secret-pw -e "CHANGE MASTER TO MASTER_HOST='mysql-master-2', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=747;"
    ```

3.  **Iniciar a Replicação:**

    Inicie o processo slave em ambos os contêineres.

    ```bash
    docker exec mysql-master-1 mysql -uroot -pmy-secret-pw -e "START SLAVE;"
    docker exec mysql-master-2 mysql -uroot -pmy-secret-pw -e "START SLAVE;"
    ```

## Verificando a Replicação

Para verificar o status da replicação, execute o seguinte comando em qualquer um dos contêineres:

```bash
docker exec mysql-master-1 mysql -uroot -pmy-secret-pw -e "SHOW SLAVE STATUS\G"
```

Procure por `Slave_IO_Running: Yes` e `Slave_SQL_Running: Yes` na saída.