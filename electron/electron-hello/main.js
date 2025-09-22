const { app, Menu, BrowserWindow, Tray, nativeImage } = require('electron');
const path = require('path');

let tray = null;
let mainWindow = null;
let isQuiting;

// Configura para inicializar com windows
app.setLoginItemSettings({
    openAtLogin: true
})

// Renderiza janela electron
function createWindow() {
    mainWindow = new BrowserWindow({
        width: 800,
        height: 600,
        webPreferences: {
            nodeIntegration: true,
        },
    });
    mainWindow.loadFile('index.html');


    mainWindow.on('minimize', function (event) {
        event.preventDefault();
        mainWindow.minimize();
    });

    // Da um overwrite no botao fechar para ao inves de parar app deixar minimizado e manter icone na bandeija
    mainWindow.on('close', function (event) {
        if (!isQuiting) {
            event.preventDefault();
            mainWindow.hide();
        }
        return false;
    });
}

// Configura icone na area de notificacao (tray do windows)
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
                app.quit();
                isQuiting = true;
            },
        },
    ]);

    tray.setContextMenu(contextMenu);
    tray.setToolTip('Aplicativo Electron');
}

app.whenReady().then(() => {
    createWindow()
    createTray();
});

app.on('before-quit', function () {
    isQuiting = true;
  });