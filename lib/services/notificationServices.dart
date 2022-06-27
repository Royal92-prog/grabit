import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash/flash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/Classes/card.dart';
import 'package:provider/provider.dart';
import '../main.dart';

import 'package:flutter/material.dart';


void showBasicsFlash({
  Duration? duration,
  required Widget msg,
  flashStyle = FlashBehavior.floating,
  var context,
  var size
}) {
  showFlash(
    context: context,
    duration: duration,
    builder: (context, controller) {
      return Flash(
        controller: controller,
        behavior: FlashBehavior.floating,
        position: FlashPosition.bottom,
        backgroundColor: Colors.black.withOpacity(0.5),
        margin: EdgeInsets.only(
            top: size.height * 0.15,
            right: size.width * 0.1,
            left: size.width * 0.1,
            bottom: size.height * 0.3),
        //boxShadows: kElevationToShadow[4],
        horizontalDismissDirection: HorizontalDismissDirection.horizontal,
        child: msg);/*FlashBar(
          content: Text('This is a basic flash'),
        )*/

    },
  );
}

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
  var context;
  int index;
  int gameNum;
  String collectionType;
  GameNotifications({required this.context, required this.index,
    required this.gameNum, required this.collectionType});


  @override
  Widget build(BuildContext context) {
    return GameUpdatesListener(massageUpdateFunc: showSnackBar,
      index: index,
      gameIndex: gameNum,
      collectionType: collectionType,);
  }

  showSnackBar(var size, String msg, int index, var context) async{
    await FirebaseFirestore.instance.collection(collectionType).
      doc('game${gameNum}MSGS').set({
      'player${index}MSGS' : ""}, SetOptions(merge : true));
    if(msg == 'outerArrows'){
      showBasicsFlash(duration: Duration(milliseconds: 5700), msg : SizedBox(
            width: size.width * 0.75,
            height: size.height * 0.2,
              child : Center(child: DefaultTextStyle(
                style: GoogleFonts.galindo(
                  fontSize: 26,
                  color: '#FFD86C'.toColor(),
                  fontWeight:FontWeight.w300,
                  decoration: TextDecoration.none),
                child: AnimatedTextKit(
                  pause: const Duration(milliseconds: 1000),
                    isRepeatingAnimation: false,
                  animatedTexts: [
                    ScaleAnimatedText(
                      'GET READY',
                      duration: Duration(milliseconds: 1000),
                      textStyle: GoogleFonts.galindo(
                        fontSize: 26,
                        color: '#FFD86C'.toColor(),
                        fontWeight:FontWeight.w300,
                        decoration: TextDecoration.none),),
                    ScaleAnimatedText(
                      '3',
                      duration : Duration(milliseconds: 1000),
                        textStyle: GoogleFonts.galindo(
                            fontSize: 26,
                            color: '#FFD86C'.toColor(),
                            fontWeight:FontWeight.w300,
                            decoration: TextDecoration.none)
                      ),
                    ScaleAnimatedText(
                        '2',
                        duration : Duration(milliseconds: 1000),
                        textStyle: GoogleFonts.galindo(
                            fontSize: 26,
                            color: '#FFD86C'.toColor(),
                            fontWeight:FontWeight.w300,
                            decoration: TextDecoration.none)
                    ),
                    ScaleAnimatedText(
                        '1',
                        duration : Duration(milliseconds: 800),
                        textStyle: GoogleFonts.galindo(
                            fontSize: 26,
                            color: '#FFD86C'.toColor(),
                            fontWeight:FontWeight.w300,
                            decoration: TextDecoration.none)
                    ),
              ],
          totalRepeatCount : 1)))), context : context, size : size);
    }
    else{
      showBasicsFlash(duration: Duration(milliseconds: 2400), msg : SizedBox(
          width: size.width * 0.75,
          height: size.height * 0.2,
          child : Center(child: DefaultTextStyle(
              style: GoogleFonts.galindo(
                  fontSize: 26,
                  color: '#FFD86C'.toColor(),
                  fontWeight:FontWeight.w300,
                  decoration: TextDecoration.none),
              child: AnimatedTextKit(
                pause: Duration(milliseconds: 2400),
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    ScaleAnimatedText(
                        msg,
                        duration : Duration(milliseconds: 2400),
                        textStyle: GoogleFonts.galindo(
                            fontSize: 26,
                            color: '#FFD86C'.toColor(),
                            fontWeight:FontWeight.w300,
                            decoration: TextDecoration.none)
                    ),
                  ],
                  totalRepeatCount : 1)))), context : context, size : size);

    }
  }
}



class GameUpdatesListener extends StatelessWidget {
  GameUpdatesListener({required this.massageUpdateFunc, required this.index,
    required this.gameIndex, required this.collectionType});
  late String msg;
  int gameIndex;
  int index;
  Function massageUpdateFunc;
  String collectionType;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder <DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection(collectionType).
          doc('game${gameIndex}MSGS').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot <DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            //final cloudData = snapshot.data;
            if (snapshot.data != null) {
              Map<String, dynamic> cloudData = (snapshot.data?.data() as Map<String, dynamic>);
              msg = cloudData.containsKey('player${index}MSGS') == true ?
                cloudData['player${index}MSGS'] : "";//Player${index}Msgs
              /// lines 46 to 60 :New condition exit when there is dead end after a certain amount of time//
              if (msg != "") {
                massageUpdateFunc(size, msg, index, context);
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