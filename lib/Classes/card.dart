import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../main.dart';

enum ECardColor      { YELLOW, GREEN, RED, BLUE}
enum ECardIsUnique   { YES , NO}
enum ECardUniqueType { INSIDE_ARROWS, OUTSIDE_ARROWS, COLOR_MATCH } ///TODO add: 1.swap Decks, 2.joker 3. change direction
Map <int,String> cardsDic = {1 : 'assets/1.svg', 2 : 'assets/2.svg', 3 : 'assets/3.svg',
  4 : 'assets/4.svg', 5 : 'assets/5.svg', 6 : 'assets/CTA Button .svg'};


class currentCard extends StatefulWidget {
  int index;
  currentCard({required this.index});
  @override
  State<currentCard> createState() => cardState();

}
class cardState extends State<currentCard>{
  var cardColor;
  var cardIsUnique;
  var cardImage;
  var cardNumber; /// Think if relevant out of 80 cards


  @override
  Widget build(BuildContext context) {
    var gameHand = Provider.of<gameHandler>(context);
    var size = MediaQuery.of(context).size;
    print("chhdhdh");
    print(gameHand.cardsHandler[widget.index][1]);
    return Container(
      child:gameHand.cardsHandler[widget.index][1].length == 0 ? SizedBox(width: 10,height: 10,):
      SvgPicture.asset(cardsDic[gameHand.cardsHandler[widget.index][1][0]]
      as String,width: 0.12 * size.width, height:
      0.12 * size .height,
          ),);

  }



}