import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit/Classes/player.dart';
import 'package:grabit/Classes/totem.dart';

import '../services/notificationServices.dart';


class GameTable extends StatelessWidget {
  GameTable({required this.playersNumber, required this.playerIndex, required this.nicknames, required this.gameNum});

  int playersNumber;
  int playerIndex;
  int gameNum;
  var nicknames;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    double player0Top =  playersNumber > 3 ? 0.08 : 0.21;
    double player1Top =  playersNumber == 4 ? 0.11 : -0.1;
    double player1Left =  playersNumber == 4 ? 0.6 : 0.34;
    double player2Top =  playersNumber > 3 ? 0.38 : 0.25;
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    //Container(color : Colors.green),
    return Stack(children:
    [
      Container(child: Image.asset('assets/Background.png',
        width: size.width, height: size.height,),),
      Center(child : SizedBox(height:1 * size.height,width:1 * size.width,
          child:Stack(children: <Widget>[
            Center(child:SvgPicture.asset('assets/WoodenTable.svg',
                height:0.72 * size.height, width:0.8 * size.width , alignment: Alignment.centerRight)),
            //this player is always of index playersNumber -2  unless there are 5 players
            Positioned(left : size.width * player1Left, top: player1Top * size.height,child:
            Player(index: playersNumber == 5 ? 2 : playersNumber - 2, playersNumber: playersNumber,
            currentTurnCallback: (isDeadEnd) {deadEndCallback(context, isDeadEnd);}, nickname: nicknames[playersNumber == 5 ? 2 : playersNumber - 2], gameNum: gameNum, deviceIndex: playerIndex)),//1
            //this player is always of index playersNumber -1
            Positioned(left : size.width * 0.6, top: player2Top * size.height,child:
            Player(index: playersNumber -1, playersNumber: playersNumber,
            currentTurnCallback: (isDeadEnd) {deadEndCallback(context, isDeadEnd);}, deviceIndex: playerIndex, gameNum: gameNum, nickname: nicknames[playersNumber -1],)),//2
            //this player exists in case there are 5 players and its index is 3
            playersNumber == 5 ? Positioned(left : size.width * 0.6,top: 0.12 * size.height,child:
            Player(index: 3, playersNumber: playersNumber, currentTurnCallback: (isDeadEnd) {deadEndCallback(context, isDeadEnd);}, nickname: nicknames[3], gameNum: gameNum,deviceIndex: playerIndex,)) :
            SizedBox(),
            //this player is always of index 0 unless there are more than 3 players
            Positioned(left : size.width * 0.09, top: player0Top * size.height, child:
            Player(index: playersNumber > 3 ? 1 : 0, playersNumber: playersNumber, currentTurnCallback: (isDeadEnd) {deadEndCallback(context, isDeadEnd);}, deviceIndex: playerIndex, gameNum: gameNum, nickname: nicknames[playersNumber > 3 ? 1 : 0],)),
            //this player is always of index 0
            playersNumber > 3 ? Positioned(left : size.width * 0.09, top: 0.35 * size.height,child:
            Player(index: 0, playersNumber: playersNumber, currentTurnCallback: (isDeadEnd) {deadEndCallback(context, isDeadEnd);}, gameNum: gameNum, nickname: nicknames[0],deviceIndex: playerIndex,)) :SizedBox(),
            //totem
            Positioned(left : size.width * 0.4, top: 0.73 * size.height,child:
            totem(index: playerIndex, playersNumber: playersNumber,
              // winnerCallback : (isDeadEnd) {deadEndCallback(context, isDeadEnd);},
              gameNum: gameNum,))
          ]))),
      GameNotifications(context: context,index: 1),
    ]);
        //;

  }

  void deadEndCallback(BuildContext context, bool isDeadEnd) async{
    int delay = isDeadEnd ? 15 : 3;
    await Future.delayed(Duration(seconds: delay));
    if (playerIndex == 0) {
      FirebaseFirestore.instance.collection('game').doc('players${gameNum}').delete();
    }
    Navigator.of(context).pop();
    // if (turn == -1) {
    //   searchOnStoppedTyping = new Timer(Duration(seconds: 8), () async {
    //     await Future.delayed(Duration(seconds: 7));
    //     print("after 15 seconds");
    //     Navigator.of(context).pop();});
    // }
    // else{
    //   searchOnStoppedTyping.cancel();
    // }
  }
}
/*



 */