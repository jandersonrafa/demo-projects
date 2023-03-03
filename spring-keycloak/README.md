# Resumo
Projeto demostrativo com exemplo utilizando keycloak e spring boot 3
Projeto proporciona 

# Preparativos
Para esse tutorial seguimos alguns passos do tutorial "https://www.baeldung.com/spring-boot-keycloak https://wstutorial.com/rest/spring-security-oauth2-keycloak-roles.html https://wstutorial.com/rest/spring-security-oauth2-keycloak.html":
- Criamos o container via container com comando `docker run -p 8080:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:20.0.5 start-dev`
  - Acesso via admin admin
- Criamos realm `SpringBootKeyCloak`
- Criamos client `login-app`
  - Associamos a Client Scope `openid` and `roles`
- Criamos user `janderson` com credencial `janderson`
  - Associamos user com role mappings `one_authorization`, `user` and `default-roles-springbootkeycloak` 
    - `! Atenção sem a default-roles-springbootkeycloak tinha um bug que keycloak não estava retornando realm roles no endpoint user info`

# Funcionamento aplicação
Ao tentar acessar endpoint privado, caso não tenha sido feito autenticação o keycloak irá abrir uma página para login.
Porém caso queira pode ser chamado os endpoints passando header Authorization com bearer token

# Endpoints aplicação
Projeto disponibiliza 3 endpoints
- `/api/public`: endpoint público, sem necessidade de usuário logado 
- `/api/private-user`: endpoint privado que necessita de usuário com realm role user
- `/api/private-admin`: endpoint privado que necessita de usuário com realm role admin

# Endpoints keycloak
Endpoints uteis keycloak
- GET `http://localhost:8080/realms/SpringBootKeycloak/protocol/openid-connect/token`: gera toekn 
  - Passar header `Content-Type`  com value `application/x-www-form-urlencoded`
  - Passar no body:
    - chave: `client_id` valor `login-app`
    - chave: `username` valor `janderson`
    - chave: `password` valor `janderson`
    - chave: `grant_type` valor `password`
- GET `http://localhost:8080/realms/SpringBootKeycloak/protocol/openid-connect/userinfo`: obtem informações usuários no padrão passando header authorization bearer token, exemplo resposta:
  - {
    "sub": "0d47c837-f3fa-42fa-872c-552c02550bd0",
    "email_verified": true,
    "realm_access": {
        "roles": [
            "offline_access",
            "uma_authorization",
            "user"
        ]
    },
    "name": "user1 user1",
    "preferred_username": "user1",
    "given_name": "user1",
    "family_name": "user1"
  }
  - ATENCAO , se nao retornar nessse json realm_access.roles é porque seu usuário ta faltando config

# Autenticacao
A autenticação do keycloak funciona com Single Sign on (SSO).
Basicamente quando tentamos acessar endpoint protegido sem usuario o keycloak retorna tela para login.
Apos login é retornado uma serie de cookies de sessao para o browser, esses cookies nao sao visiveis no chrome porque
estao configurados como SameSite none (medida seguranca chrome), porém no momento desse projeto ainda sao exibidos no firefox.