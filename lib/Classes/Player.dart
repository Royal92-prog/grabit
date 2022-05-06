import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit/Classes/Card.dart';

enum ECardColor      { YELLOW, GREEN, RED, BLUE}




class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);


  @override
  State<Player> createState() => PlayerState();

}

class PlayerState extends State<Player>{

  var playerAvatar;
  var playerUnopenedCards;
  var playerOpenedCards; /// Todo front not included ///
  var playerRemaniningCardsCount;
  var playerCurrentlyOpenedCard; ///Todo use unique identifier for cards Card.cardNumber ///
  var playerHasWon = 0 ;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    print(size.height);
    return Align(child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [Stack(fit: StackFit.passthrough,children:
    [Positioned(right:0.01 * size.width,child:Column(children: [Text("Player No.1",style: TextStyle(fontSize: 10,color: Colors.white)
      ,),Container(height:0.12 * size.height,
      width:0.12 * size.width, decoration: BoxDecoration(
        color:Colors.blue,
        shape: BoxShape.circle,),)],),),Container(width: 0.15 * size.width, height: 0.15 * size.height,
        child:Stack(clipBehavior: Clip.antiAliasWithSaveLayer, fit: StackFit.loose,children:
        [Align(widthFactor:0.2 * size.width, heightFactor: 0.2 * size.height,
            alignment: Alignment.bottomLeft, child:SvgPicture.asset('assets/Full_pack.svg',width: 0.1 * size.width, height: 0.1 * size.height,))
          ,Positioned(right:0.016 * size.width,top:0.017 * size.height,
            child:Text("0",style: TextStyle(fontSize: 16,color: Colors.black)))],
        ) )],),
      SvgPicture.asset('assets/1.svg',width: 0.12 * size.width, height: 0.12 * size.height,
          alignment: Alignment(-1000,-0.5))
    ],
//Positioned(right:5,top:30,child:
//SvgPicture.asset('assets/1.svg',width: 0.12 * size.width, height: 0.12 * size.height,)



    ),
    alignment: Alignment(0,-0.8),);;
  }

}
//Container(height:20,width: 60,color: Colors.green,),
