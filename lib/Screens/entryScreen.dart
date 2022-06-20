import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/Classes/gameTable.dart';
import 'package:grabit/Classes/player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:grabit/Screens/infoScreen.dart';

import '../Classes/card.dart';

class entryScreen extends StatefulWidget {
  entryScreen({required this.numPlayers}); //super(key: key)
  int numPlayers;
  @override
  State<entryScreen> createState() => entryScreenState();

}

class entryScreenState extends State<entryScreen>{

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    return Stack(fit: StackFit.passthrough, children: [Container(child: Image.asset('assets/Background.png',
      width: size.width, height: size.height,),),Positioned(top: size.height*0.03,
        left: size.width * 0.3, child:Container(child: Image.asset('assets/nickname.png',width: 0.2 * size.width,
            height: 0.35 * size.height),width:size.width * 0.35, height: size.height * 0.35 )),
      Positioned(top: 0.13 * size.height, right:0.585 * size.width,child:
      Container(width:0.15 * size.width,height: 0.15 * size.height,
          decoration: BoxDecoration(
            color:Colors.blue, shape: BoxShape.circle,))),
      Positioned(top: size.height * 0.028, left: size.width * 0.25,child://18
      Container(
          width:size.width * 0.45,
          height: size.height * 0.35,
          child:Row(mainAxisAlignment: MainAxisAlignment.start,children: [SizedBox(width:size.width*0.14),
            Text("agfgagaga", style:GoogleFonts.galindo(fontSize:16,color: Colors.black87,))]))),
    Positioned(left: size.width * 0.07, top: size.height * 0.65,child: GestureDetector(child:
    Image.asset('assets/HostGame/+ btn.png', height: 0.1 * size.height,
        width: 0.1 * size.width))),
      Positioned(left: size.width *0.12, bottom: size.height * -0.04, child:
      Image.asset('assets/Lobby/FriendlyBattle_BTN.png',width: 0.2 * size.width,
          height: 0.35 * size.height)),
      Positioned(bottom: size.height * 0.04, left: size.width * 0.37,child://18
      Container(
          width:size.width * 0.25,
          height: size.height * 0.25,
          child:GestureDetector(
              child:Image.asset('assets/playButton.png',width: 0.2 * size.width,
                  height: 0.25 * size.height),
              onTap: () async{
                FirebaseFirestore _firestore = FirebaseFirestore.instance;
                var cardsArr = [for(int i = 1; i <= (numberOfRegularCards+((numberOfUniqueCards)*numberOfUniqueCardsRepeats)); i++) i];
                cardsArr.shuffle();
                int totalCardsNum = cardsArr.length;//(numberOfRegularCards + ((numberOfUniqueCards)*numberOfUniqueCardsRepeats))
                int cards = (totalCardsNum / widget.numPlayers).toInt();
                int remainder = (totalCardsNum) % widget.numPlayers;
                print("total:: ${totalCardsNum}, rem:: ${remainder}");
                Map<String,dynamic> dataUpload = {};
                dataUpload['totem'] = false;
                ///modification for dead end game examination
                dataUpload['turn'] = 0;//0
                dataUpload['matchingCards'] = [for(int i = 0; i < (numberOfRegularCards~/4); i++) 0]; /// zero list of zeros ///
                dataUpload['matchingColorCards'] = [0,0,0,0];
                dataUpload['underTotemCards'] = [];
                dataUpload['cardsActiveUniqueArray'] = [for(int i = 0; i < (numberOfUniqueCards + 1); i++) 0];
                for(int i = 0; i < widget.numPlayers; i++){
                  if(remainder > 0){
                  dataUpload['player_${i.toString()}_deck'] = cardsArr.sublist(cards*i, (cards*(i+1))) +
                  cardsArr.sublist(totalCardsNum - remainder, totalCardsNum - remainder + 1);
                  remainder--;
                  }
                  else{
                    dataUpload['player_${i.toString()}_deck'] = cardsArr.sublist(cards*i, (cards*(i+1)));
                  }
                  dataUpload['player_${(i).toString()}_openCards'] = [];
                }
                await _firestore.collection('game').doc('game2').set(dataUpload, SetOptions(merge : true));
                Map<String, dynamic> playersMassages = {};
                for(int i = 0; i < widget.numPlayers; i++){
                  playersMassages['Player${i}Msgs'] = "";
                }
                await _firestore.collection('game').doc('game2').set(playersMassages, SetOptions(merge : true));
                Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (context) {
                          return Scaffold(backgroundColor: Colors.black, extendBody: true, body: GameTable(playersNumber: widget.numPlayers));
                        }
                    ));})))]);
  }}
