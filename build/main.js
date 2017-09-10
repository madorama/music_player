(() => {
  const electron = require("electron")
  const path = require("path")
  const url = require("url")
  const {app, BrowserWindow, globalShortcut} = electron

  let win

  let createWindow = () => {
    win = new BrowserWindow({
      width: 400,
      height: 200,
      useContentSize: true,
      autoHideMenuBar: true,
      frame: false,
      minWidth: 250,
      minHeight: 100
    })
    win.loadURL(url.format({
      pathname: path.join(__dirname, "index.html"),
      protocol: "file:",
    }))

    win.on("closed", () => {
      win = null
    })

    win.setMenu(null)

    globalShortcut.register("ctrl+shift+i", () => {
      win.isDevToolsOpened() ? win.webContents.closeDevTools() : win.webContents.openDevTools()
    })

    globalShortcut.register("f5", () => {
      win.reload()
    })
  }

  app.on("window-all-closed", () => {
    app.quit()
  })

  app.on("ready", createWindow)

  app.on("activate", () => {
    if(win === null) createWindow()
  })
})()
