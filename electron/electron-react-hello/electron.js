// electron.js
import { app, BrowserWindow, Tray, Menu } from 'electron';
import path from 'path';
import { fileURLToPath } from 'url';

import isDev from 'electron-is-dev';
const __filename = fileURLToPath(import.meta.url); // get the resolved path to the file
const __dirname = path.dirname(__filename); // get the name of the directory
let mainWindow;
let tray = null;
let isQuiting;

// Configura para inicializar com windows
app.setLoginItemSettings({
  openAtLogin: true
})

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true,
    },
  });

  const startURL = isDev
    ? 'http://localhost:3000'
    : `file://${path.join(__dirname, '../app/build/index.html')}`;

  mainWindow.loadURL(startURL);


  mainWindow.on('minimize', function (event) {
    console.log("Teste minimize")
    event.preventDefault();
    mainWindow.minimize();
  });

  // Da um overwrite no botao fechar para ao inves de parar app deixar minimizado e manter icone na bandeija
  mainWindow.on('close', function (event) {
    console.log("Teste close")

    if (!isQuiting) {
      event.preventDefault();
      mainWindow.hide();
    }
    return false;
  });
}


app.on('ready', () => {
  createWindow();
  createTray();
});

function createTray() {
  const trayIcon = path.join(__dirname, 'icon.png')

  tray = new Tray(trayIcon);
  const contextMenu = Menu.buildFromTemplate([
    {
      label: 'Abrir Janela',
      click: () => {
        if (mainWindow === null) {
          createWindow();
        }
        mainWindow.show();
      },
    },
    {
      label: 'Sair',
      click: () => {
        // fecha app e destroi icone tray
        // tray.destroy();
        isQuiting = true;

        app.quit();
      },
    },
  ]);

  tray.setContextMenu(contextMenu);
  tray.setToolTip('Aplicativo Electron');
}


app.on('before-quit', function () {
  isQuiting = true;
});