import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/Classes/card.dart';
import 'package:provider/provider.dart';
import '../main.dart';

import 'package:flutter/material.dart';
extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
class  GameNotifications extends StatelessWidget {
<<<<<<< Updated upstream
  GameNotifications({required this.context, required this.index});
=======
  GameNotifications({required this.context, required this.index,
    required this.gameNum,required this.collectionName});
  var context;
  final String collectionName;
>>>>>>> Stashed changes
  int index;
  var context;
  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return GameUpdatesListener(massageUpdateFunc: showSnackBar, index: index);
  }

  showSnackBar(var size, String msg) async{
    await FirebaseFirestore.instance.collection('game').doc('game2').set({'Player${index}Msgs' : ""}, SetOptions(merge : true));
=======
    return GameUpdatesListener(massageUpdateFunc: showSnackBar, index: index,
      gameIndex: gameNum, collectionName: collectionName);
  }

  showSnackBar(var size, String msg, int index, var context, String collectionName) async{
    await FirebaseFirestore.instance.collection('game').doc('game${gameNum}MSGS').set({
      'player${index}MSGS' : ""}, SetOptions(merge : true));
>>>>>>> Stashed changes
    if(msg == 'outerArrows'){
      await FirebaseFirestore.instance.collection("game").doc("game2").set({'turn' : -10},SetOptions(merge :true));
      await ScaffoldMessenger.of(context).showSnackBar(SnackBar( duration:Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,backgroundColor: Colors.black.withOpacity(0.5),
          margin: EdgeInsets.only(top: size.height * 0.3,right: size.width * 0.25,
              left:size.width * 0.25, bottom: size.height * 0.5) ,
          content:Center(child: Text("Get Ready",style: GoogleFonts.galindo(fontSize: 28,color: '#FFD86C'.toColor())))));
      for(int i = 3 ; i > 0 ; i--) {
        await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1), behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black.withOpacity(0.5), margin: EdgeInsets.only(
            top: size.height * 0.25, right: size.width * 0.25, left: size.width * 0.25,
            bottom: size.height * 0.6), content: Center(child: Text("${i}",style: GoogleFonts.galindo(fontSize: 28,color: '#FFD86C'.toColor())))));
      }
    }
    else{
      await ScaffoldMessenger.of(context).showSnackBar(SnackBar( duration:Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,backgroundColor: Colors.black.withOpacity(0.5),
          margin: EdgeInsets.only(top: size.height * 0.3,right: size.width * 0.1,
              left:size.width * 0.1, bottom: size.height * 0.4) ,
          content:Center(child: Text(msg, style: GoogleFonts.galindo(fontSize: 24,color: '#FFD86C'.toColor())))));
    }

  }
}



class GameUpdatesListener extends StatelessWidget {
<<<<<<< Updated upstream
  GameUpdatesListener({required this.massageUpdateFunc, required this.index});
  String msg = "";
=======
  GameUpdatesListener({required this.massageUpdateFunc, required this.index,
    required this.gameIndex, required this.collectionName});

  late String msg;
  final String collectionName;
  int gameIndex;
>>>>>>> Stashed changes
  int index;
  Function massageUpdateFunc;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
<<<<<<< Updated upstream
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('game').doc('game2').snapshots(),
=======
    return StreamBuilder <DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection(collectionName)
            .doc('game${gameIndex}MSGS').snapshots(),
>>>>>>> Stashed changes
        builder: (BuildContext context,
            AsyncSnapshot <DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final cloudData = snapshot.data;
            if (cloudData != null) {
              msg = cloudData['Player${index}Msgs'];
              /// lines 46 to 60 :New condition exit when there is dead end after a certain amount of time//
              if (msg != "") {
<<<<<<< Updated upstream
                massageUpdateFunc(size, msg);
=======
                massageUpdateFunc(size, msg, index, context, collectionName);
>>>>>>> Stashed changes
              }

            }
          }
          return SizedBox();
        });
  }

}



/*
                for (int i = 0; i < 4; i++) {
                  delayUs(5);
                  print("HERE");
                  animatedWidget = Stack(children: [
                    Center(heightFactor: size.height * 0.1,
                        child: Container(color: Colors.black.withOpacity(0.8),
                          height: 0.25 * size.height,
                          width: size.width * 0.9,)),
                    Positioned(left: 0.4 * size.width,
                      top: size.height * 0.45,
                      child: Text("${i}", style: GoogleFonts. //Your Turn!
                      galindo(fontSize: 34, color: Colors.yellow.shade200,)),)
                  ]);
                }
AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Container(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(scaleDownAnimation.value)
                ..scale(scaleUpAnimation.value),
              child: Opacity(
                  opacity: opacityAnimation.value,
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.purpleAccent,
                            style: BorderStyle.solid,
                            width: 4.0 - (2 * _controller.value))),
                  )),
            ),
          );
        });*/