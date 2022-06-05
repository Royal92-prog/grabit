import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:grabit/Classes/player.dart';
import 'package:grabit/Classes/gameTable.dart';
import 'package:grabit/Classes/card.dart';
import 'package:grabit/test1.dart';
import 'package:provider/provider.dart';

import 'Classes/gameManager.dart';
import 'Screens/entryScreen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
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

        home: Scaffold(backgroundColor: Colors.black,extendBody: true, body:entryScreen(numPlayers: 3),),
    ),);
  }
}

class gameHandler with ChangeNotifier {
  //var similar = [[1,2],[3,4]];
  final numPlayers;
  int turn = 0;
  var openCards = [];//'royal@gmail.com'
  var hiddenCards = [];
  var totemCards = [];
  var cardsHandler = [];
  var cardsGroupArray = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  var cardsColorArray = [0,0,0,0];

  gameHandler(this.numPlayers) {//this.hiddenCards,
    turn = 0;
    var cardsArr = [for(var i=1; i<=numberOfRegularCards; i++) i];
    cardsArr.shuffle();
    int cards = (numberOfRegularCards / numPlayers).toInt(); /// add support for more than 3 players


   for(int i = 0; i < numPlayers; i++){
      //var tempCards = cardsArr.sublist(start,start + cards -1);

      cardsHandler.add([cardsArr.sublist(cards*i,(cards*(i+1))),[]]);
    }
  }
  void updatePlayerStatus() {
    if ((cardsHandler[turn][1].length>0)) {

      //var isRegularCard = (((cardsHandler[turn][1][0])-1) < numberOfRegularCards);
      if (((cardsHandler[turn][1][0])-1) < numberOfRegularCards){
        cardsGroupArray[((cardsHandler[turn][1][0])-1)~/4]-=1; // remove card number from array
      }
    }
    cardsHandler[turn][1].insert(0,cardsHandler[turn][0].removeAt(0));
    ///TODO add check for unique cards

    if (((cardsHandler[turn][1][0])-1) < numberOfRegularCards){
      cardsGroupArray[((cardsHandler[turn][1][0])-1)~/4]+=1; // add new front number to array
    }
    print(cardsGroupArray);
    turn= (turn + 1) % 3;
    notifyListeners();
  }

  void pastTotemUpdate() {
    var splits = [];
    var loser ;
    print("before");
    print(cardsHandler);
    if (cardsGroupArray[(((cardsHandler[turn][1][0])-1)~/4 )] > 1) {
    for (int i = 0; i < numPlayers; i++) {
      if (i == turn || cardsHandler[i][1] == []) continue;
      if ((((cardsHandler[i][1][0])-1)~/4 ) == (cardsHandler[turn][1][0]-1)~/4){
        var loserCards = [...cardsHandler[i][1],...cardsHandler[turn][1]];
        loserCards.shuffle();
        cardsHandler[i][0] = [...cardsHandler[i][0],...loserCards];
        cardsHandler[turn][1] = [];
        cardsHandler[i][1] = [];
        turn = i;
        break;
      }
    }
  }
    else{
      print("penalty!!!"); /// ADD take penalty all cards
      return;
    }


    /**
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

     **/

    notifyListeners();
  }
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
            body: Center(
                child: Text(snapshot.error.toString(),
                    textDirection: TextDirection.ltr)));
      }
      if (snapshot.connectionState == ConnectionState.done) {
        return MyApp();
      }
      return Center(child: CircularProgressIndicator());
        },
    );
  }
}
