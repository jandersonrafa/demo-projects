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
# Passos gerar jar com graal vm
instalar o GraalVM, configurando java_home para apontar para o jar do graalvm https://www.graalvm.org/latest/docs/getting-started/windows/

mvn -Pnative native:compile
esse passo vai gerar em target o arquivo springboot-graalvm-docker

# Passos subir docker com graalvm
Criar imagem docker com conteudo:
```
FROM ubuntu:jammy
COPY target/springboot-graalvm-docker /springboot-graalvm-docker
CMD ["/springboot-graalvm-docker"]
```

Buildar imagem
docker build -t springboot-graalvm-docker .

Executar imagem docker
docker run -p 8080:8080 springboot-graalvm-docker