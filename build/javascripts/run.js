(() => {
  const fs = require("fs")
  const mm = require("music-metadata")
  const { remote } = require("electron")

  const app = module.exports.Main.fullscreen()

  let audio = new Audio()

  audio.addEventListener("timeupdate", () => {
    app.ports.audioUpdate.send(audio.currentTime)
  })

  audio.addEventListener("ended", () => {
    app.ports.audioEnded.send(null)
  })

  const pause = () => {
    const isPlay = !audio.paused && audio.currentTime > 0 && !audio.ended && audio.readyState > 2
    if(!isPlay) return
    audio.pause()
  }

  app.ports.play.subscribe((data) => {
    const src = data[0]
    const time = data[1]
    if(src === "") return
    if(time <= 0) {
      pause()
      audio.src = src
      audio.play()
    } else {
      audio.play()
    }
  })

  app.ports.pause.subscribe(pause)

  app.ports.setVolume.subscribe((volume) => {
    audio.volume = volume
  })

  app.ports.seek.subscribe((time) => {
    audio.currentTime = time
  })

  app.ports.minimize.subscribe(remote.BrowserWindow.getFocusedWindow().minimize)

  app.ports.close.subscribe(remote.BrowserWindow.getFocusedWindow().close)

  // 音楽データがD&Dされた時、ElmにMetadataを渡す
  document.ondrop = document.ondragover = (e) => {
    e.preventDefault()
    return false
  }
  document.body.addEventListener("drop", (e) => {
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
          rawData: tagType === "exif" ? meta.native.exif : []
        }
      })
      app.ports.dropAudios.send(metas)
    })
  })
})()
