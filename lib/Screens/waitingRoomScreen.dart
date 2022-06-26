import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitingRoom extends StatelessWidget {
  int connectedNum;
  WaitingRoom({required this.connectedNum});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    //Container(color : Colors.green),
    return Scaffold(backgroundColor: Colors.black,extendBody: true,
        body:Stack(children: [Container(child: Image.asset('assets/Background.png',
          width: size.width, height: size.height,),),
          Center(child : SizedBox(height:1 * size.height,width:0.75 * size.width,
              child:Stack(children: <Widget>[Center(child:SvgPicture.asset('assets/WoodenTable.svg',
                  height: 0.65 * size.height,width:0.75 * size.width ,alignment: Alignment.centerRight))]))),
          Positioned(top: size.height * 0.3, left: size.width * 0.31, child :
          Column(
              children: [
                Text("PREPARING FOR \n   THE BATTLE . . .",
                  style: GoogleFonts.galindo( fontSize: 25,color: Colors.white, fontWeight: FontWeight.w800),),
                CircularProgressIndicator(),
                Text("Connected players : ${connectedNum}",
                  style: GoogleFonts.galindo( fontSize: 25,color: Colors.white, fontWeight: FontWeight.w800),),
          ])),
            ],));
  }
<<<<<<< Updated upstream
=======

  void startWaiting() async {
    await FirebaseFirestore.instance.collection('game').doc('game${widget.gameNum}').set({
      'waitingTimerStart' : DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true));
  }

  void startTimer() {
    Timer(Duration(milliseconds: _waitTime), startGame);
  }

  void getWaitTime() async {
    return FirebaseFirestore.instance.collection('game').doc('game${widget.gameNum}').get().then(
            (snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            if (data != null) {
              final timeSinceStart = DateTime.now().millisecondsSinceEpoch - data['waitingTimerStart'];
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

  void startGame() async{
    if (widget.playerIndex == 0) {
      increaseGameNum(widget.gameNum);
    }
    initializeGameData();
    // await Future.delayed(
    //     const Duration(milliseconds: 8000));
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (context) {
              return GameTable(playerIndex: widget.playerIndex, nicknames: _nicknames,
                gameNum: widget.gameNum, playersNumber: _connectedNum,collectionName: 'game',);
            }
        )
    );
  }

    void initializeGameData() async{
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      Map<String,dynamic> dataUpload = {};
      if (widget.playerIndex == 0) {
        cardsArr = [for(int i = 1; i <= (numberOfRegularCards+((numberOfUniqueCards)*numberOfUniqueCardsRepeats)); i++) i];
        cardsArr.shuffle();
        dataUpload['cardsData'] = cardsArr;
        ///ADDED here - will be initialized only by player 1
        //dataUpload['underTotemCards'] = [];
        dataUpload['totem'] = false;
        dataUpload['turn'] = 0;
        dataUpload['matchingCards'] =
          [for(int i = 0; i < (numberOfRegularCards~/4); i++) 0];
        dataUpload['matchingColorCards'] = [0,0,0,0];
        dataUpload['cardsActiveUniqueArray'] =
          [for(int i = 0; i < (numberOfUniqueCards + 1); i++) 0];
        Map<String, dynamic> messages = {};
        int totalCardsNum = cardsArr.length;//(numberOfRegularCards + ((numberOfUniqueCards)*numberOfUniqueCardsRepeats))
        int cards = (totalCardsNum / _connectedNum).toInt();
        int remainder = (totalCardsNum) % _connectedNum;
        for(int i = 0; i < _connectedNum; i++){
          dataUpload['player_${i}_openCards'] = [];
          messages['player${i}MSGS'] = "";
          if(remainder > 0){
            dataUpload['player_${i}_deck'] = cardsArr.sublist(cards*i, (cards*(i+1))) +
                cardsArr.sublist(totalCardsNum - remainder, totalCardsNum - remainder + 1);
            remainder--;
          }
          else{
            dataUpload['player_${i.toString()}_deck'] =
              cardsArr.sublist(cards*i, (cards*(i+1)));
          }
        }
        await _firestore.collection('game').doc('game${widget.gameNum}MSGS').
        set(messages, SetOptions(merge : true));
        await _firestore.collection('game').doc('game${widget.gameNum}')
            .set(dataUpload, SetOptions(merge : true));
      }
    }


















  ///nofar's version
  /*
  void initializeGameData() async{
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Map<String,dynamic> dataUpload = {};
    if (widget.playerIndex == 0) {
      cardsArr = [for(int i = 1; i <= (numberOfRegularCards+((numberOfUniqueCards)*numberOfUniqueCardsRepeats)); i++) i];
      cardsArr.shuffle();
      dataUpload['cardsData'] = cardsArr;
      ///ADDED here - will be initialized only by player 1
      dataUpload['underTotemCards'] = [];
      dataUpload['totem'] = false;
      for(int i = 0; i < _connectedNum; i++ ){
        dataUpload['totem${i}Pressed'] = false;
        dataUpload['player_${i}_openCards'] = [];
      }
      dataUpload['turn'] = 0;
      dataUpload['matchingCards'] = [for(int i = 0; i < (numberOfRegularCards~/4); i++) 0];
      dataUpload['matchingColorCards'] = [0,0,0,0];
      dataUpload['cardsActiveUniqueArray'] = [for(int i = 0; i < (numberOfUniqueCards + 1); i++) 0];
      Map<String, dynamic> messages = {};
      for(int i = 0; i < _connectedNum; i++){
        //dataUpload['Player${i}Msgs'] = "";//playersMassages
        messages['player${i}MSGS'] = "";
        //totemPressed[]
      }
      await _firestore.collection('game').doc('game${widget.gameNum}MSGS').
      set(messages, SetOptions(merge : true));
    }
    else {
      await _firestore.collection('game').doc('game${widget.gameNum}').get().then(
              (snapshot) {
            if (snapshot.exists) {
              final data = snapshot.data();
              if (data != null) {
                cardsArr = data['cardsData'];
              }
            }
            return null;
          }
      );
    }
    int totalCardsNum = cardsArr.length;//(numberOfRegularCards + ((numberOfUniqueCards)*numberOfUniqueCardsRepeats))
    int cards = (totalCardsNum / _connectedNum).toInt();
    int remainder = widget.playerIndex + 1 > (totalCardsNum) % _connectedNum ? 0 :
    (totalCardsNum) % _connectedNum - widget.playerIndex;
    if (remainder > 0){
      dataUpload['player_${widget.playerIndex.toString()}_deck'] =
          cardsArr.sublist(cards*(widget.playerIndex), (cards * (widget.playerIndex + 1))) +
              cardsArr.sublist(totalCardsNum - remainder, totalCardsNum - remainder + 1);
    }
    else{
      dataUpload['player_${widget.playerIndex.toString()}_deck'] =
          cardsArr.sublist(cards*(widget.playerIndex), (cards * (widget.playerIndex + 1)));
    }
    await _firestore.collection('game').doc('game${widget.gameNum}').set(dataUpload, SetOptions(merge : true));
  }*/
}


>>>>>>> Stashed changes
  //_timeElapsed.
 /* @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Text('Waiting room'),
    );*/
  }


// class WaitingRoomState extends State<WaitingRoom>{

  ///do not rewmove - important for timer settings
  /*String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    //var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
  //late Stopwatch _stopwatch;
  //late Stopwatch _stopwatch;
  late  Timer _timer;
  late var _stopwatch ;
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    // re-render every 30ms
    _timer = new Timer.periodic(new Duration(milliseconds: 1), (timer) {
      setState(() {});
    });}
*/



 /* @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    //_stopwatch.start();
  }*/

  // @override

// }