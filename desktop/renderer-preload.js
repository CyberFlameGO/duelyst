const electron = require('electron');
const uuid = require('node-uuid');

// flag we use in client to detect desktop mode
window.isDesktop = true;

// expose some electron functions to window
const { app } = electron.remote;

window.quitDesktop = app.quit;
window.uuid = uuid;
window.openUrl = electron.shell.openPath;

// expose electron's ipcRenderer but only whitelist certain channels
const { ipcRenderer } = require('electron');

const ipcWhiteList = ['create-window', 'steam-error']; // Removed discord, discord-update-presence.
window.ipcRenderer = {};
window.ipcRenderer.send = (channel, ...args) => {
  if (!ipcWhiteList.includes(channel)) return;
  ipcRenderer.send(channel, ...args);
};
window.ipcRenderer.on = (channel, ...args) => {
  if (!ipcWhiteList.includes(channel)) return;
  ipcRenderer.on(channel, ...args);
};

// parseArgs passed from main process
// args are saved to window.__args__
require('electron-window').parseArgs();

const args = window.__args__;

// initalize steam api to use on client
// set a global runtime flag if running in steam
// let's also stick steamworks api on global var
if (args.data.steam) {
  const steamworks = require('./steam/steamworks');
  if (!steamworks || !steamworks.initAPI()) {
    ipcRenderer.send('steam-error');
  }
  window.isSteam = true;
  window.steamworks = steamworks;
  window.steamworksOverlayEnabled = args.data.overlay;
}
