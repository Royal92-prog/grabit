import 'package:flutter/cupertino.dart';
import 'package:grabit/Classes/Card.dart';

enum ECardColor      { YELLOW, GREEN, RED, BLUE}




class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);


  @override
  State<Player> createState() => PlayerState();

}

class PlayerState extends State<Player>{

  var playerAvatar;
  var playerUnopenedCards;
  var playerOpenedCards; /// Todo front not included ///
  var playerRemaniningCardsCount;
  var playerCurrentlyOpenedCard; ///Todo use unique identifier for cards Card.cardNumber ///
  var playerHasWon = 0 ;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

