# Introdução
Configurar replicacao multimaster com 3 bancos usando innodb group replication

https://dev.mysql.com/blog-archive/setting-up-mysql-group-replication-with-mysql-docker-images/

# Subir containers
## Node 1
docker run -d \
  --name=node1 \
  --net=groupnet \
  --hostname=node1 \
  -p 3306:3306 \
  -p 33061:33061 \
  -v $PWD/d1:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=mypass \
  -e MYSQL_ROOT_HOST=% \
  mysql/mysql-server:5.7 \
  --server-id=1 \
  --log-bin='mysql-bin-1.log' \
  --enforce-gtid-consistency='ON' \
  --log-slave-updates='ON' \
  --gtid-mode='ON' \
  --transaction-write-set-extraction='XXHASH64' \
  --binlog-checksum='NONE' \
  --master-info-repository='TABLE' \
  --relay-log-info-repository='TABLE' \
  --plugin-load='group_replication.so' \
  --relay-log-recovery='ON' \
  --group-replication-start-on-boot='OFF' \
  --group-replication-group-name='aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee' \
  --group-replication-local-address="node1:33061" \
  --group-replication-group-seeds='node1:33061,node2:33061,node3:33061' \
  --loose-group-replication-single-primary-mode='OFF' \
  --loose-group-replication-enforce-update-everywhere-checks='ON'
  
## Node 2
docker run -d \
  --name=node2 \
  --net=groupnet \
  --hostname=node2 \
  -p 3307:3306 \
  -p 33062:33061 \
  -v $PWD/d2:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=mypass \
  -e MYSQL_ROOT_HOST=% \
  mysql/mysql-server:5.7 \
  --server-id=2 \
  --log-bin='mysql-bin-1.log' \
  --enforce-gtid-consistency='ON' \
  --log-slave-updates='ON' \
  --gtid-mode='ON' \
  --transaction-write-set-extraction='XXHASH64' \
  --binlog-checksum='NONE' \
  --master-info-repository='TABLE' \
  --relay-log-info-repository='TABLE' \
  --plugin-load='group_replication.so' \
  --relay-log-recovery='ON' \
  --group-replication-start-on-boot='OFF' \
  --group-replication-group-name='aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee' \
  --group-replication-local-address="node2:33061" \
  --group-replication-group-seeds='node1:33061,node2:33061,node3:33061' \
  --loose-group-replication-single-primary-mode='OFF' \
  --loose-group-replication-enforce-update-everywhere-checks='ON'
  
  ## Node 3
  docker run -d \
  --name=node3 \
  --net=groupnet \
  --hostname=node3 \
  -p 3308:3306 \
  -p 33063:33061 \
  -v $PWD/d3:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=mypass \
  -e MYSQL_ROOT_HOST=% \
  mysql/mysql-server:5.7 \
  --server-id=3 \
  --log-bin='mysql-bin-1.log' \
  --enforce-gtid-consistency='ON' \
  --log-slave-updates='ON' \
  --gtid-mode='ON' \
  --transaction-write-set-extraction='XXHASH64' \
  --binlog-checksum='NONE' \
  --master-info-repository='TABLE' \
  --relay-log-info-repository='TABLE' \
  --plugin-load='group_replication.so' \
  --relay-log-recovery='ON' \
  --group-replication-start-on-boot='OFF' \
  --group-replication-group-name='aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee' \
  --group-replication-local-address="node3:33061" \
  --group-replication-group-seeds='node1:33061,node2:33061,node3:33061' \
  --loose-group-replication-single-primary-mode='OFF' \
  --loose-group-replication-enforce-update-everywhere-checks='ON'
  
# Configurando e iniciando o GR nos contêineres
## Para configurar node 1
docker exec -it node1 mysql -uroot -pmypass \
  -e "SET @@GLOBAL.group_replication_bootstrap_group=1;" \
  -e "create user 'repl'@'%';" \
  -e "GRANT REPLICATION SLAVE ON *.* TO repl@'%';" \
  -e "flush privileges;" \
  -e "change master to master_user='repl' for channel 'group_replication_recovery';" \
  -e "START GROUP_REPLICATION;" \
  -e "SET @@GLOBAL.group_replication_bootstrap_group=0;" \
  -e "SELECT * FROM performance_schema.replication_group_members;"
  
## Para configurar node 2 e 3
docker exec -it node2 mysql -uroot -pmypass \
  -e "change master to master_user='repl' for channel 'group_replication_recovery';" \
  -e "START GROUP_REPLICATION;"

docker exec -it node3 mysql -uroot -pmypass \
  -e "change master to master_user='repl' for channel 'group_replication_recovery';" \
  -e "START GROUP_REPLICATION;"

## Verificar status
docker exec -it node1 mysql -uroot -pmypass \
  -e "SELECT * FROM performance_schema.replication_group_members;"


# Dicas gerais
Após container cair, quando voltar precisa registrar de volta no cluster com:
docker exec -it <container_name> mysql -uroot -pmypass \
  -e "change master to master_user='repl' for channel 'group_replication_recovery';" \
  -e "START GROUP_REPLICATION;"

--group-replication-start-on-boot='OFF': essa configuração sinalizar para container registar automaticamente no cluster quando iniciar 

--loose-group-replication-single-primary-mode: isso habilita para ter escrita somente em um nodo ou ter escrita em todos via multimaster

--loose-group-replication-enforce-update-everywhere-checks: resolve conflito de ids, ou seja, sempre quando dois bancos iniciarem transacao e tentarem alterar o mesmo id somente o primeiro vai passar o segundo sera revertido