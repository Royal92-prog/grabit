import 'package:cloud_firestore/cloud_firestore.dart';

void setConnectedNum(int connectedNum, int gameNum) async {
  await FirebaseFirestore.instance.collection('game').doc('players${gameNum}').set({'connectedPlayersNum' : connectedNum}, SetOptions(merge: true));
}

void initializePlayers(int gameNum) async {
  await FirebaseFirestore.instance.collection('game').doc('players${gameNum}').set({
    'player_0_nickname' : "",
    'player_1_nickname' : "",
    'player_2_nickname' : "",
    'player_3_nickname' : "",
    'player_4_nickname' : "",
      }, SetOptions(merge: true));
}

void updateNicknameByIndex(int index, String nickname, int gameNum) async {
  await FirebaseFirestore.instance.collection('game').doc('players${gameNum}').set({
    'player_${index.toString()}_nickname' : nickname
  }, SetOptions(merge: true));
}

Future<int> getConnectedNum(int gameNum) async {
  return FirebaseFirestore.instance.collection('game').doc('players${gameNum}').get().then(
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

Future<String> getNicknameByIndex(int index, int gameNum) async{
  return FirebaseFirestore.instance.collection('game').doc('game${gameNum}').get().then(
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