import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class totem extends StatefulWidget {
  totem({required this.index});
  int index;

  @override
  State<totem> createState() => totemState();

}

class totemState extends State<totem>{
 bool isTotemPressed = false;
 final int numberOfRegularCards = 72;
 var underTotemCards = [];
 var outerArrowsTracking = [0,2];
 late var matchingColorCards;
 late var matchingRegularCards;
 late var cardsGroupArray;
 late var uniqueArray;
 late int currentTurn ;
 var cardsHandler = [];
 int numPlayers = 3;
 bool _isColorActive = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double rightPosition = underTotemCards.length > 9 ? 0.008 : 0.016;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('game').doc('game1').snapshots(),
        builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            final cloudData = snapshot.data;
            if(cloudData != null) {
              isTotemPressed = cloudData['totem'];
              cardsHandler = [[cloudData['player_0_deck'], cloudData['player_0_openCards']],
              [cloudData['player_1_deck'], cloudData['player_1_openCards']],
              [cloudData['player_2_deck'], cloudData['player_2_openCards']]];
              currentTurn = cloudData['turn'];
              _isColorActive = cloudData['cardsActiveUniqueArray'][1] > 0;
              cardsGroupArray = _isColorActive ? cloudData['matchingColorCards'] : cloudData['matchingCards'];
              matchingRegularCards = cloudData['matchingCards'];
              uniqueArray = cloudData['cardsActiveUniqueArray'];
              matchingColorCards = cloudData['matchingColorCards'];
            }
            return Container(height: size.height * 0.3, width: size.width * 0.3, child: Stack(children:
            [underTotemCards.length > 0 ? Positioned(right: size.width * 0.065,child: Stack(children :
            [SvgPicture.asset('assets/Full_pack.svg', width: 0.1 * size.width, height: 0.1 * size.height,)
            ,Positioned(left: rightPosition * size.width, top: 0.009 * size.height,
            child: Text("${underTotemCards.length}",style: TextStyle(fontSize: 15,color: Colors.black)))])) :
            SizedBox(),GestureDetector(child:Image.asset('assets/CTAButton.png', width: 0.2 * size.width,
            height: 0.15 * size.height,alignment: Alignment.center),
            onTap: isTotemPressed ? null : () async{
                  FirebaseFirestore _firestore = FirebaseFirestore.instance;
                  await _firestore.collection('game').doc('game1').set({'totem' : true}, SetOptions(merge : true));
                  ///#1st case :  totem was pressed since inner arrows is on the table
                  if (uniqueArray[0] > 0 && uniqueArray[0] > uniqueArray[3]){
                    uniqueArray[3] += 1;// marking that the special card is used
                    if(cardsHandler[widget.index][1].length > 0) decreaseCardsArray(cardsHandler[widget.index][1][0]);
                    underTotemCards =[...underTotemCards, ...cardsHandler[widget.index][1]];
                    underTotemCards.shuffle();
                    cardsHandler[widget.index][1] = [];
                    await _firestore.collection('game').doc('game1').set({
                      'totem' : false,
                      'turn' : widget.index,
                      'cardsActiveUniqueArray' : uniqueArray,
                      'matchingCards': matchingRegularCards,
                      'matchingColorCards' : matchingColorCards,
                      'player_${widget.index}_openCards' : [],}, SetOptions(merge : true));
                  }
                  ///#2nd case :  totem was pressed for the regular reason (color / regular mode)
                  else if (cardsHandler[widget.index][1].length > 0 &&
                  ((!_isColorActive && cardsGroupArray[(((cardsHandler[widget.index][1][0])-1)~/4 )] > 1) ||
                  (_isColorActive && cardsGroupArray[(((cardsHandler[widget.index][1][0])-1) % 4 )] > 1))) {
                    int loserIndex = getLoserIndex();
                    var loserCards = [...cardsHandler[loserIndex][1], ...cardsHandler[widget.index][1], ...underTotemCards];
                    loserCards.shuffle();
                    setState(() {
                      underTotemCards = [];
                      //print("cards to decrease :: ${cardsHandler[loserIndex][1][0]}, ${cardsHandler[widget.index][1][0]} ");
                      decreaseCardsArray(cardsHandler[loserIndex][1][0]);
                      decreaseCardsArray(cardsHandler[widget.index][1][0]);
                      cardsHandler[loserIndex][0] = [...cardsHandler[loserIndex][0],...loserCards];
                      cardsHandler[widget.index][1] = [];
                      cardsHandler[loserIndex][1] = [];
                      currentTurn = loserIndex;
                      //print("loserIndex : ${cardsHandler[loserIndex]}");
                    });
                    await _firestore.collection('game').doc('game1').set({
                      'totem' : false,
                      'turn' : loserIndex,
                      'player_${loserIndex}_openCards' : cardsHandler[loserIndex][1],
                      'player_${loserIndex}_deck' : cardsHandler[loserIndex][0],
                      'player_${widget.index}_openCards' : cardsHandler[widget.index][1],
                      'player_${widget.index}_deck' : cardsHandler[widget.index][0],
                      'matchingCards': matchingRegularCards,
                      'matchingColorCards' : matchingColorCards,
                      }, SetOptions(merge : true));
                  }
                  ///#3rd case :  totem was pressed by mistake
                else {
                    print("penalty - ");
                    //3 is the number of players
                    for(int i = 0; i < 3; i ++){
                      if(cardsHandler[i][1].length > 0) decreaseCardsArray(cardsHandler[i][1][0]);
                      //print("card is ${cardsHandler[i][1][0]}");
                    }
                    var loserDeck = [...cardsHandler[0][1], ...cardsHandler[1][1], ...cardsHandler[2][1], ...underTotemCards];
                    print("Loser ${loserDeck}");
                    cardsHandler[0][1] = [];
                    cardsHandler[1][1] = [];
                    cardsHandler[2][1] = [];
                    underTotemCards = [];
                    loserDeck.shuffle();
                    cardsHandler[widget.index][0] = [...cardsHandler[widget.index][0], ...loserDeck];
                    print("after totem update: ${matchingRegularCards}");
                    await _firestore.collection('game').doc('game1').
                    set({
                      'player_${0}_openCards' : cardsHandler[0][1],
                      'player_${0}_deck' : cardsHandler[0][0],
                      'player_${1}_openCards' : cardsHandler[1][1],
                      'player_${1}_deck' : cardsHandler[1][0],
                      'player_${2}_openCards' : cardsHandler[2][1],
                      'player_${2}_deck' : cardsHandler[2][0],
                      'matchingCards': matchingRegularCards,
                      'matchingColorCards' : matchingColorCards,
                      'cardsActiveUniqueArray' : uniqueArray,
                      'totem' : false}, SetOptions(merge : true));
                }
                //checking whther we have a winner after this press
                  var winners = [];
                  for(int i = 0; i < 3; i ++){
                    if(cardsHandler[i][0].length == 0 && cardsHandler[i][1].length == 0 ) winners.add(i);
                    //print("card is ${cardsHandler[i][1][0]}");
                  }
                  print("winners are :: ${winners}");
                }
                )],));
          }
          else return SizedBox(width: 0.01,);
        });
  }

 int getLoserIndex() {
   for (int i = 0; i < numPlayers; i++) {
     if (i == widget.index || cardsHandler[i][1] == []) continue;
     if (_isColorActive) {
       if (cardsHandler[i][1][0] <= 72 && ((((cardsHandler[i][1][0]) - 1) % 4) == (cardsHandler[widget.index][1][0] - 1) % 4)) {
         return i;
       }
     }
     else {
       if ((((cardsHandler[i][1][0]) - 1) ~/ 4) == (cardsHandler[widget.index][1][0] - 1) ~/ 4) {
         return i;
       }
     }
   }
   return -1;
 }


 decreaseCardsArray(int card){
   if((card -1) ~/4 < matchingRegularCards.length){
     matchingRegularCards[(card - 1) ~/ 4] -= 1; // add new front number to array
     matchingColorCards[((card - 1) % 4)] -= 1;
   }
   else{//unique card
     print("card is :: line 186 :: ${card}");
     uniqueArray[(((card - 1)) - numberOfRegularCards) ~/ 2] -= 1;
     if((((card - 1))-numberOfRegularCards) ~/ 2 == 0 && uniqueArray[2] > 0) {
       uniqueArray[3] -= 1;
     }
   }
 }

}
