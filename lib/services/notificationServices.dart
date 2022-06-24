import 'dart:async';
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
  required String msg,
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
            bottom: size.height * 0.4),
        //boxShadows: kElevationToShadow[4],
        horizontalDismissDirection: HorizontalDismissDirection.horizontal,
        child: Center(child:
        Text(msg, style: GoogleFonts.galindo(fontSize: 24,
            color: '#FFD86C'.toColor()))));/*FlashBar(
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
  GameNotifications({required this.context, required this.index, required this.gameNum});
  var context;
  int index;
  int gameNum;
  @override
  Widget build(BuildContext context) {
    return GameUpdatesListener(massageUpdateFunc: showSnackBar, index: index, gameIndex: gameNum,);
  }

  showSnackBar(var size, List <dynamic> msg, int index, var context) async{
    String currentMsg = msg[index];
    print("current MSG ::  ");
    print(currentMsg);
    print(index);
    msg[index] = "";
    await FirebaseFirestore.instance.collection('game').doc('game${gameNum}').set({
      'messages' : msg}, SetOptions(merge : true));
    if(currentMsg == 'outerArrows'){
      /*await FirebaseFirestore.instance.collection("game").doc('game${gameNum}').set({
        'turn' : -10},SetOptions(merge :true));*/
      await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black.withOpacity(0.5),
          margin: EdgeInsets.only(
            top: size.height * 0.3,
            right: size.width * 0.25,
            left: size.width * 0.25,
            bottom: size.height * 0.5),
          content: Center(child:
            Text("Get Ready", style:
              GoogleFonts.galindo(
                  fontSize: 28,
                  color: '#FFD86C'.toColor())))));
      for(int i = 3 ; i > 0 ; i--) {
        await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black.withOpacity(0.5),
            margin: EdgeInsets.only(
              top: size.height * 0.25,
              right: size.width * 0.25,
              left: size.width * 0.25,
              bottom: size.height * 0.6),
            content: Center(child:
              Text("${i}",style:
                GoogleFonts.galindo(
                    fontSize: 28,
                    color: '#FFD86C'.toColor())))));
      }
    }
    else{
      /*await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black.withOpacity(0.5),
          margin: EdgeInsets.only(
            top: size.height * 0.3,
            right: size.width * 0.1,
            left: size.width * 0.1,
            bottom: size.height * 0.4),
          content: Center(child:
            Text(currentMsg, style: GoogleFonts.galindo(fontSize: 24,
              color: '#FFD86C'.toColor())))));*/
      showBasicsFlash(duration: Duration(milliseconds: 2500),msg : currentMsg, context : context, size : size);
    }
  }
}



class GameUpdatesListener extends StatelessWidget {
  GameUpdatesListener({required this.massageUpdateFunc, required this.index, required this.gameIndex});
  late List <dynamic> msg;
  int gameIndex;
  int index;
  Function massageUpdateFunc;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('game').doc('game${gameIndex}').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot <DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final cloudData = snapshot.data;
            msg = [];
            if (cloudData != null) {
              msg = cloudData['messages'];//Player${index}Msgs
              /// lines 46 to 60 :New condition exit when there is dead end after a certain amount of time//
              if (msg[index] != "") {
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