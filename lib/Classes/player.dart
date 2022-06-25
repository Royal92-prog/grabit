import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit/Classes/card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/services/avatarManager.dart';
import 'package:grabit/services/playerManager.dart';

import 'deck.dart';

enum ECardColor      { YELLOW, GREEN, RED, BLUE}




class Player extends StatefulWidget {
  final int index;
  final int deviceIndex;
  final Function(bool) currentTurnCallback;
  final String nickname;
  final gameNum;
  final int playersNumber;

  const Player({required this.index, required this.deviceIndex,
    required this.currentTurnCallback, required this.nickname, required this.gameNum, required this.playersNumber});


  @override
  State<Player> createState() => PlayerState();

}

class PlayerState extends State<Player>{

  var avatarUrl;
  var playerUnopenedCards;
  var playerOpenedCards; /// Todo front not included ///
  var playerRemaniningCardsCount;
  var playerCurrentlyOpenedCard; ///Todo use unique identifier for cards Card.cardNumber ///
  var playerHasWon = 0 ;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    if ((widget.index == 1 && widget.playersNumber < 4) || (widget.index == 2 && widget.playersNumber == 5) ){//player No.1
      //Positioned(right:0.01 * size.width,child:
      return Stack(fit:StackFit.loose,children: [
        Positioned(
          child: CircleAvatar(
            radius: 30,
            backgroundImage: const AssetImage('assets/Lobby/Avatar_photo.png'),
            foregroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl!),
          ),
        ),
        Positioned(left: 0.12* size.width,top: 0.25* size.height,child:
        playerDeck(index:widget.index, gameNum: widget.gameNum)),
        Positioned(right: 0.11* size.width,top: 0.16* size.height, child: Text(widget.nickname, style:
            GoogleFonts.galindo( fontSize:14,color: Colors.white,),)),
        Positioned(top: size.height*0.37,right:size.width*0.13,child: currentCard(index: widget.index, gameNum: widget.gameNum,))]);
    }

    else if(widget.index == 0 || widget.index == 1){//0
        return Stack(children: [
        Positioned(
          child: CircleAvatar(
            radius: 30,
            backgroundImage: const AssetImage('assets/Lobby/Avatar_photo.png'),
            foregroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl!),
          ),
        ),
        Positioned(right: 0.11* size.width,top: 0.25* size.height,child:
        playerDeck(index:widget.index, gameNum: widget.gameNum,)),

        Positioned(bottom:size.height*0.15,left:size.width*0.23,child: currentCard(index: widget.index, gameNum: widget.gameNum,)),

        Positioned(right: 0.11* size.width,top: 0.16* size.height,child: Text(widget.nickname, style: GoogleFonts.galindo( fontSize:14,color: Colors.white,),))
        ]);
    }

    else{//Player number 2
      return Stack(children: [
        Positioned(
          child: CircleAvatar(
            radius: 30,
            backgroundImage: const AssetImage('assets/Lobby/Avatar_photo.png'),
            foregroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl!),
          ),
        ),
        Positioned(left: 0.12* size.width,top: 0.25* size.height,child:
        playerDeck(index:widget.index, gameNum: widget.gameNum,)),
        Positioned(right: 0.11* size.width,top: 0.16* size.height,child: Text(widget.nickname, style:GoogleFonts.galindo( fontSize:14,color: Colors.white,),)),
        Positioned(bottom:size.height*0.17,right:size.width*0.23,child: currentCard(index: widget.index, gameNum: widget.gameNum,))]);
    }
  }

  void getAvatar() async{
    avatarUrl = await getAvatarByGameIndex(widget.index, widget.gameNum);
  }
}
