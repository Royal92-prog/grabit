import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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




  @override
  Widget build(BuildContext context) {
    var gameMan = Provider.of<gameHandler>(context);
    var cardsArr = List.filled(10, 1)+List.filled(10, 2)+List.filled(10, 3)+List.filled(10, 4);
    cardsArr.shuffle();
    var widthMes = 0.01;//remainingCards.hiddenCards.length > 9 ? 0.01 : 0.018;//how to align the card's Text - 2 different cases
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: gameMan.turn != widget.index ? null : gameMan.updatePlayerStatus,
      child:Stack(clipBehavior: Clip.antiAliasWithSaveLayer, fit: StackFit.passthrough,children:
      [//Positioned(left:widthMes * size.width,top:0.06 *  size.height,child:)
        SvgPicture.asset('assets/Full_pack.svg',
          width: 0.1 * size.width, height: 0.1 * size.height,),
      Positioned(top: 0.01*size.height,right:0.012*size.width,
      child:Text("${gameMan.cardsHandler[widget.index][0].length}",style:
      TextStyle(fontSize: 15,color: Colors.black)))],
      ),);
  }



}
