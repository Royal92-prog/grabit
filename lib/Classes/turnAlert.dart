import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
const numberOfRegularCards = 72;
const numberOfUniqueCards = 3;
const numberOfUniqueCardsRepeats = 2 ;

class TurnAlert extends StatelessWidget {
  final int index;
  final int gameNum;
  String collectionType;
  late int currentTurn;

  TurnAlert({required this.index, required this.gameNum,
    required this.collectionType});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder <DocumentSnapshot<Map<String, dynamic>>>(//<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection(collectionType).
        doc('game${gameNum}').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot <DocumentSnapshot> snapshot) {
          StreamSubscription subscription = FirebaseFirestore.instance.collection(collectionType).
          doc('game${gameNum}').snapshots().listen((event) { });
          if (snapshot.connectionState == ConnectionState.active && snapshot.data?.data() != null) {
              Map<String, dynamic> cloudData = (snapshot.data?.data() as Map<String, dynamic>);
              currentTurn = (cloudData.containsKey('turn')) == true ?
                cloudData['turn'] : 0;
              if(currentTurn == -1 || currentTurn == -3){
                subscription.cancel();
              }


            return Stack(children: [Image.asset('assets/game/woodenTurn.png',
              width: 0.135 * size.width,
              height: 0.11 * size.height), currentTurn == index ?
                  Positioned(
                    left: size.width * 0.02,
                    child: Image.asset('assets/game/your_turn_text.png',
                      width: 0.095 * size.width,
                      height: 0.09 * size.height)) : SizedBox(),]);
          }
          else
            return SizedBox(); //SizedBox(width: size.width * 0.1, height: size.height * 0.1);
        });
  }

}



