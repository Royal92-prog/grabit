import 'package:cloud_firestore/cloud_firestore.dart';

void setConnectedNum(int connectedNum) async {
  await FirebaseFirestore.instance.collection('game').doc('game1').set({'connectedPlayersNum' : connectedNum}, SetOptions(merge: true));
}