import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit/Classes/card.dart';
import 'package:google_fonts/google_fonts.dart';

import 'deck.dart';

enum ECardColor      { YELLOW, GREEN, RED, BLUE}




class Player extends StatefulWidget {
  final int index;
  const Player({required this.index});


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

    var size = MediaQuery.of(context).size;
    //print(size.height);
    //print(size.width);

    if (widget.index == 1){//player No.1
    //Positioned(right:0.01 * size.width,child:
      return Stack(children: [
        Positioned(child:Container(margin:EdgeInsets.all(0.1*size.width),height:0.12 * size.height,
          width:0.12 * size.width,
          decoration: BoxDecoration(
            color:Colors.blue, shape: BoxShape.circle,),),),
        Positioned(left: 0.12* size.width,top: 0.25* size.height,child:
        playerDeck(index:widget.index)), Positioned(right: 0.11* size.width,
            top: 0.16* size.height, child: Text("Player No.1",style:
            GoogleFonts.galindo( fontSize:14,color: Colors.white,),)),
        Positioned(bottom:-size.height*0.01,right:size.width*0.13,child: currentCard(index: widget.index))]);
    }

    else if(widget.index == 0){//0
        return Stack(children: [
        Positioned(child:Container(margin:EdgeInsets.all(0.1*size.width),height:0.12 * size.height,
          width:0.12 * size.width,
          decoration: BoxDecoration(
            color:Colors.blue, shape: BoxShape.circle,),),),
          Positioned(right: 0.11* size.width,top: 0.25* size.height,child:
          playerDeck(index:widget.index)),
          Positioned(right: 0.11* size.width,top: 0.16* size.height,
              child: Text("Player No.2",style: GoogleFonts.galindo( fontSize:14,color: Colors.white,),)),
          Positioned(bottom:size.height*0.15,left:size.width*0.23,child: currentCard(index: widget.index))]);
    }

    else{//Player number 2
      return Stack(children: [
        Positioned(child:Container(margin:EdgeInsets.all(0.1*size.width),height:0.12 * size.height,
          width:0.12 * size.width,
          decoration: BoxDecoration(
            color:Colors.blue, shape: BoxShape.circle,),),),
        Positioned(left: 0.12* size.width,top: 0.25* size.height,child:
        playerDeck(index:widget.index)),
        Positioned(right: 0.11* size.width,top: 0.16* size.height,
            child: Text("Player No.3",style: TextStyle(fontSize: 20,color: Colors.white),)),
        Positioned(bottom:size.height*0.17,right:size.width*0.23,child: currentCard(index: widget.index))]);
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

}
//Container(height:20,width: 60,color: Colors.green,),
