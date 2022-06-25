import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'package:tuple_dart/tuple.dart';


class InfoScreen extends StatefulWidget {
  var func;
  InfoScreen({required this.func});

  @override
  State<InfoScreen> createState() => InfoScreenStates();

}
class InfoScreenStates extends State<InfoScreen>{
  int playersNumber = 3;
  int gameTimeLimit = 0;
  int currentScreen = 0;
  bool showInfo = true;
  List<String> instructionsText = [
    "The first player to get rid of all of their cards wins the game!",
    "In turn, players flip over the top card on their stack.\n"
    "Each round, the new card is flipped onto the previous round's\n"
    "stack to create a face-up discard pile. Play proceeds clockwise.",
    "Whenever two players' cards show the same design (NOT COLOR), \na duel begins! Both players immediately try to be the first to grab \nthe totem. The successful player wins the duel.",
    "The loser must then pick up their opponent's discard pile, \ntheir own discard pile, and any cards that may be lying \nin the middle of the table.",
    "After the duel, play continues normally \nbeginning with the loser of the duel. ",
    "There are 3 special cards: \n1) Inside arrows\n2)Outside arrows\n3)Colored arrows",
    "\n1/3 Inside arrows ->  The first to grab the totem wins the round.",
    "\n2/3 Outside arrows -> All players flip the topmost card \nof their stack simultaneously.",
    "\n3/3 Colored arrows -> From now on, duels are no longer triggered \nby matching symbols, but by matching colors. This means \nthat a duel may start immediately, until this card is covered.",
    "Penalties ->  If a player wrongly grabs the totem, \nthey have to take all of the cards that are face-up on the table: \nEach player's discard, but also any cards in the middle of the table.",
    "End of the Game -> When a player has flipped their last card, \nit is left face-up on the top of their discard pile and other players \ncontinue play. A player has not won until \nthey somehow get rid of their discard pile."
  ];
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(fit: StackFit.passthrough, children:
    [
      Stack(fit: StackFit.passthrough, children: [
        /*Container(child: Image.asset('assets/Background.png',
        width: size.width, height: size.height,),),
        Positioned(left: size.width *0.12, bottom: size.height * -0.04, child:
        Image.asset('assets/Lobby/FriendlyBattle_BTN.png',width: 0.2 * size.width,
            height: 0.35 * size.height)),
        Positioned(bottom: size.height * 0.04, left: size.width * 0.37,child://18
        Container(
            width:size.width * 0.25,
            height: size.height * 0.25,
                child: GestureDetector(
                  onTap: () => {print("x is 15")},
                child:Image.asset('assets/playButton.png',width: 0.2 * size.width, height: 0.25 * size.height),)))
        ,showInfo == true ? */Container(color: Colors.black.withOpacity(0.5),
        width: size.width, height: size.height,
        child: Stack(fit: StackFit.passthrough,children: [Positioned(left: size.width * 0.32, top: size.height * 0.21,child: Text('HOW TO PLAY',style:
        GoogleFonts.galindo(fontSize: 36, color: Colors.white, fontWeight:
        FontWeight.w600, decoration: TextDecoration.none))), Positioned(left: size.width * 0.09, top: size.height * 0.40,
        child: Text(instructionsText[currentScreen],style:
        GoogleFonts.galindo(fontSize: 18, color: Colors.white, fontWeight:
        FontWeight.w500, decoration: TextDecoration.none))),
          currentScreen > 0 ? Positioned(left: size.width * 0.09, top: size.height * 0.7 ,child:
          GestureDetector(child: Image.asset('assets/How to play/back.png', height: 0.2 * size.height,
          width: 0.2 * size.width), onTap: () =>  {
            setState((){
            currentScreen -= 1;
            })},)) : SizedBox(),
          currentScreen < instructionsText.length -1 ? Positioned(right: size.width * 0.09, top: size.height * 0.7 ,
          child: GestureDetector(child: Image.asset('assets/How to play/next_BTN.png',
          height: 0.2 * size.height,width: 0.2 * size.width ),onTap: () =>  {
            setState((){
              currentScreen += 1;
            })},)) : SizedBox(),
          Positioned(right: size.width * 0.05, top: size.height * 0.1 ,child:
          GestureDetector(
            onTap: widget.func,
          child: Image.asset('assets/How to play/X.png',
                  height: 0.2 * size.height,width: 0.2 * size.width)))
        ],))])
      /*Container(color: Colors.black.withOpacity(0.2), width: size.width,
    height: size.height,)*/

    ]);
  }
}






