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
  playerDeck( {required this.index});

  @override
  State<playerDeck> createState() => deckState();
}
class deckState extends State<playerDeck>{
  var cardColor;
  var cardIsUnique;
  var cardImage;
  var cardNumber; /// Think if relevant out of 80 cards
    int currentTurn = 0;
    var playerDeck = [];
    var playerOpenCards = [];
    bool initialized = false;
    late var cardsGroupArray;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final gameRef = db.collection("game").doc("game1");
    gameRef.snapshots().listen(
          (event) {
           setState(() {
             playerDeck = event.data()!['player_${widget.index.toString()}_deck'];
             playerOpenCards = event.data()!['player_${widget.index.toString()}_openCards'];
             currentTurn = event.data()!['turn'];
             cardsGroupArray = event.data()!['matchingCards'];
           });
          },
      onError: (error) => print("Listen failed: $error"),
    );/*
    turnRef.snapshots().listen(
          (event) {
        setState(() {
          currentTurn =  event.data()!['turn'];
        });
      },
      onError: (error) => print("Listen failed: $error"),
    );
    */
    var cardsArr = [for(var i=1; i<=numberOfRegularCards; i++) i];
    cardsArr.shuffle();
    var widthMes = 0.01;//remainingCards.hiddenCards.length > 9 ? 0.01 : 0.018;//how to align the card's Text - 2 different cases
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: currentTurn != widget.index ? null : () async{
        setState(() {
          initialized = true;
          currentTurn = -1;
        });/*
        var cardsGroupArray = await db.collection('game').doc('matchingCards').get().
        then((querySnapshot) {return querySnapshot.data()?['matchesList'];});
        var playerOpenCards = await db.collection('game').doc('player_${widget.index}_openCards').get().
        then((querySnapshot) {return (querySnapshot.data()?['${widget.index + 3}']);});
        var playerDeck = await db.collection('game').doc('player_${widget.index}_deck').get().
        then((querySnapshot) {return (querySnapshot.data()?['${widget.index}']);});
          */
        if ((playerOpenCards.length > 0)) {
          cardsGroupArray[((playerOpenCards[0])-1)~/4] -= 1; // remove card number from array
        }
        playerOpenCards.insert(0,playerDeck.removeAt(0));
        ///TODO add check for unique cards
        cardsGroupArray[((playerOpenCards[0])-1)~/4] += 1; // add new front number to array
        await db.collection("game").doc("game1").set({'player_${widget.index.toString()}_deck' : playerDeck,
          'player_${widget.index.toString()}_openCards' : playerOpenCards, 'turn' : (widget.index + 1) % 3,'matchingCards': cardsGroupArray},SetOptions(merge :true));
        //await db.collection('game').doc('player_${widget.index.toString()}_deck')
            //.set({widget.index.toString() : playerDeck}, SetOptions(merge : false));
        //await db.collection('game').doc('player_${(widget.index).toString()}_openCards')
            //.set({(widget.index + 3).toString() : playerOpenCards}, SetOptions(merge : false));
        //await db.collection('game').doc('turn').set({'turn' : (widget.index + 1) % 3}, SetOptions(merge : false));
        //await db.collection('game').doc('matchingCards').set({'matchesList' : cardsGroupArray}, SetOptions(merge : false));
        //setState(() {//maybe not necessary
          //currentTurn = widget.index;
        //});
      },
      child:Stack(clipBehavior: Clip.antiAliasWithSaveLayer, fit: StackFit.passthrough,children:
      [//Positioned(left:widthMes * size.width,top:0.06 *  size.height,child:)
        SvgPicture.asset('assets/Full_pack.svg',
          width: 0.1 * size.width, height: 0.1 * size.height,),
      Positioned(top: 0.01*size.height,right:0.012*size.width,
      child:initialized == true ? Text("${playerDeck.length}",style:
      TextStyle(fontSize: 15,color: Colors.black)) : Text("${24}",style:
      TextStyle(fontSize: 15,color: Colors.black)))],
      ),);
  }

}
