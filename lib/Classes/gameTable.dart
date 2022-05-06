import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit/Classes/Player.dart';
class gameTable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    //Container(color : Colors.green),
    return Center(child : SizedBox(height:0.8 * size.height,width:0.75 * size.width,
      child: Stack(children: <Widget>[Center(child:SvgPicture.asset('assets/WoodenTable.svg',height: 0.65 * size.height,width:0.75 * size.width ,alignment: Alignment.centerRight))
    ,//height: 320,fit: BoxFit.fitHeight
      Player()
        ])));
  }
}
//Positioned(top: -1*size.height * 0.001,left:size.width*0.347,child:)
//Positioned(child:)wh
/*Widget buildTable(){
  return Stack(children: <Widget>[
  Container(color : Colors.green),Center(child:
  SvgPicture.asset('assets/WoodenTable.svg',fit: BoxFit.scaleDown,),)
  ],);


}*/
/*
*
*
*
*
* */