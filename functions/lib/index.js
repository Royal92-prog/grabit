"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateGameNumber = void 0;
const admin = require("firebase-admin");
const functions = require("firebase-functions");
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.updateGameNumber = functions.firestore.document("game/players2").onWrite((change, context) => {
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
});
//                 admin.firestore().collection("game").doc("gameNumber").get().
//                     then((snapshot) => {
//                       if (snapshot.exists) {
//                         const data = snapshot.data();
//                         if (data != null) {
//                           gameNum = data["currentNum"];
//                         }
//                       }
//                     });
//# sourceMappingURL=index.js.map