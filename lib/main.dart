import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grabit/Screens/login_page.dart';

import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:grabit/Classes/player.dart';
import 'package:grabit/Classes/gameTable.dart';
import 'package:grabit/Classes/card.dart';
import 'package:grabit/test1.dart';
import 'package:provider/provider.dart';

import 'Classes/gameManager.dart';
import 'Screens/entryScreen.dart';
import 'Screens/registrationScreen.dart';
import 'Screens/waitingRoomScreen.dart';
import 'package:auto_orientation/auto_orientation.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AutoOrientation.landscapeAutoMode(forceSensor: true);
  runApp(App());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        debugShowCheckedModeBanner: false,
        home: RegistrationScreen()

      /*Scaffold(resizeToAvoidBottomInset: false, backgroundColor: Colors.black,extendBody: true,
        body: entryScreen(numPlayers: 3,) ,)*/

      ,);//test2()
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
