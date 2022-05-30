import 'package:cloud_firestore/cloud_firestore.dart';

void setConnectedNum(int connectedNum) async {
  await FirebaseFirestore.instance.collection('game').doc('game1').set({'connectedPlayersNum' : connectedNum}, SetOptions(merge: true));
}

Future<String> getNicknameByIndex(int index) async{
  return FirebaseFirestore.instance.collection('game').doc('game1').get().then(
          (snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            return data['player_${index.toString()}_nickname'];
          }
        }
        return "";
      });
}