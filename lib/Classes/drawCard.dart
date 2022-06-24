import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DrawCard extends StatelessWidget {
  final int index;
  late var openCards;
  late var deck;
  late int currentTurn;
  late var cardsGroupArray;
  late var cardsHandler;
  late var cardsColorArray;
  late var cardsActiveUniqueArray;
  DrawCard({required this.index});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('game').doc('game2').snapshots(),
      builder: (BuildContext context,
      AsyncSnapshot <DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        final cloudData = snapshot.data;
        if (cloudData != null) {
          deck = cloudData['player_${index}_deck'];
          openCards = cloudData['player_${index}_openCards'];
          currentTurn = cloudData['turn'];
          cardsGroupArray = cloudData['matchingCards'];
          cardsColorArray = cloudData['matchingColorCards'];
          cardsActiveUniqueArray = cloudData['cardsActiveUniqueArray'];
          }
        return GestureDetector(child: Image.asset("assets/gameTable/DRAW_BTN.png"),
          onTap: () async {


    }
        },)*/

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('game').doc('game2').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot <DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final cloudData = snapshot.data;
            if (cloudData != null) {
              cardsHandler = [];
              for (int i = 0; i < 3; i++) {
                cardsHandler.add([
                  cloudData['player_${i}_deck'],
                  cloudData['player_${i}_openCards']
                ]);
              }
              currentTurn = cloudData['turn'];

              /// lines 46 to 60 :New condition exit when there is dead end after a certain amount of time//
             /* if (currentTurn == -1 && widget.index == 0) {
                widget.currentTurnCallback(true);
              }*/
              cardsGroupArray = cloudData['matchingCards'];
              cardsColorArray = cloudData['matchingColorCards'];
              cardsActiveUniqueArray = cloudData['cardsActiveUniqueArray'];

              /// 0: insideArrows, 1: color, 2: outsideArrows
            }
            return GestureDetector(
              onTap: currentTurn != index ? null : () async {
                bool outerArrowsRevealed = false;
                FirebaseFirestore db = FirebaseFirestore.instance;
                await db.collection("game").doc("game2").set(
                    {'turn': -2}, SetOptions(merge: true));
                if (cardsHandler[index][1].length > 0){
                  decreaseCardsArray(cardsHandler[index][1][0]);
                }
                cardsHandler[index][1].insert(
                    0, cardsHandler[index][0].removeAt(0));
                //print("before increase ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
                if (increaseCardsArray(cardsHandler[index][1][0]) == 2) {
                  //print("After increase ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
                  outerArrowsRevealed = true;
                  await db.collection("game").doc("game2").set({
                    'player_${index}_openCards': cardsHandler[index][1],
                    'player_${index}_deck': cardsHandler[index][0],
                    'matchingCards' : cardsGroupArray,
                    'matchingColorCards' : cardsColorArray,
                    'cardsActiveUniqueArray' : cardsActiveUniqueArray
                  },SetOptions(merge: true));
                  await Future.delayed(Duration(milliseconds: 500));
                  Map<String, dynamic> cloudMsgs = {};
                  for (int i = 0; i < 3; i++) {
                    cloudMsgs['Player${i}Msgs'] = "outerArrows";
                  }
                  await db.collection("game").doc("game2Msgs").set(
                      cloudMsgs, SetOptions(merge: true));
                  await handleSpecialCardNo0(index);
                  for (int i = 0; i < 3; i++) {
                    if ((((i == index && cardsHandler[index][0].length > 0)) ||
                        (i != index)) && (((cardsHandler[i][1][0] - 1)) - 72) ~/ 2 == 2) {
                      for (int i = 0; i < 3; i++) {
                        cloudMsgs['Player${i}Msgs'] = "outerArrows";
                      }
                      await db.collection("game").doc("game2Msgs").set(
                          cloudMsgs, SetOptions(merge: true));
                      await Future.delayed(Duration(milliseconds: 1000));
                      handleSpecialCardNo0(i);
                      break;
                    }
                  }
                }
                int nextTurn = (index + 1) % 3;//widget.playersNumber;
                bool swapped = false;
                for (int i = 0; i < 3; i ++) {
                  if (cardsHandler[nextTurn][0].length != 0) {
                    swapped = true;
                    break;
                  }
                  nextTurn = (nextTurn + 1) % 3;//widget.playersNumber;
                }
                if (swapped == false) nextTurn = -1;
                //remember to substract 1 from player index when using firebase
                Map<String, dynamic> uploadData = outerArrowsRevealed == false ? {
                  'turn': nextTurn,
                  'matchingCards': cardsGroupArray,
                  'matchingColorCards': cardsColorArray,
                  'cardsActiveUniqueArray': cardsActiveUniqueArray} : {'turn': nextTurn};
                for (int i = 0; i < 3; i++) {
                  uploadData['player_${i}_deck'] = cardsHandler[i][0];
                  uploadData['player_${i}_openCards'] = cardsHandler[i][1];
                }
                await db.collection("game").doc("game2").set(uploadData, SetOptions(merge: true));
                print(
                    "matching cards: ${cardsGroupArray} ,ColorsArr: ${cardsColorArray} UniqueArr ${cardsActiveUniqueArray}");
              },
              child: Image.asset('assets/gameTable/DRAW_BTN.png',width: 0.15 * size.width, height: 0.12 * size.width,),);
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
      if ((((card - 1)) - 72) ~/ 2 != 2) {
        cardsActiveUniqueArray[(((card - 1)) - 72) ~/ 2] += 1;
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
      cardsActiveUniqueArray[(((card - 1)) - 72) ~/ 2] -= 1;
      if ((((card - 1)) - 72) ~/ 2 == 0 &&
          cardsActiveUniqueArray[3] > 0) {
        cardsActiveUniqueArray[3] -= 1;
      }
    }
  }

  handleSpecialCardNo0(index) async {
    await Future.delayed(Duration(seconds: 5));
    //Map<String, dynamic> cardsUpload = {};
    for (int i = 0; i < 3; i++) {
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

