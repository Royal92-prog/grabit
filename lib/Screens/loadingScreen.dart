

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    return Stack(fit: StackFit.passthrough, children: [
      Image.asset('assets/Background.png', width: size.width, height: size.height,),
      Positioned(left: size.width * 0.36, top: 0.5 * size.height ,child:
      Text('GRABIT', style: GoogleFonts.galindo( fontSize: 40,
        color: Colors.white, fontWeight:FontWeight.w600, decoration: TextDecoration.none,))),
      Positioned(left: size.width * 0.41, top: 0.65 * size.height ,child:
      Text('Loading', style: GoogleFonts.galindo( fontSize: 28,
        color: Colors.white, fontWeight:FontWeight.w600, decoration: TextDecoration.none,))),
      Positioned(left: size.width * 0.45, top: 0.63 * size.height ,child:
      CircularProgressIndicator(color: Colors.yellow,strokeWidth : 5.5))
    ]);
  }
}
