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


class playerDeck extends StatefulWidget {
  int deviceIndex;
  int gameNum;
  final Function(bool) currentTurnCallback;
  final int index;
  final int playersNumber;

  playerDeck({required this.index, required this.deviceIndex, required this.currentTurnCallback, required this.gameNum, required this.playersNumber});



  @override
  State<playerDeck> createState() => deckState();
}
class deckState extends State<playerDeck> {
  late List<List<dynamic>> cardsHandler;
  double rightAlignment = 0.012;
  late int currentTurn;
  late var cardsGroupArray;
  late var cardsColorArray ;
  late var cardsActiveUniqueArray;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(//<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('game').doc('game${widget.gameNum}').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot <DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              cardsHandler = [];
              var cloudData = snapshot.data?.data();
              for (int i = 0; i < widget.playersNumber; i++) {
                if ((cloudData as Map<String, dynamic>).containsKey("player_${i}_deck")){
                  cardsHandler.add([
                  cloudData['player_${i}_deck'],
                  cloudData['player_${i}_openCards']
                ]);
                }
                else cardsHandler.add([[],[]]);
              }

              if ((cloudData as Map<String, dynamic>).containsKey('turn')) currentTurn = cloudData['turn'];


              /// lines 46 to 60 :New condition exit when there is dead end after a certain amount of time//
              if (widget.index == 0) {
                if (currentTurn == -1) {
                  widget.currentTurnCallback(true);
                }
                else if (currentTurn == -3) {
                  widget.currentTurnCallback(false);
                }
              }
              cardsGroupArray = cloudData['matchingCards'];
              cardsColorArray = cloudData['matchingColorCards'];
              cardsActiveUniqueArray = cloudData['cardsActiveUniqueArray'];
            }
              /// 0: insideArrows, 1: color, 2: outsideArrows

            return GestureDetector(
              onTap: (currentTurn != widget.index || widget.index != widget.deviceIndex) ? null : () async{
                bool outerArrowsRevealed = false; /// WDYT
                FirebaseFirestore db = FirebaseFirestore.instance;
                Map<String, dynamic> cloudMsgs = {};
                Map<String, dynamic> dataUpload = {};
                List<String> messages = [for(int i = 0; i < widget.playersNumber; i++) ""];
                await db.collection("game").doc("game${widget.gameNum}").set({
                  'turn' : -2},SetOptions(merge :true));
                if(cardsHandler[widget.index][1].length > 0) decreaseCardsArray(cardsHandler[widget.index][1][0]);
                cardsHandler[widget.index][1].insert(0,cardsHandler[widget.index][0].removeAt(0));
                if (increaseCardsArray(cardsHandler[widget.index][1][0]) == 2) {
                  outerArrowsRevealed = true; /// WDYT
                  await db.collection("game").doc("game${widget.gameNum}").set({
                    'player_${widget.index}_openCards': cardsHandler[widget.index][1],
                    'player_${widget.index}_deck': cardsHandler[widget.index][0],
                    'matchingCards' : cardsGroupArray,
                    'matchingColorCards' : cardsColorArray,
                    'cardsActiveUniqueArray' : cardsActiveUniqueArray
                  },SetOptions(merge: true));
                  await Future.delayed(Duration(milliseconds: 500));
                  for (int i = 0; i < widget.playersNumber; i++) {
                    //cloudMsgs['Player${i}Msgs'] = "outerArrows";
                    messages[i] = "outerArrows";
                  }
                  await db.collection("game").doc('game${widget.gameNum}').set(//Messages
                      {'messages' : messages}, SetOptions(merge: true));
                  await handleSpecialCardNo0(widget.index);
                  for (int i = 0; i < widget.playersNumber; i++) {
                    if ((((i == widget.index && cardsHandler[widget.index][0].length > 0)) ||
                    (i != widget.index)) && (((cardsHandler[i][1][0] - 1)) - numberOfRegularCards) ~/ 2 == 2) {
                      for (int i = 0; i < widget.playersNumber; i++) {
                        //cloudMsgs['Player${i}Msgs'] = "outerArrows";
                        messages[i] = "outerArrows";
                      }
                      await db.collection("game").doc('game${widget.gameNum}').set(
                          {'messages' : messages}, SetOptions(merge: true));
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
                dataUpload = outerArrowsRevealed == false ? {
                  'turn': nextTurn,
                  'matchingCards': cardsGroupArray,
                  'matchingColorCards': cardsColorArray,
                  'cardsActiveUniqueArray': cardsActiveUniqueArray} : {'turn': nextTurn};
                for (int i = 0; i < widget.playersNumber; i++) {
                  dataUpload['player_${i}_deck'] = cardsHandler[i][0];
                  dataUpload['player_${i}_openCards'] = cardsHandler[i][1];
                }
                await db.collection("game").doc('game${widget.gameNum}').set(dataUpload, SetOptions(merge: true));
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
      print('___');
      if (cardsHandler[i][0].length > 0) {
        if (cardsHandler[i][1].length > 0 && i != index) decreaseCardsArray(cardsHandler[i][1][0]);
        print("(2) ${i},  matchi ng cards: ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
        cardsHandler[i][1].insert(0, cardsHandler[i][0].removeAt(0));
        increaseCardsArray(cardsHandler[i][1][0]);
        print("(3) ${i},  matchi ng cards: ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
        //cardsUpload['player_${i}_deck'] = cardsHandler[i][0];
        //cardsUpload['player_${i}_openCards'] = cardsHandler[i][0];
        await FirebaseFirestore.instance.collection("game").doc("game${widget.gameNum}").set({
          'matchingCards': cardsGroupArray,
          'matchingColorCards' : cardsColorArray,
          'cardsActiveUniqueArray' : cardsActiveUniqueArray,
          'player_${i}_deck' : cardsHandler[i][0],
          'player_${i}_openCards' : cardsHandler[i][1],},SetOptions(merge :true));
      }
    }
  }
  }
