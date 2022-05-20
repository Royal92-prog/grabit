import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/Classes/gameTable.dart';
import 'package:grabit/Classes/player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';

class entryScreen extends StatefulWidget {
  const entryScreen({Key? key}) : super(key: key);

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
          onTap: () {
    Navigator.of(context).push(
    MaterialPageRoute<void>(
    builder: (context) {
    return gameTable();
          }
          ));})))]);
}}


