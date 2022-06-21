import admin = require("firebase-admin");

import * as functions from "firebase-functions";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

export const updateGameNumber =
    functions.firestore.document("game/players2").onWrite(
        (change, context) => {
          if (change.after.exists) {
            const data = change.after.data();
            if (data != null) {
              if (data["connectedNum"] == 3) {
                let gameNum = 1;
                ++gameNum;
                admin.firestore().collection("game").doc("gameNumber").set({
                  "currentNum": gameNum,
                });
              }
            }
          }
        }
    );

//                 admin.firestore().collection("game").doc("gameNumber").get().
//                     then((snapshot) => {
//                       if (snapshot.exists) {
//                         const data = snapshot.data();
//                         if (data != null) {
//                           gameNum = data["currentNum"];
//                         }
//                       }
//                     });

