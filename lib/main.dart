import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:grabit/Classes/player.dart';
import 'package:grabit/Classes/gameTable.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<gameHandler>(
          create: (_) => gameHandler(3),
        )
      ],
      child:MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        debugShowCheckedModeBanner: false,

        home: gameTable()//OrientationBuilder(builder: (context, orientation) =>buildTable(),),
    ),);
  }
}

class gameHandler with ChangeNotifier {
  final numPlayers;
  int turn = 0;
  var totemCards = [];//handles the cards under the totem
  var cardsHandler = [];//manage the cards state of each player
  var cardsGroups = [1,1,2,2,3];//define all the cards group
  gameHandler(this.numPlayers) {//this.hiddenCards,
    turn = 0;
    //initialize all the game cards and shuffle them
    var cardsArr = List.filled(10, 1) + List.filled(10, 2) + List.filled(10, 3) + List.filled(10, 4);
    cardsArr.shuffle();
    //the initial amount of cards each player should get
    int cards = (78 / numPlayers).toInt();
    //the remaining cards are gonna be under the totem
    //int remainder = (10 % numPlayers) as int;
    int start = 0;
    for(int i = 0; i < numPlayers; i++){
      start += 1;
      cardsHandler.add([cardsArr.sublist(start,start + cards),[]]);
    }
  }

  void updatePlayerStatus() {
    cardsHandler[turn][1].insert(0,cardsHandler[turn][0].removeAt(0));
    turn = (turn + 1) % 3;
    notifyListeners();
  }

  void pastTotemUpdate(){
    var splits = [];
    print("before");
    print(cardsHandler);
    for(int i = 0; i < numPlayers; i++){
      if (i == turn || cardsHandler[i][1] == []) continue;
      print("i is  ");
      print(i);

      if (cardsGroups[cardsHandler[turn][1][0]] == cardsGroups[cardsHandler[i][1][0]]){
        splits.add(i);
      }
    }
    print("splits");
    print(splits);
    if(splits.length == 0){
      print("penalty!!!");
    }
    else {
      splits.shuffle();
      int counter = 0;
      int factor = ((cardsHandler[turn][1].length) / splits.length).toInt();
      var temp = cardsHandler[turn][1].map((s) => s as dynamic).toList();
      for (int i = 0; i < splits.length; i++) {
        counter += factor;
        var temp2 = cardsHandler[splits[i]][0].map((s) => s as dynamic).toList();
        var temp1 = temp.sublist(i * factor, (i * factor) + factor);
        var res = temp2 + temp1;
        cardsHandler[splits[i]][0] = res.map((s) => s as int).toList();
        }
      int index = 0;
       while (counter < cardsHandler[turn][1].length) {
         var temp2 = cardsHandler[splits[index]][0].map((s) => s as dynamic).toList();
         var temp1 = temp.sublist(counter,counter);
         print(temp1);
         var res = temp2 + temp1;
         cardsHandler[splits[index]][0] = res.map((s) => s as int).toList();
         index = (index + 1) % splits.length;
         counter += 1;
       }
      cardsHandler[turn][1] = [];
    }
    print("after");
    print(cardsHandler);
    notifyListeners();
  }
}




