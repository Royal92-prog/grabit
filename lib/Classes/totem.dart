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
 late var matchingColorCards;
 late var matchingRegularCards;
 late var cardsGroupArray;
 late int currentTurn ;
 var cardsHandler = [];
 int numPlayers = 3;
 bool _isColorActive = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
              matchingColorCards = cloudData['matchingColorCards'];
            }
            return GestureDetector(
                child:Image.asset('assets/CTAButton.png',width: 0.2 * size.width,height: 0.15
                    * size.height,alignment: Alignment.center),
                onTap: isTotemPressed ? null : () async{
                  FirebaseFirestore _firestore = FirebaseFirestore.instance;
                  /// Regular Matching Attemp ///

                  if (cardsHandler[widget.index][1].length > 0 &&
                      ((!_isColorActive && cardsGroupArray[(((cardsHandler[widget.index][1][0])-1)~/4 )] > 1) ||
                          (_isColorActive && cardsGroupArray[(((cardsHandler[widget.index][1][0])-1) % 4 )] > 1)))
                  {/*
                    for (int i = 0; i < numPlayers; i++) {
                      if (i == widget.index || cardsHandler[i][1] == []) continue;
                      if ((((cardsHandler[i][1][0])-1)~/4 ) == (cardsHandler[widget.index][1][0]-1)~/4){
                        print("i is ${i}");
                        print("mixing ${(((cardsHandler[i][1][0])-1)~/4 )}, ${(cardsHandler[widget.index][1][0]-1)~/4}");
                        var loserCards = [...cardsHandler[i][1], ...cardsHandler[widget.index][1]];
                        loserCards.shuffle();
                        setState(() {
                          cardsHandler[i][0] = [...cardsHandler[i][0],...loserCards];
                          cardsHandler[widget.index][1] = [];
                          cardsHandler[i][1] = [];
                          currentTurn = i;
                        });
                        await _firestore.collection('game').doc('game1').set({'totem' : false, 'turn' : i,
                          'player_${i}_openCards' : cardsHandler[i][1],
                          'player_${i}_deck' : cardsHandler[i][0],
                          'player_${widget.index}_openCards' : cardsHandler[widget.index][1],
                          'player_${widget.index}_deck' : cardsHandler[widget.index][0]}, SetOptions(merge : true));
                        break;
                      }
                    }*/
                    int loserIndex = getLoserIndex();
                    var loserCards = [...cardsHandler[loserIndex][1], ...cardsHandler[widget.index][1]];
                    loserCards.shuffle();
                    setState(() {
                      cardsHandler[loserIndex][0] = [...cardsHandler[loserIndex][0],...loserCards];
                      cardsHandler[widget.index][1] = [];
                      cardsHandler[loserIndex][1] = [];
                      currentTurn = loserIndex;
                      matchingRegularCards[(((cardsHandler[loserIndex][1][0])-1) ~/4)] -= 1;
                      matchingColorCards[(((cardsHandler[loserIndex][1][0])-1) % 4)] -= 1;
                      matchingRegularCards[(((cardsHandler[widget.index][1][0])-1) ~/4)] -= 1;
                      matchingColorCards[(((cardsHandler[widget.index][1][0])-1) % 4 )] -= 1;
                    });
                    await _firestore.collection('game').doc('game1').set({
                      'totem' : false,
                      'turn' : loserIndex,
                      'player_${loserIndex}_openCards' : cardsHandler[loserIndex][1],
                      'player_${loserIndex}_deck' : cardsHandler[loserIndex][0],
                      'player_${widget.index}_openCards' : cardsHandler[widget.index][1],
                      'player_${widget.index}_deck' : cardsHandler[widget.index][0],
                      'matchingCards': matchingRegularCards,
                      'matchingColorCards' : matchingColorCards,}, SetOptions(merge : true));
                  }
                else {
                    print("penalty - ");
                }
                }

            );
          }
          else return SizedBox(width: 0.01,);
        });












  }
}
