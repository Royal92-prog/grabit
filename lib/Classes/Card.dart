import 'package:flutter/cupertino.dart';

enum ECardColor      { YELLOW, GREEN, RED, BLUE}
enum ECardIsUnique   { YES , NO}
enum ECardUniqueType { INSIDE_ARROWS, OUTSIDE_ARROWS, COLOR_MATCH } ///TODO add: 1.swap Decks, 2.joker 3. change direction
Map <int,String> cardsDic = {1 : 'assets/1.svg', 2 : 'assets/2.svg', 3 : 'assets/3.svg',
  4 : 'assets/4.svg', 5 : 'assets/5.svg'};


class Card extends StatelessWidget {
  var cardColor;
  var cardIsUnique;
  var cardImage;
  var cardNumber; /// Think if relevant out of 80 cards

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("onTap called.");
      },
      child: Text("foo"),);

  }


}