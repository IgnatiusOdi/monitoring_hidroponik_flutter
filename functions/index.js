const { initializeApp } = require("firebase-admin/app")
const { getMessaging } = require("firebase-admin/messaging")
const { getDatabase } = require("firebase-admin/database")
const { log } = require("firebase-functions/logger")
const { setGlobalOptions } = require("firebase-functions/v2")
const { onValueCreated, onValueUpdated } = require("firebase-functions/v2/database")
const { onSchedule } = require("firebase-functions/v2/scheduler")

setGlobalOptions({ region: "asia-southeast1" })
initializeApp()
const messaging = getMessaging()

exports.logData = onValueCreated(
  {
    ref: "/{node}/data/*",
    instance: "hidroponik-flutter-default-rtdb",
  },
  (event) => {
    const node = event.params.node
    const data = event.data.val().toString()
    log(`Data ${node}: ${event.data.val()}`)

    const ph = data.split(",")[0]
    const ppm = data.split(",")[1]
    const suhu = data.split(",")[2]
    log(`pH: ${ph}, PPM: ${ppm}, Suhu: ${suhu}`)

    let body = ""
    if (ph != 0 && (ph < 5.5 || ph > 6.5)) body += `pH ${node}: ${ph}\n`
    if (ppm < 560) body += `Kadar PPM ${node}: ${ppm}\n`
    if (suhu < 20 || suhu > 30) body += `Suhu Air ${node}: ${suhu}\n`
    if (body.length > 0) {
      body += "Segera lakukan penyesuaian terhadap data sensor terkait!"

      // FCM
      messaging.send({
        notification: {
          title: `Data Sensor ${node}`,
          body,
        },
        topic: "hidroponik-flutter",
      })
    }
  }
)

exports.logTinggiAir = onValueUpdated(
  {
    ref: "/{node}/tinggiAir",
    instance: "hidroponik-flutter-default-rtdb",
  },
  (event) => {
    const node = event.params.node
    const tinggiAir = event.data.after.val()

    if (tinggiAir == 0) {
      log(`Tinggi Air ${node}: ${tinggiAir}`)

      // FCM
      messaging.send({
        notification: {
          title: `Tinggi Air ${node}: ${tinggiAir}`,
          body: `Segera tambahkan air pada ${node}!`,
        },
        topic: "hidroponik-flutter",
      })
    }
  }
)

exports.crontabFunction = onSchedule("0 0 * * *", async (event) => {
  const db = getDatabase()
  const date = new Date().getTime() + (7 * 60 * 60 * 1000)
  log(`Now: ${new Date(date).toLocaleDateString()}`)

  const penambahanPPM1 = (await db.ref("/node1/penambahanPPM").get()).val()
  const penambahanPPM2 = (await db.ref("/node2/penambahanPPM").get()).val()
  const diff1 = Math.floor(Math.abs(date - Date.parse(penambahanPPM1)) / (1000 * 60 * 60 * 24))
  const diff2 = Math.floor(Math.abs(date - Date.parse(penambahanPPM2)) / (1000 * 60 * 60 * 24))
  log(`penambahanPPM node1: ${diff1}, penambahanPPM node2: ${diff2}`)

  let payload = []
  let body = ""

  if (diff1 >= 7) body += "Sudah lewat 7 hari, cek kembali nutrisi pada node1"
  if (diff2 >= 7) body.length > 0 ? body += " dan node2" : body += "Sudah lewat 7 hari, cek kembali nutrisi pada node2"
  if (body.length > 0) {
    body += "!"
    payload.push({
      notification: {
        title: "Tambah Nutrisi",
        body
      },
      topic: "hidroponik-flutter",
    })
  }

  const panen1 = (await db.ref("/node1/tanaman/panen1").get()).val()
  const panen2 = (await db.ref("/node2/tanaman/panen1").get()).val()
  const d1 = Math.floor(Math.abs(date - Date.parse(panen1)) / (1000 * 60 * 60 * 24))
  const d2 = Math.floor(Math.abs(date - Date.parse(panen2)) / (1000 * 60 * 60 * 24))
  log(`panen node1: ${d1}, panen node2: ${d2}`)

  body = ""
  if (d1 <= 0) body += "node1"
  if (d2 <= 0) body.length > 0 ? body += " dan node2" : body += "node2"
  if (body.length > 0) {
    body += " sudah bisa dipanen!"
    payload.push({
      notification: {
        title: "Waktu Panen",
        body
      },
      topic: "hidroponik-flutter",
    })
  }

  if (payload.length > 0) messaging.sendEach(payload)
})