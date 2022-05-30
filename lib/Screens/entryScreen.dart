import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/Classes/gameTable.dart';
import 'package:grabit/Classes/player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';

import '../Classes/card.dart';

class entryScreen extends StatefulWidget {
  entryScreen({required this.numPlayers, required this.playerIndex}); //super(key: key)
  int numPlayers;
  int playerIndex;
  @override
  State<entryScreen> createState() => entryScreenState(playerIndex: playerIndex);

}

class entryScreenState extends State<entryScreen>{
  entryScreenState({required this.playerIndex});
  int playerIndex;
  final _nicknameController = TextEditingController();

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
          decoration: const BoxDecoration(
            color:Colors.blue, shape: BoxShape.circle,))),
      Positioned(top: size.height * 0.028, left: size.width * 0.25,child://18
          Container(
            width:size.width * 0.45,
            height: size.height * 0.35,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 108, vertical: 50),
            child: TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter nickname',
              ),
              ),
            ),
          ))
          ),
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
            int cards = ((numberOfRegularCards+((numberOfUniqueCards)*numberOfUniqueCardsRepeats)) / widget.numPlayers).toInt();
            Map<String, dynamic> uploadData = {};
            var cardsHandler = [];
            Map<String,dynamic> dataUpload = {};
            //cardsHandler.add([cardsArr.sublist(cards*i,(cards*(i+1))),[]]);
            dataUpload['totem'] = false;
            dataUpload['turn'] = 0;
            dataUpload['matchingCards'] = [for(int i = 0; i < (numberOfRegularCards~/4); i++) 0]; /// zero list of zeros ///
            dataUpload['matchingColorCards'] = [0,0,0,0];
            dataUpload['cardsActiveUniqueArray'] = [for(int i = 0; i < (numberOfUniqueCards); i++) 0];
            dataUpload['player_${playerIndex.toString()}_deck'] = cardsArr.sublist(cards*(playerIndex - 1), (cards*playerIndex));
            dataUpload['player_${(playerIndex).toString()}_openCards'] = [];
            dataUpload['player_${playerIndex.toString()}_nickname'] = _nicknameController.text;
            await _firestore.collection('game').doc('game1').set(dataUpload, SetOptions(merge : true));
              })))]);
}}


