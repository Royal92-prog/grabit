import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit/Classes/card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/services/playerManager.dart';

import 'deck.dart';

enum ECardColor      { YELLOW, GREEN, RED, BLUE}




class Player extends StatefulWidget {
  final int index;
  final int deviceIndex;
  final Function(bool) currentTurnCallback;
  final String nickname;
  final gameNum;
  const Player({required this.index, required this.deviceIndex, required this.currentTurnCallback, required this.nickname, required this.gameNum});


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
    print(widget.nickname);
    var size = MediaQuery.of(context).size;
    if (widget.index == 1){//player No.1
    //Positioned(right:0.01 * size.width,child:
      return Stack(fit:StackFit.loose,children: [
        Positioned(child:Container(margin:EdgeInsets.all(0.1*size.width),height:0.12 * size.height,
          width:0.12 * size.width,
          decoration: BoxDecoration(
            color:Colors.blue, shape: BoxShape.circle,),),),
        Positioned(left: 0.12* size.width,top: 0.25* size.height,child:
        playerDeck(index:widget.index, deviceIndex: widget.deviceIndex, currentTurnCallback: widget.currentTurnCallback, gameNum: widget.gameNum,)), Positioned(right: 0.11* size.width,
            top: 0.16* size.height, child: Text(widget.nickname, style:
            GoogleFonts.galindo( fontSize:14,color: Colors.white,),)),
        Positioned(top: size.height*0.37,right:size.width*0.13,child: currentCard(index: widget.index, gameNum: widget.gameNum,))]);
    }
//-size.height*0.01
    else if(widget.index == 0){//0
        return Stack(children: [
        Positioned(child:Container(margin:EdgeInsets.all(0.1*size.width),height:0.12 * size.height,
          width:0.12 * size.width,
          decoration: BoxDecoration(
            color:Colors.blue, shape: BoxShape.circle,),),),
          Positioned(right: 0.11* size.width,top: 0.25* size.height,child:
          playerDeck(index:widget.index, deviceIndex: widget.deviceIndex, currentTurnCallback: widget.currentTurnCallback, gameNum: widget.gameNum,)),
          Positioned(right: 0.11* size.width,top: 0.16* size.height,
              child: Text(widget.nickname, style: GoogleFonts.galindo( fontSize:14,color: Colors.white,),)),
          Positioned(bottom:size.height*0.15,left:size.width*0.23,child: currentCard(index: widget.index, gameNum: widget.gameNum,))]);
    }

    else{//Player number 2
      return Stack(children: [
        Positioned(child:Container(margin:EdgeInsets.all(0.1*size.width),height:0.12 * size.height,
          width:0.12 * size.width,
          decoration: BoxDecoration(
            color:Colors.blue, shape: BoxShape.circle,),),),
        Positioned(left: 0.12* size.width,top: 0.25* size.height,child:
        playerDeck(index:widget.index, deviceIndex: widget.deviceIndex, currentTurnCallback: widget.currentTurnCallback, gameNum: widget.gameNum,)),
        Positioned(right: 0.11* size.width,top: 0.16* size.height,
            child: Text(widget.nickname, style:
            GoogleFonts.galindo( fontSize:14,color: Colors.white,),)),
        Positioned(bottom:size.height*0.17,right:size.width*0.23,child: currentCard(index: widget.index, gameNum: widget.gameNum,))]);
      /*
      return Container(width:size.width*0.4,height:size.height*0.3,child:Stack(children: [Positioned(
      child:Column(children:
          [Text("Player No.1",style: TextStyle(fontSize: 10,color: Colors.white)
          ,),Container(height:0.12 * size.height,
          width:0.12 * size.width, decoration: BoxDecoration(
          color:Colors.blue,
          shape: BoxShape.circle,),)],),left: size.width*0.002,),
          playerDeck(),Positioned(left:size.width*0.002,child: currentCard())]));
      */

    }

  }

  // void getNickname() async{
  //   nickname = await getNicknameByIndex(widget.index);
  // }

}
//Container(height:20,width: 60,color: Colors.green,),
