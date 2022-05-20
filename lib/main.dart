import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:grabit/Classes/player.dart';
import 'package:grabit/Classes/gameTable.dart';
import 'package:grabit/Classes/card.dart';
import 'package:provider/provider.dart';

import 'Screens/entryScreen.dart';
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

        home: entryScreen()//gameTable()
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
      cardsGroupArray[((cardsHandler[turn][1][0])-1)~/4]-=1; // remove card number from array
    }
    cardsHandler[turn][1].insert(0,cardsHandler[turn][0].removeAt(0));
    ///TODO add check for unique cards
    cardsGroupArray[((cardsHandler[turn][1][0])-1)~/4]+=1; // add new front number to array
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







/*
class cardsHandler with ChangeNotifier {
  var openCards = [];//'royal@gmail.com'
  var hiddenCards = [];
  cardsHandler(this.hiddenCards);
  void updatePlayerStatus() {
    openCards.insert(0,hiddenCards.removeAt(0));
    notifyListeners();
  }
}
*/



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
