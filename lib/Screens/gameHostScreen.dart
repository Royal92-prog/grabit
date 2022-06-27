import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/Screens/privateGameWaitingRoom.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'package:tuple_dart/tuple.dart';

import 'hostGamePopUp.dart';


class GameHost extends StatefulWidget {
  @override
  State<GameHost> createState() => GameHostStates();

}
class GameHostStates extends State<GameHost>{
  int playersNumber = 3;
  int gameTimeLimit = 0;
  int gameIp = -1;
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      extendBody: true,
      body: Stack(fit: StackFit.passthrough,
        children: [
          Container(child: Image.asset('assets/Background.png',
            width: size.width,
            height: size.height,),),
          Positioned(
            top: 0.20 * size.height,
            left: 0.28 * size.width,
            child: SvgPicture.asset('assets/WoodenTable.svg',
              height: 0.62 * size.height,
              width: 0.25 * size.width ,
              fit: BoxFit.fitWidth)),
          gameIp == -1 ? Positioned(
            left: size.width * 0.4,
            top: size.height * 0.61,
            child: Container(
              width: 0.2 * size.width,
              height: 0.25 * size.height,
            child: GestureDetector(
              child: Image.asset('assets/playButton.png',
                width: 0.2 * size.width,
                height: 0.28 * size.height),
                onTap:() async{
                  await FirebaseFirestore.instance.collection('privateGame').
                    doc('gameNumber').get().then((snapshot) async {
                  if (snapshot.exists) {
                    final data = snapshot.data();
                    if (data != null) {
                    setState(()  {
                      gameIp = data['currentNum'];
                    });
                    await FirebaseFirestore.instance.collection('privateGame').
                    doc('gameNumber').set({'currentNum' : data['currentNum'] +1 ,},
                        SetOptions(merge: true));
                    await FirebaseFirestore.instance.collection('privateGame').
                    doc('game${gameIp}players').set({'connectedPlayersNum' : 0 ,'playersNumber' : playersNumber},
                        SetOptions(merge: true));

                    }
                  }
                });
              },))) : SizedBox(),
          gameIp == -1 ? Positioned(
            left: size.width * 0.35 ,
            top: size.height * 0.26, child:
              Text('PLAY WITH A FRIEND!',
                style: GoogleFonts.galindo(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight:FontWeight.w600,
                  decoration: TextDecoration.none))
          ) : SizedBox(),
          Positioned(
            left: size.width * 0.415 ,
            top: size.height * 0.35,
            child: Text('GAME HOST OPTIONS',
              style: GoogleFonts.galindo(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none))),
          Positioned(
            left: size.width * 0.5 ,
            top: size.height * 0.43,
            child: SvgPicture.asset('assets/HostGame/writingArea.svg',
              height: 0.08 * size.height,
              width: 0.08 * size.width)),//
          Positioned(
            left: size.width * 0.375 ,
            top: size.height * 0.45,
            child: Text('PLAYERS',
              style: GoogleFonts.galindo(
                fontSize: 8,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none))),
          Positioned(
            left: size.width * 0.46 ,
            top: size.height * 0.425,
            child: GestureDetector(
              child: Image.asset('assets/HostGame/+ btn.png',
                height: 0.08 * size.height,
                width: 0.1 * size.width),
              onTap: () => setState(() {
                playersNumber = playersNumber == 3 ? 5 : playersNumber - 1;
              }),)),
          Positioned(
            left: size.width * 0.54 ,
            top: size.height * 0.425,
            child: GestureDetector(
              child: Image.asset('assets/HostGame/+ btn.png',
                height: 0.08 * size.height,
                width: 0.1 * size.width),
              onTap: () => setState(() {
                playersNumber = playersNumber == 5 ? 3 : playersNumber + 1;
              }))),
          Positioned(
            left: size.width * 0.545 ,
            top: size.height * 0.44,
            child: Text('${playersNumber}',
              style: GoogleFonts.galindo(
                fontSize: 15,
                color: Colors.black,
                fontWeight:FontWeight.w300,
                decoration: TextDecoration.none))),
          Positioned(
            left: size.width * 0.375 ,
            top: size.height * 0.55,
            child: Text('TURN TIME LIMIT',
              style: GoogleFonts.galindo(
                fontSize: 8,
                color: Colors.white,
                fontWeight:FontWeight.w500,
                decoration: TextDecoration.none))),
          Positioned(
            left: size.width * 0.49 ,
            top: size.height * 0.54,
            child: SvgPicture.asset('assets/HostGame/writingArea.svg',
              height: 0.06 * size.height,
              width: 0.1 * size.width)),
          Positioned(
            left: size.width * 0.52 ,
            top: size.height * 0.53,
            child: GestureDetector(
              child: Image.asset('assets/HostGame/+ btn.png',
                height: 0.08 * size.height,
                width: 0.1 * size.width),
              onTap: () => setState(() {
                gameTimeLimit = (gameTimeLimit + 1) % 2;
              }),)),
          Positioned(
            left: size.width * 0.52 ,
            top: size.height * 0.55,
            child: gameTimeLimit == 0 ? Text('NO',
              style: GoogleFonts.galindo(
                fontSize: 10,
                color: Colors.black,
                fontWeight:FontWeight.w300,
                decoration: TextDecoration.none)) :
          Text('YES',
            style: GoogleFonts.galindo(
              fontSize: 10,
              color: Colors.black,
              fontWeight:FontWeight.w300,
              decoration: TextDecoration.none))),
          Positioned(
            left: size.width * 0.05 ,
            bottom: size.height * 0.05,
            child: GestureDetector(
              child: Image.asset('assets/HostGame/back.png',
                height: 0.2 * size.height,
                width: 0.25 * size.width),
            onTap: (){
              Navigator.of(context).pop();
            })),
      gameIp != -1 ? IpScreenPopUp(
        updateFunc: resetIP,
        playersNumber: playersNumber,
        gameNum: gameIp,) : SizedBox()]));
  }
  void resetIP(gameNum, _playerIndex){
    setState(() {
      gameIp = -1;
    });
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) {
          return PrivateGameWaitingRoom(
              gameNum : gameNum,
              playerIndex: _playerIndex,
              playersNumber: playersNumber);
        }));
  }
}






