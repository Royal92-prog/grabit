import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
const numberOfRegularCards = 72;
const numberOfUniqueCards = 3;
const numberOfUniqueCardsRepeats = 2 ;

class DrawCard extends StatelessWidget {
  final int index;
  final int playersNumber;
  final int gameNum;
  final int deviceIndex;
  final Function(bool) currentTurnCallback;
  //var openCards = [];
  late var deck;
  late int currentTurn;
  late var cardsGroupArray;
  late var cardsHandler;
  late var cardsColorArray;
  late var cardsActiveUniqueArray;

  DrawCard({required this.index, required this.playersNumber,
    required this.gameNum, required this.deviceIndex,
    required this.currentTurnCallback});

  @override
  Widget build(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return StreamBuilder <DocumentSnapshot<Map<String, dynamic>>>(//<DocumentSnapshot>(
  stream: FirebaseFirestore.instance.collection('game').
    doc('game${gameNum}').snapshots(),
  builder: (BuildContext context,
    AsyncSnapshot <DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active && snapshot.data != null) {
          cardsHandler = [];
          Map<String, dynamic> cloudData = (snapshot.data?.data() as Map<String, dynamic>);
          for (int i = 0; i < playersNumber; i++) {
            if (cloudData.containsKey("player_${i}_deck")){
              cardsHandler.add([
                cloudData['player_${i}_deck'],
                cloudData['player_${i}_openCards']
              ]);
            }
            else cardsHandler.add([[],[]]);
          }
        currentTurn = cloudData.containsKey('turn') == true ? cloudData['turn'] : 0;
        if (index == 0) {
          if (currentTurn == -1) {
            currentTurnCallback(true);
          }
          else if (currentTurn == -3) {
            currentTurnCallback(false);
          }
        }

        cardsGroupArray = cloudData.containsKey('matchingCards') == true ?
          cloudData['matchingCards'] : [];

        cardsColorArray = cloudData.containsKey('matchingColorCards') == true ?
          cloudData['matchingColorCards'] : [];

        cardsActiveUniqueArray = cloudData.containsKey('cardsActiveUniqueArray') ?
          cloudData['cardsActiveUniqueArray'] : [];

  /// 0: insideArrows, 1: color, 2: outsideArrows
  return GestureDetector(
    onTap: (currentTurn != index || index != deviceIndex) ? null : () async{
      bool outerArrowsRevealed = false;
      FirebaseFirestore db = FirebaseFirestore.instance;
      Map<String, dynamic> cloudMsgs = {};
      Map<String, dynamic> dataUpload = {};
      await db.collection("game").doc("game${gameNum}").set({
        'turn' : -2},SetOptions(merge :true));
      if(cardsHandler[index][1].length > 0){
        decreaseCardsArray(cardsHandler[index][1][0]);
      }
      cardsHandler[index][1].insert(0,cardsHandler[index][0].removeAt(0));
      if (increaseCardsArray(cardsHandler[index][1][0]) == 2) {
        outerArrowsRevealed = true;
      await db.collection("game").doc("game${gameNum}").set({
        'player_${index}_openCards': cardsHandler[index][1],
        'player_${index}_deck': cardsHandler[index][0],
        'matchingCards' : cardsGroupArray,
        'matchingColorCards' : cardsColorArray,
        'cardsActiveUniqueArray' : cardsActiveUniqueArray
        },SetOptions(merge: true));
      await Future.delayed(Duration(milliseconds: 500));
      for (int i = 0; i < playersNumber; i++) {
        cloudMsgs['player${i}MSGS'] = "outerArrows";
      }
      await db.collection("game").doc('game${gameNum}MSGS').set(
        cloudMsgs, SetOptions(merge: true));
      await handleSpecialCardNo0(index);
      for (int i = 0; i < playersNumber; i++) {
        if ((((i == index && cardsHandler[index][0].length > 0)) ||
          (i != index)) &&
          (((cardsHandler[i][1][0] - 1)) - numberOfRegularCards) ~/ 2 == 2) {
          for (int i = 0; i < playersNumber; i++) {
            cloudMsgs['player${i}MSGS'] = "outerArrows";
          }
          await db.collection("game").doc('game${gameNum}').set(
            cloudMsgs, SetOptions(merge: true));
          await Future.delayed(Duration(milliseconds: 1000));
          handleSpecialCardNo0(i);
          break;
        }
      }}
      int nextTurn = (index + 1) % playersNumber;
      bool swapped = false;
      for (int i = 0; i < playersNumber; i ++) {
        if (cardsHandler[nextTurn][0].length != 0) {
          swapped = true;
          break;
        }
        nextTurn = (nextTurn + 1) % playersNumber;
      }
      if (swapped == false) nextTurn = -1;
      dataUpload = outerArrowsRevealed == false ? {
        'turn': nextTurn,
        'matchingCards': cardsGroupArray,
        'matchingColorCards': cardsColorArray,
        'cardsActiveUniqueArray': cardsActiveUniqueArray} : {'turn': nextTurn};
      for (int i = 0; i < playersNumber; i++) {
        dataUpload['player_${i}_deck'] = cardsHandler[i][0];
        dataUpload['player_${i}_openCards'] = cardsHandler[i][1];
      }
      await db.collection("game").doc('game${gameNum}').
        set(dataUpload, SetOptions(merge: true));
    },
  child: Image.asset('assets/DRAW_BTN.png',
    width: 0.15 * size.width,
    height: 0.12 * size.width,),);
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
    for (int i = 0; i < playersNumber; i++) {
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
        await FirebaseFirestore.instance.collection("game").doc("game${gameNum}").set({
          'matchingCards': cardsGroupArray,
          'matchingColorCards' : cardsColorArray,
          'cardsActiveUniqueArray' : cardsActiveUniqueArray,
          'player_${i}_deck' : cardsHandler[i][0],
          'player_${i}_openCards' : cardsHandler[i][1],},SetOptions(merge :true));
      }
    }
  }




}



