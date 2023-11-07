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
| Métrica               | JVM | GraalVisualVm |
|-----------------------|-----|---------------|
| Tempo build image     |     |               |
| Tempo start           |     |               |
| Tamanho imagem docker |     |               |

## Tempo build e start
Teste feito com apache a/b https://www.cedric-dumont.com/2017/02/01/install-apache-benchmarking-tool-ab-on-windows/
./ab -n 10000 -c 200 http://localhost:8080/hello
./ab -n 10000 -c 200 http://localhost:8081/hello


## Requisições atendidas


