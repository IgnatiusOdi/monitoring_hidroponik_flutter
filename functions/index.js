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
    const data = event.data.after.val();

    const ph = data.split(",")[0];
    const ppm = data.split(",")[1];
    const suhu = data.split(",")[2];

    log("Node: ", node);
    log("Data: ", data);

    // FCM
    const payload = {
      notification: {
        title: `Data ${node}`,
        body: `${data}`,
      },
      topic: "hidroponik-flutter",
    };
    messaging.send(payload);
  }
);

exports.logPh = onValueUpdated(
  {
    ref: "/{node}/ph",
    instance: "hidroponik-flutter-default-rtdb",
    region: "asia-southeast1",
  },
  (event) => {
    const node = event.params.node;
    const ph = event.data.after.val();

    if (ph < 5.5 || ph > 6.5) {
      log("Node: ", node);
      log("pH: ", ph);

      // FCM
      const payload = {
        notification: {
          title: `pH ${node}: ${ph}`,
          body: "pH diluar batas aman!",
        },
        topic: "hidroponik-flutter"
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
          title: `Tinggi Air ${node}`,
          body: `${tinggiAir}`,
        },
        topic: "hidroponik-flutter",
      };
      messaging.send(payload);
    }
  }
);


// exports.logPpm = onValueUpdated(
//   {
//     ref: "/{node}/ppm",
//     instance: "hidroponik-flutter-default-rtdb",
//     region: "asia-southeast1",
//   },
//   (event) => {
//     const node = event.params.node;
//     const ppm = event.data.after.val();
//
//     if (ppm < 500 || ppm > 1000) {
//       log("Node: ", node);
//       log("PPM: ", ppm);
//
//       // FCM
//       const payload = {
//         notification: {
//           title: `PPM ${node}`,
//           body: `${ppm}`,
//           image: "../assets/icon.png",
//         },
//         topic: "hidroponik-flutter",
//       };
//       messaging.send(payload);
//     }
//   }
// );

// exports.logSuhu = onValueUpdated(
//   {
//     ref: "/{node}/suhu",
//     instance: "hidroponik-flutter-default-rtdb",
//     region: "asia-southeast1",
//   },
//   (event) => {
//     const node = event.params.node;
//     const suhu = event.data.after.val();

//     if (suhu < 25 || suhu > 30) {
//       log("Node: ", node);
//       log("Suhu: ", suhu);

//       // FCM
//       const payload = {
//         notification: {
//           title: `Suhu ${node}`,
//           body: `${suhu}`,
//           image: "../assets/icon.png",
//         },
//         topic: "hidroponik-flutter",
//       };
//       messaging.send(payload);
//     }
//   }
// );

