import 'package:flutter/cupertino.dart';

enum ECardColor      { YELLOW, GREEN, RED, BLUE}
enum ECardIsUnique   { YES , NO}
enum ECardUniqueType { INSIDE_ARROWS, OUTSIDE_ARROWS, COLOR_MATCH } ///TODO add: 1.swap Decks, 2.joker 3. change direction



class Card extends StatelessWidget {
  var cardColor;
  var cardIsUnique;
  var cardImage;
  var cardNumber; /// Think if relevant out of 80 cards

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }


}