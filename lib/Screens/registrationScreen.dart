import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  State<RegistrationScreen> createState() => RegistrationScreenState();

}

class RegistrationScreenState extends State<RegistrationScreen>{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    var size = MediaQuery.of(context).size;
    return Stack(fit: StackFit.passthrough, children:
    [Container(child: Image.asset('assets/Background.png', width: size.width, height: size.height,),),
     Positioned(top: 0.20 * size.height,left: 0.28 * size.width, child:SvgPicture.asset('assets/WoodenTable.svg',
     height: 0.62 * size.height,width: 0.25 * size.width ,fit: BoxFit.fitWidth)),
      ///To do: replace playButton with row
     Positioned(left: size.width * 0.4, top: size.height * 0.66, child: Container(width: 0.2 * size.width,
     height: 0.25 * size.height, child:
      GestureDetector(
        child:Image.asset('assets/playButton.png',width: 0.2 * size.width, height: 0.25 * size.height)))),
      ///To do: replace All blank field to a new adjusted pic, create textField
      Positioned(left: 0.33 * size.width, top:0.25 * size.height, child :
        Column(children:
        [SizedBox(height: size.height * 0.11,),
          Image.asset('assets/broadNameField.png',width: size.width * 0.35,height: size.height * 0.09),//,width: size.width * 0.6,height: size.height * 0.09, fit: BoxFit.fill
         //SizedBox(height: size.height * 0.0051,),
          Image.asset('assets/broadNameField.png',width: size.width * 0.35,height: size.height * 0.09),
         SizedBox(height: size.height * 0.01,),
          Image.asset('assets/broadNameField.png',width: size.width * 0.35,height: size.height * 0.09),
        ])),
     Positioned(left: size.width * 0.35, top: size.height * 0.2, child:
      Row(children:
      [Text("SIGN In",style: GoogleFonts.galindo( fontSize:14,color: Colors.white,)),
      SizedBox(width: size.width * 0.1,),
      Text("register",style: GoogleFonts.galindo( fontSize:14,color: Colors.white,))
      ]),),
    ]);
  }

}
