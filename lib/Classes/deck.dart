import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class playerDeck extends StatelessWidget {
  late var cardsHandler;
  final int index;
  final String collectionName;
  final int gameNum;
  int currentTurn = 0;
  double rightAlignment = 0.012;

  playerDeck({required this.index, required this.gameNum,
    required this.collectionName});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder <DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection(collectionName).
        doc('game${gameNum}').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot <DocumentSnapshot> snapshot) {
          StreamSubscription subscription = FirebaseFirestore.instance.collection(collectionName).
            doc('game${gameNum}').snapshots().listen((event) { });
          if (snapshot.connectionState == ConnectionState.active
          && snapshot.data != null) {
            Map<String, dynamic> cloudData = (snapshot.data?.data() as Map<String, dynamic>);
            if(cloudData.containsKey("player_${index}_deck")) cardsHandler = cloudData['player_${index}_deck'];
            else cardsHandler = [];
            if(currentTurn == -1 || currentTurn == -3){
              subscription.cancel();
            }
      return Stack(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        fit: StackFit.passthrough,
        children: [
          SvgPicture.asset('assets/Full_pack.svg',
            width: 0.1 * size.width,
            height: 0.1 * size.height,),
          Positioned(
            top: 0.017 * size.height,
            left: cardsHandler != null && cardsHandler.length > 9 ?
              0.012 * size.width : 0.02 * size.width,
            child: Text("${cardsHandler.length}",
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 15,
                color: Colors.black),),)],);
          }
          else
            return CircularProgressIndicator();
        });
  }
}
