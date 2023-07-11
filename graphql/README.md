# Descrição
Projeto para testar graphql

# Graphql - Definição
Query language de api que utiliza grafos
Graphql é uma linguagem de consulta, estilo de arquitetura e conjunto de ferramentas para criar e manipular APIs
Api rest podem retornar mais dados do que o client precisa causando overfetching e fazendo maior trafego de rede (maior tempo e custo).



# Anotacoes
Endpoint painel de teste: http://localhost:8080/graphiql?path=/graphql
Endpoint graphql: http://localhost:8080/graphql
Aplicacao fornece endpoint unico /graphql que nunca mais precisara mudar
Exemplo Consulta:
```
query  {
    bookById(id: "book-1") {
        id
        name
        pageCount
        author {
            id
            firstName
            lastName
        }
    }
}
```

Exemplo array:
```
query  {
  
    books {
     id
   	 name 
   	 pageCount
    	author {
        id
        firstName
        lastName
      }  
    }
  
}
```


# Referencias
https://www.graphql-java.com/tutorials/getting-started-with-spring-boot/