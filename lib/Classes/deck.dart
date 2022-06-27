import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grabit/Classes/card.dart';
import 'package:provider/provider.dart';
import '../main.dart';



Map <int,String> cardsDic = {1 : 'assets/1.svg', 2 : 'assets/2.svg', 3 : 'assets/3.svg',
  4 : 'assets/4.svg', 5 : 'assets/5.svg'};


class playerDeck extends StatelessWidget {
  late var cardsHandler;
  final int index;
  final int gameNum;
  int currentTurn = 0;
  double rightAlignment = 0.012;
  String collectionType;


  playerDeck({required this.index, required this.gameNum,
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
              if(cloudData.containsKey("player_${index}_deck")) cardsHandler = cloudData['player_${index}_deck'];
              else cardsHandler = [];
              if(currentTurn == -1 || currentTurn == -3){
                subscription.cancel();
              }

          return Stack(clipBehavior: Clip.antiAliasWithSaveLayer,
                fit: StackFit.passthrough,
                children:
                [
                  SvgPicture.asset('assets/Full_pack.svg',
                    width: 0.1 * size.width, height: 0.1 * size.height,),
                  Positioned(
                    top: 0.017 * size.height,
                    left: cardsHandler != null &&
                      cardsHandler.length > 9 ?
                      0.012 * size.width : 0.02 * size.width,
                    child: Text(
                      "${cardsHandler.length}",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 15,
                        color: Colors.black),),)
                ],);
          }
          else
            return CircularProgressIndicator(); //SizedBox(width: size.width * 0.1, height: size.height * 0.1);
        });
  }
}
