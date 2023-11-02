
#  instalacao nvm + node + yarn
wsl windows intall nvm
instal nvm: https://github.com/coreybutler/nvm-windows/releases
install node: 
- nvm install --lts    
- nvm use 20.9.0
- nvm alias default v20.9.0       
install yarn: npm install --global yarn  

# Subir aplicacoes
## Subir react app
yarn
yarn start
abrir http://localhost:3001

## Subir vue app
yarn
yarn start
abrir http://localhost:3002

## Subir vue app menu
yarn
yarn start
abrir http://localhost:3003

## Subir angular shell
install angular cli: npm install -g @angular/cli

(nao precisa) ng new --skip-install
ng config cli.packageManager yarn
yarn install
yarn start (demora para startar)
abrir http://localhost:4201

# Explicação
Existe um projeto pai em angular que importa outros 3  projetos (react, vue, vue) que injetam na mesma pagina componentes
Esse conceito de microfroent a nivel de pagina e o utilizado nessa poc.
Todos os projeto possuem hot reload, cuidar para nao rodar dentro de wsl2 porque para de funcionar hot heload

# Aplicações
- angular-shell: projeto pai
- react-component: projeto com 1 componente profile
- vue-component: projeto com 2 componentes settings and card
- vue-component-menu: projeto com 1 componente Menu

## Referencias
https://www.darklimeteam.com/articles/blog/angular-react-vue-2023

