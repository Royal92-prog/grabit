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
  final avatarUrl;
  final int index;
  final int deviceIndex;
  final Function(bool) currentTurnCallback;
  final String nickname;
  final gameNum;
  final int playersNumber;
  final String collectionType;

  const Player({required this.index, required this.deviceIndex,
    required this.currentTurnCallback, required this.nickname,
    required this.gameNum, required this.playersNumber,
    required this.avatarUrl, required this.collectionType});


  @override
  State<Player> createState() => PlayerState();

}

class PlayerState extends State<Player>{
  var playerUnopenedCards;
  var playerOpenedCards; /// Todo front not included ///
  var playerRemaniningCardsCount;
  var playerCurrentlyOpenedCard; ///Todo use unique identifier for cards Card.cardNumber ///
  var playerHasWon = 0 ;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    if ((widget.index == 1 && widget.playersNumber < 4) || (widget.index == 2 && widget.playersNumber == 5) ){//player No.1
      //Positioned(right:0.01 * size.width,child:
      return Stack(fit:StackFit.loose,children: [
        Positioned(
          child: Container(margin:EdgeInsets.all(0.1*size.width),height:0.12 * size.height,
            width:0.12 * size.width,
            decoration: const BoxDecoration(
              color:Colors.blue, shape: BoxShape.circle,),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: const AssetImage('assets/Lobby/Avatar_photo.png'),
              foregroundImage: widget.avatarUrl == null ? null : NetworkImage(widget.avatarUrl!),
            ),
          ),
        ),
        Positioned(left: 0.12* size.width,top: 0.25* size.height,child:
        playerDeck(index:widget.index, gameNum: widget.gameNum,
          collectionType: widget.collectionType,)),
        Positioned(right: 0.11* size.width,top: 0.16* size.height, child: Text(widget.nickname, style:
            GoogleFonts.galindo( fontSize:14,color: Colors.white,),)),
        Positioned(top: size.height*0.37,right:size.width*0.13,child:
        currentCard(index: widget.index, gameNum: widget.gameNum,
          collectionType: widget.collectionType,))]);
    }

    else if(widget.index == 0 || widget.index == 1){//0
        return Stack(children: [
        Positioned(
          child: Container(margin:EdgeInsets.all(0.1*size.width),height:0.12 * size.height,
            width:0.12 * size.width,
            decoration: const BoxDecoration(
              color:Colors.blue, shape: BoxShape.circle,),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: const AssetImage('assets/Lobby/Avatar_photo.png'),
              foregroundImage: widget.avatarUrl == null ? null : NetworkImage(widget.avatarUrl!),
            ),
          ),
        ),
        Positioned(right: 0.11* size.width,top: 0.25* size.height,child:
        playerDeck(index:widget.index, gameNum: widget.gameNum,
          collectionType: widget.collectionType,)),

        Positioned(bottom:size.height*0.15,left:size.width*0.23,child:
          currentCard(index: widget.index, gameNum: widget.gameNum,
            collectionType: widget.collectionType,)),

        Positioned(right: 0.11* size.width,top: 0.16* size.height,child: Text(widget.nickname, style: GoogleFonts.galindo( fontSize:14,color: Colors.white,),))
        ]);
    }

    else{//Player number 2
      return Stack(children: [
        Positioned(
          child: Container(margin:EdgeInsets.all(0.1*size.width),height:0.12 * size.height,
            width:0.12 * size.width,
            decoration: const BoxDecoration(
              color:Colors.blue, shape: BoxShape.circle,),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: const AssetImage('assets/Lobby/Avatar_photo.png'),
              foregroundImage: widget.avatarUrl == null ? null : NetworkImage(widget.avatarUrl!),
            ),
          ),
        ),
        Positioned(left: 0.12* size.width,top: 0.25* size.height,child:
        playerDeck(index:widget.index, gameNum: widget.gameNum,
          collectionType: widget.collectionType,)),
        Positioned(right: 0.11* size.width,top: 0.16* size.height,child: Text(widget.nickname, style:GoogleFonts.galindo( fontSize:14,color: Colors.white,),)),
        Positioned(bottom:size.height*0.17,right:size.width*0.23,
            child: currentCard(index: widget.index,
              gameNum: widget.gameNum, collectionType: widget.collectionType,))]);
    }
  }

  // void getAvatar() async{
  //   print("getting avatar");
  //   widget.avatarUrl = await getAvatarByGameIndex(widget.index, widget.gameNum);
  // }
}
