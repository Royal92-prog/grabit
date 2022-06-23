import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class totem extends StatefulWidget {
  totem({required this.index, required this.gameNum, required this.playersNumber});
  int playersNumber;
  int index;
  final int gameNum;

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
          print("HERE Line 197");
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
      matchingRegularCards[(card - 1) ~/ 4] -=
      1; // add new front number to array
      matchingColorCards[((card - 1) % 4)] -= 1;
    }
    else { //unique card
      print("card is :: line 186 :: ${card}");
      uniqueArray[(((card - 1)) - numberOfRegularCards) ~/ 2] -= 1;
      if ((((card - 1)) - numberOfRegularCards) ~/ 2 == 0 &&
          uniqueArray[3] > 0) {
        uniqueArray[3] -= 1;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    double rightPosition = underTotemCards.length > 9 ? 0.008 : 0.016;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('game').doc(
            'game${widget.gameNum}').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot <DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final cloudData = snapshot.data;
            if (cloudData != null) {
              cardsHandler = [];
              isTotemPressed = cloudData['totem'];
              for (int i = 0; i < widget.playersNumber; i++) {
                cardsHandler.add([
                  cloudData['player_${i}_deck'],
                  cloudData['player_${i}_openCards']
                ]);
              }
              currentTurn = cloudData['turn'];
              underTotemCards = cloudData['underTotemCards'];
              _isColorActive = cloudData['cardsActiveUniqueArray'][1] > 0;
              cardsGroupArray = _isColorActive
                  ? cloudData['matchingColorCards']
                  : cloudData['matchingCards'];
              matchingRegularCards = cloudData['matchingCards'];
              uniqueArray = cloudData['cardsActiveUniqueArray'];
              matchingColorCards = cloudData['matchingColorCards'];
            }
            return Container(height: size.height * 0.3,
                width: size.width * 0.3,
                child: Stack(children:
                [
                  underTotemCards.length > 0 ? Positioned(
                      right: size.width * 0.065, child: Stack(children:
                  [
                    SvgPicture.asset(
                      'assets/Full_pack.svg', width: 0.1 * size.width,
                      height: 0.1 * size.height,)
                    ,
                    Positioned(left: rightPosition * size.width,
                        top: 0.009 * size.height,
                        child: Text("${underTotemCards.length}",
                            style: TextStyle(
                                fontSize: 15, color: Colors.black)))
                  ])) :
                  SizedBox(),
                  GestureDetector(child: Image.asset(
                      'assets/CTAButton.png', width: 0.2 * size.width,
                      height: 0.15 * size.height, alignment: Alignment.center),
                      onTap: isTotemPressed ? null : () async {
                        Map<String, dynamic> cloudMassages = {};
                        FirebaseFirestore _firestore = FirebaseFirestore
                            .instance;

                        /// TODO problem sync
                        await _firestore.collection('game').doc(
                            'game${widget.gameNum}').set({'totem': true,
                          'totem${widget.index}Pressed': true},
                            SetOptions(merge: true));
                        await Future.delayed(
                            const Duration(milliseconds: 1000));
                        for (int i = 0; i < widget.playersNumber &&
                            !isTotemPressed; i++) {
                          if (cloudData!['totem${i}Pressed']) return;
                        }

                        ///#1st case :  totem was pressed since inner arrows is on the table
                        print("Unique array :: ${uniqueArray}");
                        if (uniqueArray[0] > 0 &&
                            uniqueArray[0] > uniqueArray[3]) {
                          uniqueArray[3] +=
                          1; // marking that the special card is used
                          if (cardsHandler[widget.index][1].length >
                              0) decreaseCardsArray(
                              cardsHandler[widget.index][1][0]);
                          underTotemCards = [
                            ...underTotemCards,
                            ...cardsHandler[widget.index][1]
                          ];
                          underTotemCards.shuffle();
                          cardsHandler[widget.index][1] = [];
                          cloudMassages = {
                            'totem': false,
                            'totem${widget.index}Pressed': false,
                            'turn': widget.index,
                            'underTotemCards': underTotemCards,
                            'cardsActiveUniqueArray': uniqueArray,
                            'matchingCards': matchingRegularCards,
                            'matchingColorCards': matchingColorCards,
                            'player_${widget.index}_openCards': [],
                            'Player${widget
                                .index}Msgs': "inner arrows card - You Win!"
                          };
                          for (int i = 0; i < widget.playersNumber; i++) {
                            if (i == widget.index) continue;
                            cloudMassages['Player${i}Msgs'] = "player ${widget
                                .index} pressed the inner button first";
                          }
                          await _firestore.collection('game').doc('game${widget
                              .gameNum}').set(
                              cloudMassages, SetOptions(merge: true));
                        }

                        ///#2nd case :  totem was pressed for the regular reason (color / regular mode)
                        else if (cardsHandler[widget.index][1][0] <= 72 &&
                            cardsHandler[widget.index][1].length > 0 &&
                            ((!_isColorActive &&
                                cardsGroupArray[(((cardsHandler[widget
                                    .index][1][0]) - 1) ~/ 4)] > 1) ||
                                (_isColorActive &&
                                    cardsGroupArray[(((cardsHandler[widget
                                        .index][1][0]) - 1) % 4)] > 1))) {
                          print(
                              "unique ${uniqueArray} , Active ${matchingColorCards} ${_isColorActive}");
                          var loserIndices = getLoserIndex();
                          print("indices :: ${loserIndices}");
                          var loserCards = [
                            ...cardsHandler[widget.index][1],
                            ...underTotemCards
                          ];
                          for (int i = 0; i < loserIndices.length; i++) {
                            loserCards = [
                              ...loserCards,
                              ...cardsHandler[loserIndices[i]][1]
                            ];
                            decreaseCardsArray(
                                cardsHandler[loserIndices[i]][1][0]);
                          }
                          decreaseCardsArray(cardsHandler[widget.index][1][0]);
                          loserCards.shuffle();
                          int cardsToAdd = loserCards.length ~/
                              loserIndices.length;
                          cloudMassages = {
                            'totem': false,
                            'turn': loserIndices[loserIndices.length - 1],
                            'underTotemCards': [],
                            'player_${widget.index}_openCards': [],
                            'matchingCards': matchingRegularCards,
                            'matchingColorCards': matchingColorCards,
                            'Player${widget.index}Msgs': 'you win',
                            'Player${loserIndices[loserIndices.length -
                                1]}Msgs': 'you lose',
                            'player_${loserIndices[loserIndices.length -
                                1]}_openCards': [],
                            'player_${loserIndices[loserIndices.length -
                                1]}_deck':
                            [...cardsHandler[loserIndices[loserIndices.length -
                                1]][0],
                              ...loserCards.sublist(
                                  cardsToAdd * (loserIndices.length - 1),
                                  loserCards.length)
                            ]
                          };
                          for (int i = 0; i < loserIndices.length - 1; i++) {
                            print("Line 119 ${loserIndices[i]}");
                            cloudMassages['Player${loserIndices[i]}Msgs'] =
                            'you lose';
                            cloudMassages['player_${loserIndices[i]}_openCards'] =
                            [];
                            cloudMassages['player_${loserIndices[i]}_deck'] =
                            [...cardsHandler[loserIndices[i]][0],
                              ...loserCards.sublist(
                                  cardsToAdd * i, (cardsToAdd * (i + 1)))
                            ];
                          }
                          int j = 0;
                          for (int i = 0; i < widget.playersNumber; i++) {
                            if (i == widget.index) continue;
                            if (j < loserIndices.length &&
                                i == loserIndices[j]) {
                              j++;
                              continue;
                            }
                            cloudMassages['Player${i}Msgs'] =
                            "player ${widget.index} won the Battle";
                          }
                        }
                        await _firestore.collection('game').doc(
                            'game${widget.gameNum}').set(
                            cloudMassages, SetOptions(merge: true));
                      })
                ]));
          }
          else return SizedBox(width: 0.01,);
        }
        );
  }
}