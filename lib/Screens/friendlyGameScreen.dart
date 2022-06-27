import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/Screens/privateGameWaitingRoom.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'package:tuple_dart/tuple.dart';

import 'gameHostScreen.dart';
import 'hostGamePopUp.dart';


class FriendlyGame extends StatefulWidget {
  //FriendlyGame({required this.playersNumber});
  @override
  State<FriendlyGame> createState() => FriendlyGameStates();

}
class FriendlyGameStates extends State<FriendlyGame>{
  int playersNumber = 3;
  int gameTimeLimit = 0;
  int gameIp = -1;
  bool hostScreen = false;
  late int _playerIndex;
  final _gameRoomController = TextEditingController();
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return Scaffold(resizeToAvoidBottomInset: false, backgroundColor: Colors.black, extendBody: true, body:
      Stack(fit: StackFit.passthrough, children:
    [Container(child: Image.asset('assets/Background.png', width: size.width, height: size.height,),),
      Positioned(top: 0.20 * size.height,left: 0.28 * size.width, child: SvgPicture.asset('assets/WoodenTable.svg',
          height: 0.62 * size.height,width: 0.25 * size.width ,fit: BoxFit.fitWidth)),
      Positioned(left: size.width * 0.35 , top: size.height * 0.29, child:
      Text('PLAY WITH A FRIEND!',style: GoogleFonts.galindo( fontSize: 20, color: Colors.white,
          fontWeight:FontWeight.w400, decoration: TextDecoration.none))
        //SvgPicture.asset('assets/HostGame/mainHeader.svg',width: 0.2 * size.width, height: 0.07 * size.height)
      ),
      Positioned(left: size.width * 0.36 , top: size.height * 0.39, child:
      SvgPicture.asset('assets/HostGame/writingArea.svg', height: 0.15 * size.height,
          width: 0.15 * size.width)),
    Positioned(left: size.width * 0.42 , top: size.height * 0.43, child:
    SizedBox(
    width: 0.12 * size.width,
    height: 0.12 * size.height,
    child: TextField(
      controller: _gameRoomController,
      maxLength: 6,
      showCursor: false,
      decoration: const InputDecoration(border: InputBorder.none,hintText: 'ROOM ID',),))),
      Positioned(left: size.width * 0.545 , top: size.height * 0.44, child:
      Text('${playersNumber}', style: GoogleFonts.galindo( fontSize: 15, color: Colors.black,
          fontWeight:FontWeight.w300, decoration: TextDecoration.none))
      ),
      Positioned(
        left: size.width * 0.53 ,
        top: size.height * 0.4,
        child: GestureDetector(child:
          Image.asset('assets/HostGame/join.png',
            width: 0.15 * size.width,
            height: 0.1 * size.height),
        onTap:(() async {
          print("Room numbere is :: ");
          print(int.parse(_gameRoomController.text.toString()));
          int gameNum = int.parse(_gameRoomController.text.toString());
          print(gameNum);
          await FirebaseFirestore.instance.collection('privateGame').
          doc('game${gameNum}players').get().then((snapshot) async {
            if (snapshot.exists) {
              final data = snapshot.data();
              if (data != null) {
                int playersNumber = data['playersNumber'];
                _playerIndex = data['connectedPlayersNum'];//data['currentNum'];
                await FirebaseFirestore.instance.collection('privateGame').
                doc('game${gameNum}players').set({
                  'connectedPlayersNum' : data['connectedPlayersNum'] +1 ,},
                   SetOptions(merge: true));
                Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (context) {
                      return PrivateGameWaitingRoom(
                          gameNum : gameNum,
                          playerIndex: _playerIndex,
                          playersNumber: playersNumber);
                    }));
              }
            }
          });}),
        )),
      Positioned(left: size.width * 0.53 , top: size.height * 0.53, child:
      GestureDetector(child: Image.asset('assets/HostGame/host.png', width: 0.15 * size.width,
          height: 0.1 * size.height),
          onTap: () async{
            Navigator.of(context).push(MaterialPageRoute<void> (builder: (context) {
              return GameHost();
            }));
          })),
      Positioned(left: size.width * 0.38 , top: size.height * 0.55, child:
      Text('HOST A MATCH AND ASK \n YOUR FRIENDS TO JOIN', style: GoogleFonts.galindo( fontSize: 8,
          color: Colors.white, fontWeight:FontWeight.w300, decoration: TextDecoration.none))),
      Positioned(left: size.width * 0.05 , bottom: size.height * 0.05, child:
      GestureDetector(child:  Image.asset('assets/HostGame/back.png', height: 0.2 * size.height,
          width: 0.25 * size.width),onTap: (){ Navigator.of(context).pop(); }
      )),

      ]));
  }

}






