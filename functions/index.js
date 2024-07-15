// The Cloud Functions for Firebase SDK to setup triggers and logging.
const { initializeApp } = require("firebase-admin/app");
const { getMessaging } = require("firebase-admin/messaging");
const { log } = require("firebase-functions/logger");
const { onValueUpdated } = require("firebase-functions/v2/database");

// The Firebase Admin SDK to access the Firebase Realtime Database.
initializeApp();
const messaging = getMessaging();

exports.logData = onValueUpdated(
  {
    ref: "/{node}/data",
    instance: "hidroponik-flutter-default-rtdb",
    region: "asia-southeast1",
  },
  (event) => {
    const node = event.params.node;
    const data = event.data.after.val().toString();

    const ph = data.split(",")[0];
    const ppm = data.split(",")[1];
    const suhu = data.split(",")[2];

    log("Node: ", node);
    log("Data: ", data);

    if (ph < 5.5 || ph > 6.5) {
      // FCM
      const payload = {
        notification: {
          title: `pH ${node}: ${ph}`,
          body: `pH ${node} diluar batas aman!`,
        },
        topic: "hidroponik-flutter"
      };
      messaging.send(payload);
    }

    if (ppm < 500 || ppm > 1000) {
      // FCM
      const payload = {
        notification: {
          title: `PPM ${node}: ${ppm}`,
          body: `PPM ${node} diluar batas aman!`,
        },
        topic: "hidroponik-flutter",
      };
      messaging.send(payload);
    }

    if (suhu < 25 || suhu > 30) {
      // FCM
      const payload = {
        notification: {
          title: `Suhu ${node}: ${suhu}`,
          body: `Suhu ${node} diluar batas aman!`,
        },
        topic: "hidroponik-flutter",
      };
      messaging.send(payload);
    }
  }
);

exports.logTinggiAir = onValueUpdated(
  {
    ref: "/{node}/tinggiAir",
    instance: "hidroponik-flutter-default-rtdb",
    region: "asia-southeast1",
  },
  (event) => {
    const node = event.params.node;
    const tinggiAir = event.data.after.val();

    if (tinggiAir == 0) {
      log("Node: ", node);
      log("Tinggi Air: ", tinggiAir);

      // FCM
      const payload = {
        notification: {
          title: `Tinggi Air ${node}: ${tinggiAir}`,
          body: `Tinggi Air ${node} dibawah batas aman!`,
        },
        topic: "hidroponik-flutter",
      };
      messaging.send(payload);
    }
  }
);