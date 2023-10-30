
#  instalacao nvm + node + yarn
wsl windows intall nvm
instal nvm: https://github.com/coreybutler/nvm-windows/releases
install node: 
- nvm install --lts    
- nvm alias default v20.9.0       
install yarn: npm install --global yarn  

# Subir react app
yarn
yarn start
abrir http://localhost:3001

# Subir vue app
yarn
yarn start
abrir http://localhost:3002

# Subir angular shell
install angular cli: npm install -g @angular/cli

(nao precisa) ng new --skip-install
ng config cli.packageManager yarn
yarn install
yarn start (demora para startar)
abrir http://localhost:4201


# Referencias
https://www.darklimeteam.com/articles/blog/angular-react-vue-2023

