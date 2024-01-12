https://www.baeldung.com/java-graalvm-docker-image


# Validar versao spring 3
```JAVA
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>3.1.4</version>
</dependency>
```

# adicionar dependencia
```JAVA
<build>
    <plugins>
        <plugin>
            <groupId>org.graalvm.buildtools</groupId>
            <artifactId>native-maven-plugin</artifactId>
            <version>0.9.27</version>
        </plugin>
    </plugins>
</build>
```

# Como subir docker com graalvm
https://www.graalvm.org/latest/reference-manual/native-image/guides/containerise-native-executable-and-run-in-docker-container/

docker build -f dockerfiles/DockerfileGraalvm -t graalvm:0.0.1-SNAPSHOT .

docker run --rm --name graalvm -p 8080:8080 graalvm:0.0.1-SNAPSHOT

curl http://localhost:8080/hello

# Como subir docker com jvm
https://www.graalvm.org/latest/reference-manual/native-image/guides/containerise-native-executable-and-run-in-docker-container/

docker build -f dockerfiles/DockerfileJvm -t jvm:0.0.1-SNAPSHOT .

docker run --rm --name jvm -p 8081:8080 jvm:0.0.1-SNAPSHOT

curl http://localhost:8081/hello


# Estrategia adotada
Esse projeto utiliza a estrategia de buildar e subir a imagem no meso dockerfile  a partir de duas imagens.
Poderia ter sido optado por buildar a imagem por fora e apenas subir a imagem com o dockerfile, porém para buildar a imagem por
fora seria necessario instalar graalvm e apontar a JAVA_HOME para o graalvm baixado, para evitar isso optamos por buildar na imagem docker.

# Comparações
Devido ao projeto ser um projeto praticamente zerado com apenas algumas classes esse teste não é 100% confiável, o ideal seria testar em projeto real e maior.
Evidencias na pasta ./evidencias
Mas resolvemos comparar as seguintes questões: 

## Tempo build e start
| Métrica               | JVM    | GraalVisualVm |
|-----------------------|--------|---------------|
| Tempo build image     | 141.5s | 1321.6s       |
| Tempo start           | 8s     | 0,148s        |
| Tamanho imagem docker | 198mb  | 194mb         |

## Tempo build e start
Teste feito com apache a/b https://www.cedric-dumont.com/2017/02/01/install-apache-benchmarking-tool-ab-on-windows/
./ab -n 10000 -c 200 http://localhost:8080/hello
./ab -n 10000 -c 200 http://localhost:8081/hello


## Requisições atendidas
Teste com 10 mil requisições paralelizadas em 200 thredas

## Bateria 1 (aquecimento de 2 exec)
| Métrica                 | JVM    | GraalVisualVm |
|-------------------------|--------|---------------|
| Tempo total             | 31.07s | 31,07s        |
| Req por segundo         | 321.81 | 322,51        |
| Tempo médio por request | 621ms  | 620ms         |

## Bateria 2 (aquecimento de 1 exec)
| Métrica                 | JVM    | GraalVisualVm |
|-------------------------|--------|---------------|
| Tempo total             | 32.86s | 35,53s        |
| Req por segundo         | 304.25 | 281,39        |
| Tempo médio por request | 657ms  | 710ms         |

# Comparação uso de recursos
Limita cpu e ram

docker run --cpus=1 --memory=512m --rm --name graalvm -p 8081:8080 -p 9090:9090 graalvm:0.0.1-SNAPSHOT
docker run --cpus=1 --memory=512m --rm --name jvm -p 8081:8080 -p 9090:9090 jvm:0.0.1-SNAPSHOT


| Métrica | JVM    | GraalVisualVm |
|---------|--------|---------------|
| Cpu     | | |
| Memoria |  |        |


