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

  @override
  State<InfoScreen> createState() => InfoScreenStates();

}
class InfoScreenStates extends State<InfoScreen>{
  int playersNumber = 3;
  int gameTimeLimit = 0;
  int currentScreen = 0;
  bool showInfo = true;
  List<String> instructionsText = [
    "IN TURN,PLAYERS FLIP OVER \nTHE TOP CARD ON THEIR STACK",
    "EACH ROUND, THE NEW CARD IS FLIPPED ONTO THE PREVIOUS \n "
     "ROUND'S STACK TO CREATE A FACE-UP DISCARDED PILE",
    "NATALI HI HAZUYA","OR png not svg por favor"
    /*"Whenever two players' cards show the same design (ignoring color), "
        "a duel begins. Both players immediately try to be the first to grab "
        "the totem. The successful player wins the duel AND HIS OPEN CARDS ARE ADDED TO THE"
        "LOSING PLAYER'S DECK"*/
  ];
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    var size = MediaQuery.of(context).size;
    return Stack(fit: StackFit.passthrough, children:
    [
      Stack(fit: StackFit.passthrough, children: [Container(child: Image.asset('assets/Background.png',
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
        ,showInfo == true ? Container(color: Colors.black.withOpacity(0.5),
        width: size.width, height: size.height,
        child: Stack(fit: StackFit.passthrough,children: [Positioned(left: size.width * 0.32, top: size.height * 0.21,child: Text('HOW TO PLAY',style:
        GoogleFonts.galindo(fontSize: 36, color: Colors.white, fontWeight:
        FontWeight.w600, decoration: TextDecoration.none))), Positioned(left: size.width * 0.23, top: size.height * 0.45,
        child: Text(instructionsText[currentScreen],style:
        GoogleFonts.galindo(fontSize: 24, color: Colors.white, fontWeight:
        FontWeight.w500, decoration: TextDecoration.none))),
          currentScreen > 0 ? Positioned(left: size.width * 0.09, top: size.height * 0.7 ,child:
          GestureDetector(child: Image.asset('assets/How to play/back.png', height: 0.2 * size.height,
          width: 0.2 * size.width), onTap: () =>  {
            setState((){
            currentScreen -= 1;
            })},)) : SizedBox(),
          currentScreen < 3 ? Positioned(right: size.width * 0.09, top: size.height * 0.7 ,
          child: GestureDetector(child: Image.asset('assets/How to play/next_BTN.png',
          height: 0.2 * size.height,width: 0.2 * size.width ),onTap: () =>  {
            setState((){
              currentScreen += 1;
            })},)) : SizedBox(),
          Positioned(right: size.width * 0.05, top: size.height * 0.1 ,child:
          GestureDetector(
            onTap: () => {
              setState((){
                showInfo = false;
              })},
          child: Image.asset('assets/How to play/X.png',
                  height: 0.2 * size.height,width: 0.2 * size.width)))
        ],)) : SizedBox(),])
      /*Container(color: Colors.black.withOpacity(0.2), width: size.width,
    height: size.height,)*/

    ]);
  }
}






