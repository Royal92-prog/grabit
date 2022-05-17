import 'package:flutter/cupertino.dart';


class gameManager extends StatefulWidget {
  gameManager({this.numPlayers});
  var numPlayers;
  @override
  State<gameManager> createState() => gameManagerStates();

}

class gameManagerStates extends State<gameManager>{

@override
Widget build(BuildContext context) {return Container();}
}
/*class gameHandler with ChangeNotifier {
  final numPlayers;
  int turn = 1;
  var openCards = [];//'royal@gmail.com'
  var hiddenCards = [];
  var totemCards = [];
  var cardsHandler = [];
  gameHandler(this.hiddenCards,this.numPlayers) {
    var cardsArr = List.filled(10, 1) + List.filled(10, 2) + List.filled(10, 3) + List.filled(10, 4);
    cardsArr.shuffle();
    int cards = (40 / numPlayers) as int;
    int start = 0;
    for(int i = 0; i < numPlayers; i++){
      //var tempCards = cardsArr.sublist(start,start + cards -1);
      start += 1;
    cardsHandler.add([cardsArr.sublist(start,start + cards -1),[]]);
  }
}
  void updatePlayerStatus() {
    openCards.insert(0,hiddenCards.removeAt(0));
    notifyListeners();
  }
}
*/
