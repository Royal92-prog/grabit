import 'package:cloud_firestore/cloud_firestore.dart';

void setConnectedNum(int connectedNum) async {
  await FirebaseFirestore.instance.collection('game').doc('players1').set({'connectedPlayersNum' : connectedNum}, SetOptions(merge: true));
}

void initializePlayers() async {
  await FirebaseFirestore.instance.collection('game').doc('players1').set({
    'player_0_nickname' : "",
    'player_1_nickname' : "",
    'player_2_nickname' : "",
    'connectedPlayersNum' : 0
      }, SetOptions(merge: true));
}

void updateNicknameByIndex(int index, String nickname) async {
  await FirebaseFirestore.instance.collection('game').doc('players1').set({
    'player_${index.toString()}_nickname' : nickname
  }, SetOptions(merge: true));
}

Future<int> getConnectedNum() async {
  return FirebaseFirestore.instance.collection('game').doc('players1').get().then(
          (snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            return data['connectedPlayersNum'];
          }
        }
        return 0;
      }
  );
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