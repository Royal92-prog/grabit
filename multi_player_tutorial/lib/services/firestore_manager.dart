import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

void setDiceData(int dieNum, int value) async {
  await FirebaseFirestore.instance.collection('diceGame').doc('dice').set({'die$dieNum' : value}, SetOptions(merge: true));
}