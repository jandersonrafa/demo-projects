# Referencia
https://medium.com/@azer.maslow/creating-desktop-applications-with-electron-and-react-b7f81f78c9d5

# Scripts
- `react-start": "react-scripts start`: executa somente react em modo desenvolvimento
- `react-build": "react-scripts build`: processa arquivos react e cria estaticos para produção na pasta build
- `electron": "electron .`: executa electron em modo desenvolvimento fazendo abrir uma aplicação renderizando a url onde esta rodando a aplicacao react local. Deve ser executado em conjunto com comando react-start cada um em uma aba.
- `electron-build": "electron-builder`: cria pacote com executável de aplicação electron
- `build": "npm run react-build && npm run electron-build`: pega os estaticos gerados pelo build do react e cria o pacote executável

# Executar electron e react em modo desenvolvimento
Em um prompt `npm run react-start` para executar react
Em um segundo prompt `npm run electron` para executar electron

## Construir pacote distribuivel para produção
Executar `npm run build` vai criar na pasta dist os arquivos referentes a um executavel para instalar a aplicacao electron. 
Por padrão ele vai criar um executável para a arquitetura onde está sendo executada, porém pode ser passado os sinalizados para definir se quer 
gerar executável para qual plataforma `--mac, --win, --linux`.

Pacote é gerado no dist e pode ser executado simplesmente ou usado o .deb para instalar

## Codigos importantes 
- Build in package.json: O objeto build no package.json define as configurações a serem usadas ao ser gerado o executável. É possível customizar as plataformas conforme os atributos win e linux.
- Configuração para programa inicializar com windows
    ```JAVA
    app.setLoginItemSettings({
    openAtLogin: true
    })
    ```
- Configuração para programa inicializar com windows
    ```JAVA
    app.setLoginItemSettings({
    openAtLogin: true
    })
    ```



