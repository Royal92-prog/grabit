import 'package:flutter/cupertino.dart';
import 'package:grabit/Classes/Player.dart';

enum EMainGameNumberOfPlayers  {THREE,FOUR,FIVE} /// TODO in sprint 2


class MainGameScreen extends StatefulWidget {
  const MainGameScreen({Key? key}) : super(key: key);


  @override
  State<MainGameScreen> createState() => MainGameScreenState();

}

class MainGameScreenState extends State<MainGameScreen>{
  var mainGamePlayersList = [];
  late EMainGameNumberOfPlayers mainGameNumberOfPlayers ;
  var mainGameOpenCards;
  var mainGameIsColorActivated = 0;
  var mainGameCurrentTurn; /// Todo implement if user with current turn quits
  var mainGameUnderTotemCards;
  


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
