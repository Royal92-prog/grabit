import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'package:tuple_dart/tuple.dart';

const numberOfRegularCards = 72;
const numberOfUniqueCards = 3;
const numberOfUniqueCardsRepeats = 2 ;
enum ECardColor      { BLUE, GREEN, RED, YELLOW}
enum ECardIsUnique   { YES , NO}
enum ECardUniqueType { INSIDE_ARROWS, OUTSIDE_ARROWS, COLOR_MATCH } ///TODO add: 1.swap Decks, 2.joker 3. change direction ///


Map <int,Tuple2<int,String>> cardsFullDeck = <int,Tuple2<int,String>>{};

class currentCard extends StatefulWidget {
  int index;
  int gameNum;
  String collectionType;
  currentCard({required this.index, required this.gameNum,
    required this.collectionType});
  @override
  State<currentCard> createState() => cardState();

}
class cardState extends State<currentCard>{
  var cardColor;
  var cardIsUnique;
  var cardImage;
  var cardNumber; /// Think if relevant out of 80 cards
  var openCards = [];
  void initializeCardsMap(){
    if (cardsFullDeck.isNotEmpty) return;
    /// cardsFullDeck is not empty ///
    int counter = 1;
    for (int i = 0; i< numberOfRegularCards;++i){
      for (var value in ECardColor.values){
        cardsFullDeck[counter] = Tuple2(((i~/4)+1),"assets/"+((i+1).toString())+"-"+value.toString().split('.').last+".svg")  ;
        counter++;
      }
    }

    counter = 1;
    for (int i = numberOfRegularCards; i< numberOfRegularCards+numberOfUniqueCards;++i){
      for (int j = 0 ; j < numberOfUniqueCardsRepeats ; j++){
        cardsFullDeck[counter+numberOfRegularCards] = Tuple2(((i~/4)+1),"assets/"+"Special_card"+((i-numberOfRegularCards)+1).toString()+".svg")  ;
        counter++;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeCardsMap();
    var size = MediaQuery.of(context).size;
    return StreamBuilder <DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection(widget.collectionType).
        doc('game${widget.gameNum}').snapshots(),
    builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> snapshot){
      if(snapshot.connectionState == ConnectionState.active &&
          snapshot.data?.data() != null){
      //final cloudData = snapshot.data;
        Map<String, dynamic> cloudData = (snapshot.data?.data() as Map<String, dynamic>);
        openCards = cloudData.containsKey('player_${(widget.index).toString()}_openCards') ?
          cloudData['player_${(widget.index).toString()}_openCards'] : [];

      return Container(
        child:openCards.length == 0 ? SizedBox(width: 10,height: 10,):
        SvgPicture.asset(cardsFullDeck[openCards[0]]?.item2
        as String,width: 0.12 * size.width, height:
        0.12 * size .height,
        ),);
    }
      else return SizedBox(width: 0.01,);
      });
  }
}