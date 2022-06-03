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
 //late var playerOpenCards;
 late var cardsGroupArray;
 late int currentTurn ;
 var cardsHandler = [];
 int numPlayers = 3;
 bool _isColorActive = false;
 final _mistakeSnackbar = const SnackBar(
     content: Text('penalty'),
 );

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
              //playerOpenCards = cloudData['player_${widget.index.toString()}_openCards'];
              currentTurn = cloudData['turn'];
              _isColorActive = cloudData['cardsActiveUniqueArray'][1] > 0;
              cardsGroupArray = _isColorActive ? cloudData['matchingColorCards'] : cloudData['matchingCards'];
            }
            return GestureDetector(
                child:Image.asset('assets/CTAButton.png',width: 0.2 * size.width,height: 0.15
                    * size.height,alignment: Alignment.center),
                onTap: isTotemPressed ? null : () async{
                  print('totem index = ${widget.index}');
                  FirebaseFirestore _firestore = FirebaseFirestore.instance;
                  /// Regular Matching Attemp ///


                  if (cardsHandler[widget.index][1].length > 0 &&
                      ((!_isColorActive && cardsGroupArray[(((cardsHandler[widget.index][1][0])-1)~/4 )] > 1) ||
                          (_isColorActive && cardsGroupArray[(((cardsHandler[widget.index][1][0])-1) % 4 )] > 1))) {
                    int loserIndex = getLoserIndex();
                    var loserCards = [...cardsHandler[loserIndex][1], ...cardsHandler[widget.index][1]];
                    loserCards.shuffle();
                    setState(() {
                      cardsHandler[loserIndex][0] = [...cardsHandler[loserIndex][0],...loserCards];
                      cardsHandler[widget.index][1] = [];
                      cardsHandler[loserIndex][1] = [];
                      currentTurn = loserIndex;
                    });
                    await _firestore.collection('game').doc('game1').set({'totem' : false, 'turn' : loserIndex,
                      'player_${loserIndex}_openCards' : cardsHandler[loserIndex][1],
                      'player_${loserIndex}_deck' : cardsHandler[loserIndex][0],
                      'player_${widget.index}_openCards' : cardsHandler[widget.index][1],
                      'player_${widget.index}_deck' : cardsHandler[widget.index][0]}, SetOptions(merge : true));
                    }
                else {
                    print("penalty - ");
                    ScaffoldMessenger.of(context).showSnackBar(_mistakeSnackbar);
                }
                }

            );
          }
          else return SizedBox(width: 0.01,);
        });
  }

  int getLoserIndex() {
    for (int i = 0; i < numPlayers; i++) {
      if (i == widget.index || cardsHandler[i][1] == []) continue;
      if (_isColorActive) {
        if ((((cardsHandler[i][1][0]) - 1) % 4) ==
            (cardsHandler[widget.index][1][0] - 1) % 4) {
          return i;
        }
      }
      else {
        if ((((cardsHandler[i][1][0]) - 1) ~/ 4) ==
            (cardsHandler[widget.index][1][0] - 1) ~/ 4) {
          return i;
        }
      }
    }
    return -1;
  }
}
