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
          Text("agfgagaga",
      style:GoogleFonts.galindo(fontSize:16,color: Colors.black87,))]))),
      Positioned(bottom: size.height * 0.04, left: size.width * 0.37,child://18
      Container(
          width:size.width * 0.25,
          height: size.height * 0.25,
          child:GestureDetector(
              child:Image.asset('assets/playButton.png',width: 0.2 * size.width,
          height: 0.25 * size.height),
          onTap: () async{
            //ScaffoldMessenger("dadada");Container(color: Colors.black.withOpacity(0.5),child:  ,height: size.height * 0.1)
            FirebaseFirestore _firestore = FirebaseFirestore.instance;
            var cardsArr = [for(int i = 1; i <= (numberOfRegularCards+((numberOfUniqueCards)*numberOfUniqueCardsRepeats)); i++) i];
            cardsArr.shuffle();
            int cards = ((numberOfRegularCards+((numberOfUniqueCards)*numberOfUniqueCardsRepeats)) / widget.numPlayers).toInt();
            Map<String, dynamic> uploadData = {};
            var cardsHandler = [];
            Map<String,dynamic> dataUpload = {};
            //cardsHandler.add([cardsArr.sublist(cards*i,(cards*(i+1))),[]]);
            dataUpload['totem'] = false;
            ///modification for dead end game examination 
            dataUpload['turn'] = 0;//0
            dataUpload['matchingCards'] = [for(int i = 0; i < (numberOfRegularCards~/4); i++) 0]; /// zero list of zeros ///
            dataUpload['matchingColorCards'] = [0,0,0,0];
            dataUpload['cardsActiveUniqueArray'] = [for(int i = 0; i < (numberOfUniqueCards + 1); i++) 0];
            cardsArr.insert(0, 34);
            cardsArr.insert(0, 77);
            cardsArr.insert(0, 77);
            cardsArr.insert(53, 74);
            cardsArr.insert(54, 74);
            cardsArr.insert(54, 74);
            cardsArr.insert(54, 74);
            for(int i = 0; i < widget.numPlayers; i++){
              dataUpload['player_${i.toString()}_deck'] = cardsArr.sublist(cards*i, (cards*(i+1)) + 3);
              dataUpload['player_${(i).toString()}_openCards'] = [];
            }
            await _firestore.collection('game').doc('game1').set(dataUpload, SetOptions(merge : true));
    Navigator.of(context).push(
    MaterialPageRoute<void>(
    builder: (context) {
    return Scaffold(backgroundColor: Colors.black, extendBody: true, body: gameTable());
          }
          ));})))]);
}}


