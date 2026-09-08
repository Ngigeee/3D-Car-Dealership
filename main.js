const { app, BrowserWindow } = require('electron');
const path = require('path');
const { exec } = require('child_process');

let serverProcess;

function createWindow () {
  // Start your Express server (change to your server filename)
  serverProcess = exec('node index.js', (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error}`);
      return;
    }
    console.log(`stdout: ${stdout}`);
    console.error(`stderr: ${stderr}`);
  });

  // Wait briefly before launching window
  setTimeout(() => {
    const win = new BrowserWindow({
      width: 1000,
      height: 700,
      webPreferences: {
        nodeIntegration: false,
      }
    });

    // Load your running website
    win.loadURL('http://localhost:3000');
  }, 1000); // Adjust this if needed
}

app.whenReady().then(createWindow);

// Cleanup server when app closes
app.on('window-all-closed', () => {
  if (serverProcess) {
    serverProcess.kill();
  }
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
