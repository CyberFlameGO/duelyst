const {
  app, ipcMain, Menu, BrowserWindow, globalShortcut, dialog,
} = require('electron');
const path = require('path');
const window = require('electron-window');
const localShortcut = require('electron-localshortcut');
const minimist = require('minimist');
const osName = require('os-name')();
const debounce = require('lodash.debounce');
const pkgJson = require('./package.json');

require('electron-debug')();

const argv = minimist(process.argv.slice(1), {
  alias: {
    windowed: 'w',
    token: 't',
    steam: 's',
    overlay: 'o',
    disableOverlay: 'd',
    inProcessGpu: 'i',
  },
  string: ['token'],
  boolean: ['windowed', 'steam', 'overlay', 'disableOverlay', 'inProcessGpu'],
});

// enable in-process gpu flag (ie if used outside Steam)
if (argv.inProcessGpu) {
  app.commandLine.appendSwitch('in-process-gpu');
}

if (argv.steam) {
  // enable Steam overlay on supported OSes or if forced
  // ensure in-process-gpu is enabled when using overlay
  const osWhitelist = ['Windows 8', 'Windows 8.1', 'Windows 10'];
  if (osWhitelist.includes(osName) || argv.overlay) {
    if (!argv.disableOverlay) {
      app.commandLine.appendSwitch('in-process-gpu');
      argv.overlay = true;
    }
  }
}

process.on('uncaughtException', (error) => {
  if (error != null && error.message != null) console.log(error.message);
  if (error != null && error.stack != null) console.log(error.stack);
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// register protocol for duelyst:// urls
app.setAsDefaultProtocolClient('duelyst');

let mainWindow = null;

// make this a single instance app
const isSecondInstance = app.makeSingleInstance((argv, workingDirectory) => {
  // Someone tried to run a second instance, we should focus our window.
  if (mainWindow) {
    if (mainWindow.isMinimized()) mainWindow.restore();
    mainWindow.focus();
  }
});

if (isSecondInstance) {
  app.quit();
}

// Note: It's important that you don't do anything with Electron
// unless it's after 'ready', or else mysterious bad things will happen
// to you.
app.on('ready', () => {
  // check for existance of token argv
  // for now can be anything - just needs to be set
  // if (pkgJson.name === 'duelyst' && argv.token === undefined) {
  //   dialog.showMessageBox({
  //     type: 'error',
  //     title: 'ERROR',
  //     message: 'Please use the launcher to start Duelyst',
  //     detail: 'You cannot start the Duelyst executable directly.',
  //     buttons: []
  //   }, app.quit)
  //   return
  // }

  // if using steam, attempt to initialize steamworks api
  // otherwise display dialog erroring out
  if (argv.steam) {
    const steamworks = require('./steam/steamworks');
    if (!steamworks || !steamworks.initAPI()) {
      console.log('steam did not init correctly');
      console.log(steamworks);
      console.log(steamworks.initAPI());
      dialog.showMessageBox({
        type: 'error',
        title: 'ERROR',
        message: 'Please use Steam to start Duelyst',
        detail: 'Steam must be running and logged in.',
        buttons: [],
      }, app.quit);
      return;
    }
  }

  // create keyboard shortcuts for win32
  // we don't need to do it for darwin because the menu takes care of it for us
  if (process.platform === 'win32') setupWin32Shortcuts();
  // create standard menu for darwin (allows cut-copy-paste)
  if (process.platform === 'darwin') {
    setupDarwinMenu();
    // open url handler (osx only)
    app.on('open-url', (event, url) => {
      dialog.showErrorBox('Welcome Back', `You arrived from: ${url}`);
      event.preventDefault();
    });
  }

  const windowOptions = {
    title: 'Duelyst',
    width: 1300,
    height: 760,
    frame: true,
    resizable: true,
    webPreferences: {
      nodeIntegration: false,
      backgroundThrottling: false,
      preload: path.join(__dirname, 'renderer-preload'),
    },
  };

  mainWindow = window.createWindow(windowOptions);

  // toggle to fullscreen after launch
  if (!argv.windowed) {
    mainWindow.setFullScreen(true);
  }

  // can access at window.__args__ from scripts
  // ran from index.html
  const argsForRenderer = {
    data: argv,
  };

  // setupDiscord();

  const indexPath = path.resolve(__dirname, 'dist/src', 'index.html');
  mainWindow.showURL(indexPath, argsForRenderer);
});

function setupWin32Shortcuts() {
  if (process.platform !== 'win32') return;

  localShortcut.register('Ctrl+R', () => {
    const focusedWindow = BrowserWindow.getFocusedWindow();
    if (focusedWindow) focusedWindow.webContents.reloadIgnoringCache();
  });
  localShortcut.register('Ctrl+Shift+I', () => {
    const focusedWindow = BrowserWindow.getFocusedWindow();
    if (focusedWindow) focusedWindow.toggleDevTools();
  });
  if (!argv.steam) {
    localShortcut.register('Ctrl+Shift+F', () => {
      const focusedWindow = BrowserWindow.getFocusedWindow();
      if (focusedWindow) focusedWindow.setFullScreen(!focusedWindow.isFullScreen());
    });
  }
  if (argv.steam && !argv.overlay) {
    localShortcut.register('Shift+Tab', () => {
      const data = {
        message: 'Steam Overlay is disabled',
        detail: 'Steam in-game Overlay is currently disabled or not supported on this OS.',
      };
      showInfoDialog(data);
    });
  }
}

function setupDarwinMenu() {
  if (process.platform !== 'darwin') return;
  if (argv.steam && !argv.overlay) {
    localShortcut.register('Shift+Tab', () => {
      const data = {
        message: 'Steam Overlay is disabled',
        detail: 'Unfortunately Steam in-game Overlay is not supported on this OS.',
      };
      showInfoDialog(data);
    });
  }
  const template = [
    {
      label: 'Duelyst',
      submenu: [
        {
          label: 'Quit',
          accelerator: 'Command+Q',
          click() {
            app.quit();
          },
        },
      ],
    },
    {
      label: 'Edit',
      submenu: [
        {
          label: 'Undo',
          accelerator: 'Command+Z',
          selector: 'undo:',
        },
        {
          label: 'Redo',
          accelerator: 'Shift+Command+Z',
          selector: 'redo:',
        },
        {
          type: 'separator',
        },
        {
          label: 'Cut',
          accelerator: 'Command+X',
          selector: 'cut:',
        },
        {
          label: 'Copy',
          accelerator: 'Command+C',
          selector: 'copy:',
        },
        {
          label: 'Paste',
          accelerator: 'Command+V',
          selector: 'paste:',
        },
        {
          label: 'Select All',
          accelerator: 'Command+A',
          selector: 'selectAll:',
        },
      ],
    },
    {
      label: 'View',
      submenu: [
        {
          label: 'Reload',
          accelerator: 'Command+R',
          click() {
            const focusedWindow = BrowserWindow.getFocusedWindow();
            if (focusedWindow) focusedWindow.webContents.reloadIgnoringCache();
          },
        },
        {
          label: 'Toggle Full Screen',
          accelerator: 'Ctrl+Command+F',
          click() {
            const focusedWindow = BrowserWindow.getFocusedWindow();
            if (focusedWindow) focusedWindow.setFullScreen(!focusedWindow.isFullScreen());
          },
        },
        {
          label: 'Toggle Developer Tools',
          accelerator: 'Alt+Command+I',
          click() {
            const focusedWindow = BrowserWindow.getFocusedWindow();
            if (focusedWindow) focusedWindow.toggleDevTools();
          },
        },
      ],
    },
    {
      label: 'Help',
      submenu: [
        {
          label: 'Support',
          click() { require('shell').openExternal('https://support.duelyst.com'); },
        },
      ],
    },
  ];
  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}

/*
function setupDiscord() {
  // Send events received from discordRpc down to the mainWindow (ie application.coffee)
  // We use a single 'discord' event with the type as second param along with any ...arguments
  mainWindow.webContents.on("did-finish-load", () => {
    // wait until mainWindow is done loading so we can be sure to catch all events
    const DISCORD_APPLICATION_ID = "357706468843061258";
    // Discord uses the Steam ID to start the application via Steam
    let STEAM_ID = null;
    if (argv.steam) {
      STEAM_ID = "291410";
    } else {
      // outside of Steam, we register the protocol handler ourself
      app.setAsDefaultProtocolClient(`discord-${DISCORD_APPLICATION_ID}`);
    }

    const DiscordRpc = require("@counterplay/discord-rpc-nodejs");
    const discordRpc = new DiscordRpc(DISCORD_APPLICATION_ID, STEAM_ID);

    discordRpc.on("ready", (...args) => {
      mainWindow.webContents.send("discord", "ready", ...args);
    });
    discordRpc.on("disconnected", (...args) => {
      mainWindow.webContents.send("discord", "disconnected", ...args);
    });
    discordRpc.on("error", (...args) => {
      mainWindow.webContents.send("discord", "error", ...args);
    });
    discordRpc.on("spectateGame", (...args) => {
      mainWindow.webContents.send("discord", "spectateGame", ...args);
    });
    discordRpc.on("joinGame", (...args) => {
      mainWindow.webContents.send("discord", "joinGame", ...args);
    });
    // this is just for testing
    // discordRpc.on('tick', (...args) => {
    //   mainWindow.webContents.send('discord', 'tick', ...args)
    // })

    // Receiver to listen for 'discord-update-presence' event sent from mainWindow
    ipcMain.on("discord-update-presence", (event, presence) => {
      discordRpc.updatePresence(presence);
    });
    // When the application quits, we have to make sure to call shutdown on discordRpc
    app.on("quit", () => {
      discordRpc.shutdown();
    });
  });
}
*/

const showInfoDialog = debounce((data) => {
  const options = {
    type: 'info',
    title: 'Information',
    buttons: ['OK'],
    message: data.message,
    detail: data.detail,
  };
  const noop = () => { };
  return dialog.showMessageBox(options, noop);
}, 1000, { leading: true, trailing: false });

ipcMain.on('create-window', (event, options) => {
  const windowOptions = {
    title: options.title || 'Paymentwall',
    width: options.width || 800,
    height: options.height || 600,
    fullscreen: false,
    resizable: false,
    show: true,
    webpreferences: {
      nodeIntegration: false,
      webSecurity: true,
    },
  };
  const win = window.createWindow(windowOptions);
  win.showURL(options.url, {}, () => { });
});

ipcMain.on('steam-error', (event, options) => {
  dialog.showMessageBox({
    type: 'error',
    title: 'ERROR',
    message: options.message || 'Unable to connect to Steam',
    detail: options.detail || 'Please restart the application using Steam.',
    buttons: [],
  }, app.quit);
});
