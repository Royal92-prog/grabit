import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit/Classes/card.dart';
import 'package:provider/provider.dart';
import '../main.dart';



Map <int,String> cardsDic = {1 : 'assets/1.svg', 2 : 'assets/2.svg', 3 : 'assets/3.svg',
  4 : 'assets/4.svg', 5 : 'assets/5.svg'};


class playerDeck extends StatefulWidget {
  int index;
  int deviceIndex;
  int gameNum;
  final Function(bool) currentTurnCallback;
  playerDeck( {required this.index, required this.deviceIndex, required this.currentTurnCallback, required this.gameNum});
  final int index;
  final int playersNumber;
  final Function(bool) currentTurnCallback;
  playerDeck( {required this.index, required this.playersNumber, required this.currentTurnCallback});

  @override
  State<playerDeck> createState() => deckState();
}
class deckState extends State<playerDeck> {
  late List<List<dynamic>> cardsHandler;
  double rightAlignment = 0.012;
  late int currentTurn;
  late var cardsHandler;
  late var cardsGroupArray;
  late var cardsColorArray ;
  late var cardsActiveUniqueArray;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('game').doc('game2').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot <DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final cloudData = snapshot.data;
            if (cloudData != null) {
              cardsHandler = [];
              for (int i = 0; i < widget.playersNumber; i++) {
                cardsHandler.add([
                  cloudData['player_${i}_deck'],
                  cloudData['player_${i}_openCards']
                ]);
              }
              currentTurn = cloudData['turn'];

              /// lines 46 to 60 :New condition exit when there is dead end after a certain amount of time//
              if (currentTurn == -1 && widget.index == 0) {
                widget.currentTurnCallback(true);
              }
              cardsGroupArray = cloudData['matchingCards'];
              cardsColorArray = cloudData['matchingColorCards'];
              cardsActiveUniqueArray = cloudData['cardsActiveUniqueArray'];

              /// 0: insideArrows, 1: color, 2: outsideArrows
            }
            return GestureDetector(
              onTap: currentTurn != widget.index ? null : () async {
                bool outerArrowsRevealed = false;
                FirebaseFirestore db = FirebaseFirestore.instance;
                await db.collection("game").doc("game2").set(
                    {'turn': -2}, SetOptions(merge: true));
                if (cardsHandler[widget.index][1].length > 0){
                  decreaseCardsArray(cardsHandler[widget.index][1][0]);
                }
                cardsHandler[widget.index][1].insert(
                    0, cardsHandler[widget.index][0].removeAt(0));
                //print("before increase ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
                if (increaseCardsArray(cardsHandler[widget.index][1][0]) == 2) {
                  //print("After increase ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
                  outerArrowsRevealed = true;
                  await db.collection("game").doc("game2").set({
                    'player_${widget.index}_openCards': cardsHandler[widget.index][1],
                    'player_${widget.index}_deck': cardsHandler[widget.index][0],
                    'matchingCards' : cardsGroupArray,
                    'matchingColorCards' : cardsColorArray,
                    'cardsActiveUniqueArray' : cardsActiveUniqueArray
                  },SetOptions(merge: true));
                  await Future.delayed(Duration(milliseconds: 500));
                  Map<String, dynamic> cloudMsgs = {};
                  for (int i = 0; i < widget.playersNumber; i++) {
                    cloudMsgs['Player${i}Msgs'] = "outerArrows";
                  }
                  await db.collection("game").doc("game2").set(
                      cloudMsgs, SetOptions(merge: true));
                  await handleSpecialCardNo0(widget.index);
                  for (int i = 0; i < widget.playersNumber; i++) {
                    if ((((i == widget.index && cardsHandler[widget.index][0].length > 0)) ||
                    (i != widget.index)) && (((cardsHandler[i][1][0] - 1)) - numberOfRegularCards) ~/ 2 == 2) {
                      for (int i = 0; i < widget.playersNumber; i++) {
                        cloudMsgs['Player${i}Msgs'] = "outerArrows";
                      }
                      await db.collection("game").doc("game2").set(
                          cloudMsgs, SetOptions(merge: true));
                      await Future.delayed(Duration(milliseconds: 1000));
                      handleSpecialCardNo0(i);
                      break;
                    }
                  }
                }
                int nextTurn = (widget.index + 1) % widget.playersNumber;
                bool swapped = false;
                for (int i = 0; i < widget.playersNumber; i ++) {
                  if (cardsHandler[nextTurn][0].length != 0) {
                    swapped = true;
                    break;
                  }
                  nextTurn = (nextTurn + 1) % widget.playersNumber;
                }
                if (swapped == false) nextTurn = -1;
                //remember to substract 1 from player index when using firebase
                Map<String, dynamic> uploadData = outerArrowsRevealed == false ? {
                  'turn': nextTurn,
                  'matchingCards': cardsGroupArray,
                  'matchingColorCards': cardsColorArray,
                  'cardsActiveUniqueArray': cardsActiveUniqueArray} : {'turn': nextTurn};
                for (int i = 0; i < widget.playersNumber; i++) {
                  uploadData['player_${i}_deck'] = cardsHandler[i][0];
                  uploadData['player_${i}_openCards'] = cardsHandler[i][1];
                }
                await db.collection("game").doc("game2").set(uploadData, SetOptions(merge: true));
                print(
                    "matching cards: ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
              },
              child: Stack(clipBehavior: Clip.antiAliasWithSaveLayer,
                fit: StackFit.passthrough,
                children:
                [
                  SvgPicture.asset('assets/Full_pack.svg',
                    width: 0.1 * size.width, height: 0.1 * size.height,),
                  Positioned(top: 0.01 * size.height, right: 0.012 * size.width,
                    child: Text(
                        "${cardsHandler[widget.index][0].length}", style:
                    TextStyle(fontSize: 15, color: Colors.black)),)
                ],),);
          }
          else
            return CircularProgressIndicator(); //SizedBox(width: size.width * 0.1, height: size.height * 0.1);
        });
  }

  int increaseCardsArray(int card) {
    print("HERE increase");
    int ret = -1;
    if ((card - 1) ~/ 4 < cardsGroupArray.length) {
      print("Regular");
      cardsGroupArray[(card - 1) ~/ 4] += 1; // add new front number to array
      cardsColorArray[(card - 1) % 4] += 1;
    }
    else { //unique card
      print("unique");
      if ((((card - 1)) - numberOfRegularCards) ~/ 2 != 2) {
        cardsActiveUniqueArray[(((card - 1)) - numberOfRegularCards) ~/ 2] += 1;
      }
      else
        ret = 2;
    }
    return ret;
      stream: FirebaseFirestore.instance.collection('game').doc('game${widget.gameNum}').snapshots(),
      builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> snapshot){
      if(snapshot.connectionState == ConnectionState.active){
       final cloudData = snapshot.data;
       if(cloudData != null) {
         cardsHandler = [[cloudData['player_0_deck'], cloudData['player_0_openCards']],
         [cloudData['player_1_deck'], cloudData['player_1_openCards']],
         [cloudData['player_2_deck'], cloudData['player_2_openCards']]];
         currentTurn = cloudData['turn'];
         cardsGroupArray = cloudData['matchingCards'];
         cardsColorArray = cloudData['matchingColorCards'];
         cardsActiveUniqueArray = cloudData['cardsActiveUniqueArray']; /// 0: insideArrows, 1: color, 2: outsideArrows
       }

       if (widget.index == 0) {
         if (currentTurn == -1) {
           widget.currentTurnCallback(true);
         }
         else if (currentTurn == -3) {
           widget.currentTurnCallback(false);
         }
       }

    return GestureDetector(
    onTap: (currentTurn != widget.index || widget.index != widget.deviceIndex) ? null : () async{
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection("game").doc("game${widget.gameNum}").set({'turn' : -2},SetOptions(merge :true));
      if(cardsHandler[widget.index][1].length > 0) decreaseCardsArray(cardsHandler[widget.index][1][0]);
      cardsHandler[widget.index][1].insert(0,cardsHandler[widget.index][0].removeAt(0));
      ///in this case the outer errors card was exposed - let's draw a new card to all players
      if(increaseCardsArray(cardsHandler[widget.index][1][0]) == 2){
        ///update the firebase accordingly before drawing new cards
        await db.collection("game").doc("game${widget.gameNum}").set({
        'player_${widget.index}_openCards' : cardsHandler[widget.index][1],
        'player_${widget.index}_deck' : cardsHandler[widget.index][0]}, SetOptions(merge :true));
        await Future.delayed(Duration(milliseconds: 800));
        await handleSpecialCardNo0();
        if((((cardsHandler[0][1][0] - 1)) - numberOfRegularCards) ~/ 2 == 2 ||
            (((cardsHandler[1][1][0] - 1)) - numberOfRegularCards) ~/ 2 == 2 ||
            (((cardsHandler[2][1][0] - 1)) - numberOfRegularCards) ~/ 2 == 2 ){
          await Future.delayed(Duration(seconds: 1));
          handleSpecialCardNo0();
        }
      }
      int nextTurn = (widget.index + 1) % 3;
      bool swapped = false;
      for(int i = 0; i < 3; i ++){
        if(cardsHandler[nextTurn][0].length != 0){
          swapped = true;
          break;
        }
        nextTurn = (nextTurn + 1) % 3;
      }
      if(swapped == false) nextTurn = -1;
      //remember to substract 1 from player index when using firebase
      await db.collection("game").doc("game${widget.gameNum}").set({
        'player_0_deck' : cardsHandler[0][0],
        'player_1_deck' : cardsHandler[1][0],
        'player_2_deck' : cardsHandler[2][0],
        'player_0_openCards' : cardsHandler[0][1],
        'player_1_openCards' : cardsHandler[1][1],
        'player_2_openCards' : cardsHandler[2][1],
        'turn' : nextTurn,
        'matchingCards': cardsGroupArray,
        'matchingColorCards' : cardsColorArray,
        'cardsActiveUniqueArray' : cardsActiveUniqueArray},SetOptions(merge :true));
      },
      child:Stack(clipBehavior: Clip.antiAliasWithSaveLayer, fit: StackFit.passthrough,children:
      [
      SvgPicture.asset('assets/Full_pack.svg',
      width: 0.1 * size.width, height: 0.1 * size.height,),
      Positioned(top: 0.01 * size.height, right: 0.012 * size.width,
      child:Text("${cardsHandler[widget.index][0].length}", style:
      TextStyle(fontSize: 15,color: Colors.black)),)
      ],),);}
    else return CircularProgressIndicator();//SizedBox(width: size.width * 0.1, height: size.height * 0.1);
    });}
  int increaseCardsArray(int card){
    int ret = -1;
    if((card -1) ~/4 < cardsGroupArray.length){
      cardsGroupArray[(card - 1) ~/ 4] += 1; // add new front number to array
      cardsColorArray[(card - 1) % 4] += 1;
    }
    //unique card
    else{
      if((((card - 1))-numberOfRegularCards) ~/ 2 != 2) {
        cardsActiveUniqueArray[(((card - 1)) - numberOfRegularCards) ~/ 2] += 1;
      }
      else ret = 2;
    }
    return ret;
  }

  decreaseCardsArray(int card){
    if((card -1) ~/4 < cardsGroupArray.length){
      cardsGroupArray[(card - 1) ~/ 4] -= 1; // add new front number to array
      cardsColorArray[((card - 1) % 4)] -= 1;
    }
    //unique card
    else{
      cardsActiveUniqueArray[(((card - 1)) - numberOfRegularCards) ~/ 2] -= 1;
      if((((card - 1))-numberOfRegularCards) ~/ 2 == 0 && cardsActiveUniqueArray[3] > 0) {
        cardsActiveUniqueArray[3] -= 1;
      }
    }
  }
  handleSpecialCardNo0() async{
    var size = MediaQuery.of(context).size;
    ///irrelevant for final branch
    await ScaffoldMessenger.of(context).showSnackBar(SnackBar( duration:Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,backgroundColor: Colors.black.withOpacity(0.5),
        margin: EdgeInsets.only(top: size.height * 0.25,right: size.width * 0.25,
            left:size.width * 0.25, bottom: size.height * 0.6) ,
        content:Center(child: Text("Get Ready"),)));
    ///till here
    for(int i = 3 ; i > 0 ; i--) {
      ///irrelevant for final branch
      await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1), behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black.withOpacity(0.5), margin: EdgeInsets.only(
          top: size.height * 0.25, right: size.width * 0.25, left: size.width * 0.25,
          bottom: size.height * 0.6), content: Center(child: Text("${i}"),)));
    }///till here
    await Future.delayed(Duration(seconds: 5));
    for(int i = 0; i < numPlayers; i++) {
      if(cardsHandler[i][0].length > 0) {
        if(cardsHandler[i][1].length > 0 && i != widget.index) decreaseCardsArray(cardsHandler[i][1][0]);
        cardsHandler[i][1].insert(0, cardsHandler[i][0].removeAt(0));
        increaseCardsArray(cardsHandler[i][1][0]);
        await FirebaseFirestore.instance.collection("game").doc("game${widget.gameNum}").set({
          'player_${i}_deck' : cardsHandler[i][0],
          'player_${i}_openCards' : cardsHandler[i][1],
          'matchingCards': cardsGroupArray,
          'matchingColorCards' : cardsColorArray,
          'cardsActiveUniqueArray' : cardsActiveUniqueArray},SetOptions(merge :true));
      }
    }
  }

  decreaseCardsArray(int card) {
    print("Line 162");
    if ((card - 1) ~/ 4 < cardsGroupArray.length) {
      cardsGroupArray[(card - 1) ~/ 4] -= 1; // add new front number to array
      cardsColorArray[((card - 1) % 4)] -= 1;
    }
    else { //unique card
      cardsActiveUniqueArray[(((card - 1)) - numberOfRegularCards) ~/ 2] -= 1;
      if ((((card - 1)) - numberOfRegularCards) ~/ 2 == 0 &&
          cardsActiveUniqueArray[3] > 0) {
        cardsActiveUniqueArray[3] -= 1;
      }
    }
  }

  handleSpecialCardNo0(index) async {
    await Future.delayed(Duration(seconds: 5));
    //Map<String, dynamic> cardsUpload = {};
    for (int i = 0; i < widget.playersNumber; i++) {
      print('here Line 178 ${index} is the maniac');
      print("(1) ${i},  matchi ng cards: ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
      print('_________');
      if (cardsHandler[i][0].length > 0) {
        if (cardsHandler[i][1].length > 0 && i != index) decreaseCardsArray(cardsHandler[i][1][0]);
        print("(2) ${i},  matchi ng cards: ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
        cardsHandler[i][1].insert(0, cardsHandler[i][0].removeAt(0));
        increaseCardsArray(cardsHandler[i][1][0]);
        print("(3) ${i},  matchi ng cards: ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
        //cardsUpload['player_${i}_deck'] = cardsHandler[i][0];
        //cardsUpload['player_${i}_openCards'] = cardsHandler[i][0];
        await FirebaseFirestore.instance.collection("game").doc("game2").set({
          'matchingCards': cardsGroupArray,
          'matchingColorCards' : cardsColorArray,
          'cardsActiveUniqueArray' : cardsActiveUniqueArray,
          'player_${i}_deck' : cardsHandler[i][0],
          'player_${i}_openCards' : cardsHandler[i][1],},SetOptions(merge :true));
      }
      }
      //cardsUpload['matchingCards'] = cardsGroupArray;
      //cardsUpload['matchingColorCards'] = cardsColorArray;
      //cardsUpload['cardsActiveUniqueArray'] = cardsActiveUniqueArray;
      /*await FirebaseFirestore.instance.collection("game").doc("game2").set({
      'matchingCards': cardsGroupArray,
      'matchingColorCards' : cardsColorArray,
      'cardsActiveUniqueArray' : cardsActiveUniqueArray},
       SetOptions(merge :true));*/
      //await Future.delayed(Duration(seconds: 5));
      //await FirebaseFirestore.instance.collection("game").doc("game2").set(
      //cardsUpload, SetOptions(merge: true));
    }
  }
