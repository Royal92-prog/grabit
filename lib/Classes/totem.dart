import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';

import '../main.dart';

class totem extends StatefulWidget {
  totem({required this.index, required this.gameNum,
    required this.playersNumber, required this.collectionType});
  int index;
  final int gameNum;
  int playersNumber;
  String collectionType;

  @override
  State<totem> createState() => totemState();
}

class totemState extends State<totem> {
  bool isTotemPressed = false;
  final int numberOfRegularCards = 72;
  var underTotemCards = [];
  var outerArrowsTracking = [0, 2];
  late var matchingColorCards;
  late var matchingRegularCards;
  late var cardsGroupArray;
  late var uniqueArray;
  late int currentTurn;

  late List<List<dynamic>> cardsHandler;
  bool _isColorActive = false;


  List<int> getLoserIndex() {
    List<int> losingPlayers = [];
    for (int i = 0; i < widget.playersNumber; i++) {
      if (i == widget.index || cardsHandler[i][1] == [] ||
          cardsHandler[i][1].length == 0) continue;
      if (_isColorActive) {
        if (cardsHandler[i][1][0] <= 72 &&
            ((((cardsHandler[i][1][0]) - 1) % 4) ==
                (cardsHandler[widget.index][1][0] - 1) % 4)) {
          losingPlayers.add(i);
        }
      }
      else {
        if ((((cardsHandler[i][1][0]) - 1) ~/ 4) ==
            (cardsHandler[widget.index][1][0] - 1) ~/ 4) {
          losingPlayers.add(i);
        }
      }
    }
    return losingPlayers;
  }


  decreaseCardsArray(int card) {
    if ((card - 1) ~/ 4 < matchingRegularCards.length) {
      matchingRegularCards[(card - 1) ~/ 4] -= 1; // add new front number to array
      matchingColorCards[((card - 1) % 4)] -= 1;
    }
    else { //unique card
      uniqueArray[(((card - 1)) - numberOfRegularCards) ~/ 2] -= 1;
      if ((((card - 1)) - numberOfRegularCards) ~/ 2 == 0 &&
          uniqueArray[3] > 0) {
        uniqueArray[3] -= 1;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double rightPosition = underTotemCards.length > 9 ? 0.008 : 0.016;
    return StreamBuilder <DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection(widget.collectionType).
        doc('game${widget.gameNum}').snapshots(),
      builder: (
          BuildContext context,
          AsyncSnapshot <DocumentSnapshot> snapshot) {
            StreamSubscription subscription = FirebaseFirestore.instance.
            collection(widget.collectionType).doc('game${widget.gameNum}').
            snapshots().listen((event) { });
            if (snapshot.connectionState == ConnectionState.active
              && snapshot.data?.data() != null) {
                Map<String, dynamic> cloudData = (snapshot.data?.data() as Map<String, dynamic>);
                cardsHandler = [];
                isTotemPressed = cloudData.containsKey('totem') == true ?
                  cloudData['totem'] : true;
                for (int i = 0; i < widget.playersNumber; i++) {
                  if(cloudData.containsKey('player_${i}_deck') == true ){
                  cardsHandler.add([
                  cloudData['player_${i}_deck'],
                  cloudData['player_${i}_openCards']]);
                  }
                  else{
                    cardsHandler.add([[], []]);
                  }
                }
                currentTurn = cloudData.containsKey('turn') == true ?
                  cloudData['turn'] : 0;

                underTotemCards = cloudData.containsKey('underTotemCards') == true ?
                  cloudData['underTotemCards'] : [];

                _isColorActive = cloudData.containsKey('cardsActiveUniqueArray') == true &&
                    cloudData['cardsActiveUniqueArray'][1] > 0;

                if(cloudData.containsKey('matchingColorCards') == true
                && cloudData.containsKey('matchingCards') == true) {
                  cardsGroupArray = _isColorActive ?
                  cloudData['matchingColorCards'] :
                  cloudData['matchingCards'];
                }
                else cardsGroupArray = [];

                matchingRegularCards = cloudData.containsKey('matchingCards') == true ?
                  cloudData['matchingCards'] : [];

                uniqueArray = cloudData.containsKey('cardsActiveUniqueArray') == true ?
                  cloudData['cardsActiveUniqueArray'] : [];

                matchingColorCards = cloudData.containsKey('matchingColorCards') == true ?
                  cloudData['matchingColorCards'] : [];
                if(currentTurn == -1 || currentTurn == -3){
                  subscription.cancel();
                }
                //messages = cloudData['messages'];

            return Container(
              height: size.height * 0.3,
              width: size.width * 0.3,
              child: Stack(children: [
                underTotemCards.length > 0 ? Positioned(
                  right: size.width * 0.065,
                  child: Stack(children: [
                    SvgPicture.asset('assets/Full_pack.svg',
                      width: 0.1 * size.width,
                      height: 0.1 * size.height,),
                    Positioned(left: rightPosition * size.width,
                      top: 0.009 * size.height,
                      child: Text("${underTotemCards.length}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black)))])) :
                    SizedBox(),
                    GestureDetector(child: Image.asset('assets/CTAButton.png',
                      width: 0.2 * size.width,
                      height: 0.15 * size.height,
                      alignment: Alignment.center),
                      onTap: isTotemPressed ? null : () async {
                        FirebaseFirestore _firestore = FirebaseFirestore.instance;
                        Random random = new Random();
                        int randomNumber = random.nextInt(900);
                        await Future.delayed(Duration(milliseconds: randomNumber));
                        if (isTotemPressed == true) return;
                         await _firestore.collection(widget.collectionType).doc('game${widget.gameNum}')
                          .set({'totem': true, 'turn' : -2},
                          SetOptions(merge: true));
                        Map<String, dynamic> cloudMassages = {};
                        Map<String, dynamic> uploadData = {};
                       /* for (int i = 0; i < widget.playersNumber && !isTotemPressed; i++) {
                          if (uploadData['totem${i}Pressed']) return;
                        }*/
                        ///#1st case :  totem was pressed since inner arrows is on the table
                        print("Unique array :: ${uniqueArray}");
                        if (uniqueArray[0] > 0 && uniqueArray[0] > uniqueArray[3]) {
                          uniqueArray[3] += 1; // marking that the special card is used
                          if (cardsHandler[widget.index][1].length > 0){
                            decreaseCardsArray(cardsHandler[widget.index][1][0]);
                          }
                          underTotemCards = [...underTotemCards, ...cardsHandler[widget.index][1]];
                          underTotemCards.shuffle();
                          cardsHandler[widget.index][1] = [];
                          uploadData = {
                            'totem': false,
                            'totem${widget.index}Pressed': false,
                            'turn': widget.index,
                            'underTotemCards': underTotemCards,
                            'cardsActiveUniqueArray': uniqueArray,
                            'matchingCards': matchingRegularCards,
                            'matchingColorCards': matchingColorCards,
                            'player_${widget.index}_openCards': [],
                          };

                          cloudMassages['player${widget.index}MSGS'] = "inner arrows card - You Win!";
                          for (int i = 0; i < widget.playersNumber; i++) {
                            if (i == widget.index) continue;
                            cloudMassages['player${i}MSGS'] =
                              "inner arrows card ! \n player ${widget.index} pressed the inner button first";
                          }
                          //uploadData["messages"] = messages;
                          await _firestore.collection(widget.collectionType).doc('game${widget.gameNum}').set(
                              uploadData, SetOptions(merge: true));
                          await _firestore.collection(widget.collectionType).doc('game${widget.gameNum}MSGS').set(
                              cloudMassages, SetOptions(merge: true));
                        }

                        ///#2nd case :  totem was pressed for the regular reason (color / regular mode)
                        else if (cardsHandler[widget.index][1].length > 0 &&
                          cardsHandler[widget.index][1][0] <= 72 &&
                          cardsHandler[widget.index][1].length > 0 &&
                          ((!_isColorActive && cardsGroupArray[(((cardsHandler[widget.index][1][0]) - 1) ~/ 4)] > 1) ||
                          (_isColorActive && cardsGroupArray[(((cardsHandler[widget.index][1][0]) - 1) % 4)] > 1))) {
                          print("unique ${uniqueArray} , Active ${matchingColorCards} ${_isColorActive}");
                          var loserIndices = getLoserIndex();
                          print("indices :: ${loserIndices}");
                          var loserCards = [...cardsHandler[widget.index][1], ...underTotemCards];
                          for (int i = 0; i < loserIndices.length; i++) {
                            loserCards = [...loserCards, ...cardsHandler[loserIndices[i]][1]];
                            decreaseCardsArray(cardsHandler[loserIndices[i]][1][0]);
                          }
                          decreaseCardsArray(cardsHandler[widget.index][1][0]);
                          loserCards.shuffle();
                          int cardsToAdd = loserCards.length ~/ loserIndices.length;
                          uploadData = {
                            'totem': false,
                            'turn': loserIndices[loserIndices.length - 1],
                            'underTotemCards' : [],
                            'player_${widget.index}_openCards' : [],
                            'matchingCards' : matchingRegularCards,
                            'matchingColorCards' : matchingColorCards,
                            'player_${loserIndices[loserIndices.length - 1]}_openCards': [],
                            'player_${loserIndices[loserIndices.length - 1]}_deck':
                            [...cardsHandler[loserIndices[loserIndices.length - 1]][0],
                            ...loserCards.sublist(cardsToAdd * (loserIndices.length - 1), loserCards.length)
                            ]
                          };
                          cloudMassages['player${widget.index}MSGS'] = 'you win';
                          if(loserIndices.length > 0 ){
                            cloudMassages['player${loserIndices[loserIndices.length - 1]}MSGS'] = 'you lose';
                          }/*
                          cloudMassages = {
                            'Player${widget.index}Msgs': 'you win',
                            'Player${loserIndices[loserIndices.length - 1]}Msgs': 'you lose',
                          };*/
                            for (int i = 0; i < loserIndices.length - 1; i++) {
                              cloudMassages['player${loserIndices[i]}MSGS'] = 'you lose';
                              uploadData['player_${loserIndices[i]}_openCards'] = [];
                              uploadData['player_${loserIndices[i]}_deck'] = [...cardsHandler[loserIndices[i]][0],
                                ...loserCards.sublist(cardsToAdd * i, (cardsToAdd * (i + 1)))];
                            }
                            int j = 0;
                            for (int i = 0; i < widget.playersNumber; i++) {
                              if (i == widget.index) continue;
                              if (j < loserIndices.length && i == loserIndices[j]) {
                                j++;
                                continue;
                              }
                              cloudMassages['player${i}MSGS'] = "player ${widget.index} won the Battle";
                              //cloudMassages['Player${i}Msgs'] = "player ${widget.index} won the Battle";
                            }

                        await _firestore.collection(widget.collectionType).doc('game${widget.gameNum}').set(
                          uploadData, SetOptions(merge: true));
                        await _firestore.collection(widget.collectionType).doc('game${widget.gameNum}MSGS').set(
                          cloudMassages, SetOptions(merge: true));
                              }

                        ///case3 penalty
                        else {
                          for(int i = 0; i < widget.playersNumber; i ++){
                            if(cardsHandler[i][1].length > 0) decreaseCardsArray(cardsHandler[i][1][0]);
                          }
                          uploadData = {
                            'totem' : false,
                            'turn' : widget.index,
                            'underTotemCards' : [],
                            'matchingCards': matchingRegularCards,
                            'matchingColorCards' : matchingColorCards,
                            'cardsActiveUniqueArray' : uniqueArray,
                          };
                          cloudMassages['player${widget.index}MSGS'] =  "you were penalized";
                          /*
                          cloudMassages = {
                            'Player${widget.index}Msgs' : "you were penalized"
                          };*/
                          var loserDeck = [...underTotemCards];
                          for(int i = 0; i < widget.playersNumber; i++){
                            loserDeck = [...loserDeck, ...cardsHandler[i][1]];
                            uploadData['player_${i}_openCards'] = [];
                          }
                          loserDeck.shuffle();
                          uploadData['player_${widget.index}_deck'] = [...cardsHandler[widget.index][0], ...loserDeck];
                          print("after totem update: ${matchingRegularCards}");
                          for(int i = 0; i < widget.playersNumber; i++){
                            if(i == widget.index) continue;
                            cloudMassages['player${i}MSGS'] = "player ${widget.index} was penalized";
                          }
                          await _firestore.collection(widget.collectionType).doc('game${widget.gameNum}').set(
                              uploadData, SetOptions(merge : true));
                          await _firestore.collection(widget.collectionType).doc('game${widget.gameNum}MSGS').
                            set(cloudMassages, SetOptions(merge : true));
                        }
                    var winners = [];
                    for(int i = 0; i < widget.playersNumber; i ++){
                    if(cardsHandler[i][0].length == 0 && cardsHandler[i][1].length == 0 ) winners.add(i);
                    }
                    if(winners.length > 0){
                      Future.delayed(Duration(milliseconds: 1500 ));
                    var finalMsg = "";
                    if(winners.length > 1) finalMsg = "there is no sole winner in this battle";
                    else  finalMsg = "Player No, ${winners[0]} won !";
                    for(int i = 0; i < widget.playersNumber; i++){
                      //cloudMassages['Player${i}Msgs'] = finalMsg;
                      cloudMassages['player${i}MSGS'] = finalMsg;
                    }
                    await _firestore.collection(widget.collectionType).doc('game${widget.gameNum}MSGS').
                      set(cloudMassages, SetOptions(merge : true));
                    await _firestore.collection(widget.collectionType).doc('game${widget.gameNum}').
                      set({'turn' : -3,}, SetOptions(merge: true));
                    }})
                ]));
          }
          else return SizedBox(width: 0.01,);
        });
  }
}