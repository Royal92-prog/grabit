import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit/Classes/player.dart';
import 'package:grabit/Classes/totem.dart';

class gameTable extends StatelessWidget {
  gameTable({required this.playerIndex});
  int playerIndex;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    //Container(color : Colors.green),
    return Stack(children: [Container(child: Image.asset('assets/Background.png',
      width: size.width, height: size.height,),),
      Center(child : SizedBox(height:1 * size.height,width:0.75 * size.width,
          child:Stack(children: <Widget>[Center(child:SvgPicture.asset('assets/WoodenTable.svg',
              height: 0.65 * size.height,width:0.75 * size.width ,alignment: Alignment.centerRight))
            ,//Positioned(right: size.width * 0.08,child:Row(children:)[]
            Positioned(left : size.width * 0.22,top:-0.08*size.height,child: Player(index: 1)),
            Positioned(right : size.width * -0.025,top:0.25*size.height,child: Player(index: 3)),
            Positioned(left : size.width * -0.02,top: 0.22*size.height,child: Player(index: 2)),
            Positioned(left : size.width * 0.28,top: 0.7*size.height,child: totem(index: playerIndex))
          ])))


    ]);
        //;

  }
}
/*



 */