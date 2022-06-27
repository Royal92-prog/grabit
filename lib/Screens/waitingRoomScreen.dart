import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Classes/card.dart';
import '../Classes/gameTable.dart';
import '../services/gameNumberManager.dart';

class WaitingRoom extends StatefulWidget {
  int gameNum;
  int playerIndex;


  WaitingRoom({required this.gameNum, required this.playerIndex,});

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  int _connectedNum = 0;
  var _waitTime = 30000;
  var _nicknames = [];
  var cardsArr = [];

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.playerIndex == 0){
  //     startWaiting();
  //   }
  //   else {
  //     getWaitTime();
  //   }
  //   startTimer();
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;

    return StreamBuilder <DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('game').doc(
            'players${widget.gameNum}').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data?.data() != null) {
            //final data = snapshot.data;
            //if (data != null) {
            Map<String, dynamic> cloudData = (snapshot.data?.data() as Map<
                String,
                dynamic>);
            _connectedNum = cloudData.containsKey('connectedPlayersNum')
                ? cloudData['connectedPlayersNum'] : 0;
            _nicknames = [];
            for (int i = 0; i < _connectedNum; i++) {
              if (cloudData.containsKey('player_${i}_nickname')) {
                _nicknames.add(cloudData['player_${i}_nickname']);
              }
              else {
                _nicknames.add("");
              }
            }
            //_nicknames = cloudData.containsKey('player_${i}_nickname') ? [for(int i = 0; i < _connectedNum; i++) data['player_${i}_nickname']];
            //}
            // }
          }
          if (_connectedNum == 3) {
            if (widget.playerIndex == 0) {
              startWaiting();
            }
            startTimer();
          }

          if (_connectedNum == 4 && widget.playerIndex == 3) {
            getWaitTime();
          }

          if (_connectedNum == 5) {
            startGame();
          }

          return Scaffold(backgroundColor: Colors.black, extendBody: true,
              body: Stack(
                children: [Container(child: Image.asset('assets/Background.png',
                  width: size.width, height: size.height,),),
                  Center(child: SizedBox(
                      height: 1 * size.height, width: 0.75 * size.width,
                      child: Stack(children: <Widget>[
                        Center(child: SvgPicture.asset('assets/WoodenTable.svg',
                            height: 0.65 * size.height, width: 0.75 * size
                                .width, alignment: Alignment.centerRight))
                      ]))),
                  Positioned(
                      top: size.height * 0.3, left: size.width * 0.31, child:
                  Column(
                      children: [
                        Text("PREPARING FOR \n   THE BATTLE . . .",
                          style: GoogleFonts.galindo(fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),),
                        CircularProgressIndicator(),
                        Text("Connected players : ${_connectedNum}",
                          style: GoogleFonts.galindo(fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),),
                      ])),
                ],));
        }
    );
    //Container(color : Colors.green),
  }

  void startWaiting() async {
    await FirebaseFirestore.instance.collection('game').doc(
        'game${widget.gameNum}').set({
      'waitingTimerStart': DateTime
          .now()
          .millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }

  void startTimer() {
    Timer(Duration(milliseconds: _waitTime), startGame);
  }

  void getWaitTime() async {
    return FirebaseFirestore.instance.collection('game').doc(
        'game${widget.gameNum}').get().then(
            (snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            if (data != null) {
              final timeSinceStart = DateTime
                  .now()
                  .millisecondsSinceEpoch - data['waitingTimerStart'];
              print(timeSinceStart);
              _waitTime = _waitTime - timeSinceStart.toInt();
              startTimer();
            }
          }
        }
    );
  }

  // void timeoutHandler() {
  //   if(_connectedNum < 3) {
  //     startTimer();
  //   }
  //   else {
  //     startGame();
  //   }
  // }

  void startGame() async {
    if (widget.playerIndex == 0) {
      increaseGameNum(widget.gameNum);
    }
    initializeGameData();
    // await Future.delayed(
    //     const Duration(milliseconds: 8000));
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (context) {
              return GameTable(playerIndex: widget.playerIndex,
                nicknames: _nicknames,
                gameNum: widget.gameNum,
                playersNumber: _connectedNum,
                collectionName: 'game',);
            }
        )
    );
  }/*
  void increaseGameNum(int currentGame) async {
    ++currentGame;
    await FirebaseFirestore.instance.collection('privateGame').doc('gameNumber').set({'currentNum' : currentGame}, SetOptions(merge: true));
  }*/

  void initializeGameData() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Map<String, dynamic> dataUpload = {};
    if (widget.playerIndex == 0) {
      cardsArr = [
        for(int i = 1; i <= (numberOfRegularCards +
            ((numberOfUniqueCards) * numberOfUniqueCardsRepeats)); i++) i
      ];
      cardsArr.shuffle();
      dataUpload['cardsData'] = cardsArr;

      ///ADDED here - will be initialized only by player 1
      //dataUpload['underTotemCards'] = [];
      dataUpload['totem'] = false;
      dataUpload['turn'] = 0;
      dataUpload['matchingCards'] =
      [for(int i = 0; i < (numberOfRegularCards ~/ 4); i++) 0];
      dataUpload['matchingColorCards'] = [0, 0, 0, 0];
      dataUpload['cardsActiveUniqueArray'] =
      [for(int i = 0; i < (numberOfUniqueCards + 1); i++) 0];
      Map<String, dynamic> messages = {};
      int totalCardsNum = cardsArr
          .length; //(numberOfRegularCards + ((numberOfUniqueCards)*numberOfUniqueCardsRepeats))
      int cards = (totalCardsNum / _connectedNum).toInt();
      int remainder = (totalCardsNum) % _connectedNum;
      for (int i = 0; i < _connectedNum; i++) {
        dataUpload['player_${i}_openCards'] = [];
        messages['player${i}MSGS'] = "";
        if (remainder > 0) {
          dataUpload['player_${i}_deck'] =
              cardsArr.sublist(cards * i, (cards * (i + 1))) +
                  cardsArr.sublist(
                      totalCardsNum - remainder, totalCardsNum - remainder + 1);
          remainder--;
        }
        else {
          dataUpload['player_${i.toString()}_deck'] =
              cardsArr.sublist(cards * i, (cards * (i + 1)));
        }
      }
      await _firestore.collection('game').doc('game${widget.gameNum}MSGS').
      set(messages, SetOptions(merge: true));
      await _firestore.collection('game').doc('game${widget.gameNum}')
          .set(dataUpload, SetOptions(merge: true));
    }
  }
}