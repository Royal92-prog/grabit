import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit/Classes/card.dart';
import 'package:grabit/Screens/entryScreen.dart';
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
  late int currentTurn;
  late var cardsHandler;
  late var cardsGroupArray;
  late var cardsColorArray ;
  late var cardsActiveUniqueArray;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('game').doc('game1').snapshots(),
      builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> snapshot){
      if(snapshot.connectionState == ConnectionState.active){
       final cloudData = snapshot.data;
       if(cloudData != null) {
         cardsHandler = [[cloudData['player_0_deck'], cloudData['player_0_openCards']],
         [cloudData['player_1_deck'], cloudData['player_1_openCards']],
         [cloudData['player_2_deck'], cloudData['player_2_openCards']]];
         currentTurn = cloudData['turn'];
         cardsGroupArray = cloudData['matchingCards'];
         cardsColorArray = cloudData['matchingColorCards'];
         cardsActiveUniqueArray = cloudData['cardsActiveUniqueArray']; /// 0: insideArrows, 1: color, 2: outsideArrows
       }
    return GestureDetector(
    onTap: currentTurn != widget.index ? null : () async{
      print('deck cards group = ${cardsGroupArray}');
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection("game").doc("game1").set({'turn' : -1},SetOptions(merge :true));
      if ((cardsHandler[widget.index][1].length > 0)) {//playerOpenCards
        if (((cardsHandler[widget.index][1][0])-1)~/4 < cardsGroupArray.length) { /// regular card
          cardsGroupArray[((cardsHandler[widget.index][1][0]) - 1) ~/ 4] -= 1; // re
          cardsColorArray[(((cardsHandler[widget.index][1][0]) - 1)%4)] -=1; /// 0 blue 1 green 2 red 3 yellow
        }
        else { /// unique cards
          cardsActiveUniqueArray[((((cardsHandler[widget.index][1][0]) - 1))-numberOfRegularCards)~/2] -=1;
        }// move card number from array
        }
      print("kalimera ${widget.index.toString()}");
      cardsHandler[widget.index][1].insert(0,cardsHandler[widget.index][0].removeAt(0));
        ///TODO add check for unique cards
      if (((cardsHandler[widget.index][1][0])-1)~/4 < cardsGroupArray.length) { /// regular card
        cardsGroupArray[((cardsHandler[widget.index][1][0]) - 1) ~/ 4] += 1; // add new front number to array
        cardsColorArray[(((cardsHandler[widget.index][1][0]) - 1)%4)] += 1; /// 0 blue 1 green 2 red 3 yellow

      }
      else { /// unique cards
        print('kalamarit');
        if (((((cardsHandler[widget.index][1][0]) - 1)) - numberOfRegularCards)~/2 == 2){
          for(int i = 0; i < 3; i++) {
            cardsHandler[i][1].insert(0, cardsHandler[i][0].removeAt(0));
          }
        }
        else{
          cardsActiveUniqueArray[((((cardsHandler[widget.index][1][0]) - 1))-numberOfRegularCards)~/2] += 1;
        }
      }
        print ("cardsActive Unique Array");
        print(cardsActiveUniqueArray);
        //print("cardsColorArray is");
        //print(cardsColorArray);
       print(cardsHandler[0][1]);
        //remember to substract 1 from player index when using firebase
        await db.collection("game").doc("game1").set({
          'player_0_deck' : cardsHandler[0][0],
          'player_1_deck' : cardsHandler[1][0],
          'player_2_deck' : cardsHandler[2][0],
          'player_0_openCards' : cardsHandler[0][1],
          'player_1_openCards' : cardsHandler[1][1],
          'player_2_openCards' : cardsHandler[2][1],
          'turn' : (widget.index + 1) % 3,
          'matchingCards': cardsGroupArray,
          'matchingColorCards' : cardsColorArray,
          'cardsActiveUniqueArray' : cardsActiveUniqueArray},SetOptions(merge :true));
        },
      child:Stack(clipBehavior: Clip.antiAliasWithSaveLayer, fit: StackFit.passthrough,children:
      [
      SvgPicture.asset('assets/Full_pack.svg',
      width: 0.1 * size.width, height: 0.1 * size.height,),
      Positioned(top: 0.01*size.height,right:0.012*size.width,
      child:Text("${cardsHandler[widget.index][0].length}",style:
      TextStyle(fontSize: 15,color: Colors.black)),)],
      ),);
          // : Text("${24}"

      }
        else return CircularProgressIndicator();//SizedBox(width: size.width * 0.1, height: size.height * 0.1);
      });
    }
}

/*
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
    );

    var cardsArr = [for(var i=1; i<=numberOfRegularCards; i++) i];
    cardsArr.shuffle();
    var widthMes = 0.01;//remainingCards.hiddenCards.length > 9 ? 0.01 : 0.018;//how to align the card's Text - 2 different cases
    var size = MediaQuery.of(context).size;

    
    
    
    return GestureDetector(
      onTap: currentTurn != widget.index ? null : () async{
        setState(() {
          initialized = true;
          currentTurn = -1;
        });
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
*/