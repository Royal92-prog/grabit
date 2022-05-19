
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class totem extends StatefulWidget {
  const totem({Key? key}) : super(key: key);


  @override
  State<totem> createState() => totemState();

}

class totemState extends State<totem>{
  //var cardsGroups = [1,1,2,2,3];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var gameMan = Provider.of<gameHandler>(context);
    return GestureDetector(
      child:Image.asset('assets/CTAButton.png',width: 0.2 * size.width,height: 0.15
          * size.height,
          alignment: Alignment.center),
        onTap: () {
          gameMan.pastTotemUpdate();
        }

    );




  }

}
