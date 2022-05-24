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
              cardsGroupArray = cloudData['matchingCards'];
            }
            return GestureDetector(
                child:Image.asset('assets/CTAButton.png',width: 0.2 * size.width,height: 0.15
                    * size.height,alignment: Alignment.center),
                onTap: isTotemPressed ? null : () async{
                  FirebaseFirestore _firestore = FirebaseFirestore.instance;
                  //await _firestore.collection('game').doc('game1').set({'totem' : true}, SetOptions(merge : true));


                  /// Regular Matching Attemp ///
                  if (cardsGroupArray[(((cardsHandler[widget.index][1][0])-1)~/4 )] > 1) {
                    for (int i = 0; i < numPlayers; i++) {
                      if (i == widget.index || cardsHandler[i][1] == []) continue;
                      if ((((cardsHandler[i][1][0])-1)~/4 ) == (cardsHandler[currentTurn][1][0]-1)~/4){
                        print("i is ${i}");
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
                    }
                  }
                else {

                    print("Eytham");
                  }
                }

            );
          }
          else return SizedBox(width: 0.01,);
        });












  }
}
