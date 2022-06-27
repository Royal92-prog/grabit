import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LicenseDialog extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(children:[Container(child:
    Image.asset('assets/Background.png',
      width: size.width,
      height: size.height,),),
      Positioned(
        bottom: size.height * 0.045,
        left: 0.36 * size.width ,
        child:Image.asset('assets/Lobby/grabitLogo.png',
        width: 0.3 * size.width,
        height: 0.2 * size.height,)),

      Center(child: Container(
            child: AboutDialog(
              applicationName: "GrabIt",
              applicationVersion: "2.0.0")))]);
  }

}

