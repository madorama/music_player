(() => {
  const fs = require("fs")
  const { remote } = require("electron")

  const app = module.exports.Main.fullscreen()

  window.onload = () => {
    let context = new AudioContext()

    // ウィンドウ最小化
    app.ports.minimize.subscribe(remote.BrowserWindow.getFocusedWindow().minimize)

    document.ondrop = document.ondragover = (e) => {
      e.preventDefault()
      return false
    }
    document.body.addEventListener("drop", (e) => {
      const mm = require("music-metadata")
      const files = Array.from(e.dataTransfer.files).filter((file) => file.type.match(/^audio/))
      Promise.all(
        files.map((file) => {
          return mm.parseFile(file.path, { native: true }).then((metadata) => {
            return {
              metadata: metadata,
              path: file.path
            }
          })
        })
      ).then((m) => {
        const createNumberData = (data) => {
          return {
            no: data.no || null,
            of_: data.of || null
          }
        }
        const metas = m.map((metadata) => {
          const meta = metadata.metadata
          const tagType = meta.format.tagTypes[0]
          return {
            tagType: tagType,
            metadata: {
              album: meta.common.album || null,
              artist: meta.common.artist || null,
              artists: meta.common.artists || [],
              genres: meta.common.genre || [],
              title: meta.common.title || null,
              disk: createNumberData(meta.common.disk),
              track: createNumberData(meta.common.track),
              bpm: Number(meta.common.bpm) || null,
              duration: meta.format.duration,
              path: metadata.path
            },
            rawData: tagType == "exif" ? meta.native.exif : []
          }
        })
        app.ports.dropAudios.send(metas)
      })
    })
  }
})()
