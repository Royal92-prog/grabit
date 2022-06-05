import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitingRoom extends StatefulWidget {
  @override
  State<WaitingRoom> createState() => WaitingRoomState();
  //_timeElapsed.
 /* @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Text('Waiting room'),
    );*/
  }


class WaitingRoomState extends State<WaitingRoom>{

  ///do not rewmove - important for timer settings
  /*String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    //var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
  //late Stopwatch _stopwatch;
  //late Stopwatch _stopwatch;
  late  Timer _timer;
  late var _stopwatch ;
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    // re-render every 30ms
    _timer = new Timer.periodic(new Duration(milliseconds: 1), (timer) {
      setState(() {});
    });}
*/



 /* @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    //_stopwatch.start();
  }*/

  @override
    Widget build(BuildContext context) {
      var size = MediaQuery.of(context).size;
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
      //Container(color : Colors.green),
      return Scaffold(backgroundColor: Colors.black,extendBody: true,
        body:Stack(children: [Container(child: Image.asset('assets/Background.png',
        width: size.width, height: size.height,),),
        Center(child : SizedBox(height:1 * size.height,width:0.75 * size.width,
        child:Stack(children: <Widget>[Center(child:SvgPicture.asset('assets/WoodenTable.svg',
        height: 0.65 * size.height,width:0.75 * size.width ,alignment: Alignment.centerRight))]))),
        Positioned(top: size.height * 0.3, left: size.width * 0.35, child :
        Text("PREPARING FOR \n   THE BATTLE . . .",
        style: GoogleFonts.galindo( fontSize: 25,color: Colors.white, fontWeight: FontWeight.w800),))]));
    }
}