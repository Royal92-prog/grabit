import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Screens/entryScreen.dart';
import 'card.dart';
import 'gameTable.dart';


class gameManager extends StatefulWidget {
  gameManager({this.numPlayers}){}
  var numPlayers;
  @override
  State<gameManager> createState() => gameManagerStates();

}

class gameManagerStates extends State<gameManager>{



@override
Widget build(BuildContext context) {return entryScreen(numPlayers: 3,);}
}

