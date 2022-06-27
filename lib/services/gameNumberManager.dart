import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> getGameNum() async {
  return FirebaseFirestore.instance.collection('game').doc('gameNumber').get().then(
          (snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            return data['currentNum'];
          }
        }
        return 0;
      }
  );
}

void increaseGameNum(int currentGame) async {
  ++currentGame;
  await FirebaseFirestore.instance.collection('game').doc('gameNumber').set({'currentNum' : currentGame}, SetOptions(merge: true));
}