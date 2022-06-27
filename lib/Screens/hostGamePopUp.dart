import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/Screens/privateGameWaitingRoom.dart';
import 'package:grabit/Screens/waitingRoomScreen.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'package:tuple_dart/tuple.dart';


class IpScreenPopUp extends StatelessWidget{

  var updateFunc;
  //int gameIp;
  int gameNum;
  int playersNumber;
  late int _playerIndex;

  IpScreenPopUp({required this.updateFunc,
    required this.gameNum, required this.playersNumber });

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(//fit: StackFit.passthrough,
      children:[
        Container(color: Colors.black.withOpacity(0.5),
          width: size.width, height: size.height,
          child: Stack(fit: StackFit.passthrough,
            children:[
              Positioned(
                left: size.width * 0.36,
                top: size.height * 0.26,
                child: Text('Let''s Play!',
                style: GoogleFonts.galindo(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none))),
              Positioned(
                  left: size.width * 0.24,
                  top: size.height * 0.35,
                  child: Text("\n     your game room number is ${gameNum}, \n Share it with your"
                    " friends and let's play!",
                  style:  GoogleFonts.galindo(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none))),
            ],)),
        Positioned(
          bottom: size.height * 0.04,
          left: size.width * 0.39,
          child: GestureDetector(
            onTap: (() async{
              await FirebaseFirestore.instance.collection('privateGame').
                doc('game${gameNum}').get().then((snapshot) async {
                  if (snapshot.exists) {
                    final data = snapshot.data();
                    if (data != null) {
                      _playerIndex = data['connectedPlayersNum'];//data['currentNum'];
                      await FirebaseFirestore.instance.collection('privateGame').
                      doc('game${gameNum}players').set({'connectedPlayersNum' : data['connectedPlayersNum'] +1 ,},
                        SetOptions(merge: true));
                    }
                  }
                });
            updateFunc(gameNum, _playerIndex);

            }),
              child: Image.asset('assets/HostGame/got it_BTN.png',
                      height: 0.2 * size.height,
                      width: 0.2 * size.width)))
      /*Container(color: Colors.black.withOpacity(0.2), width: size.width,
    height: size.height,)*/
//
    ]);
  }
}






