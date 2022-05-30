import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grabit/Services/playersManager.dart';
import '../Screens/entryScreen.dart';
import 'card.dart';
import 'gameTable.dart';

enum GameState { waitingForPlayers, activeGame, endGame }


class GameManager extends StatefulWidget {
  const GameManager({Key? key}) : super(key: key);

  @override
  State<GameManager> createState() => _GameManagerState();

}

class _GameManagerState extends State<GameManager>{
  GameState _gameState = GameState.waitingForPlayers;
  int _connectedNum = 0;
  int _playerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('game').doc('game1').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data;
            if (data != null) {
              _connectedNum = data['connectedPlayersNum'];
            }
          }
          if (_playerIndex == 0) {
            _connectedNum++;
            setConnectedNum(_connectedNum);
            _playerIndex = _connectedNum;
          }
          if (_connectedNum == 3) {
            _gameState = GameState.activeGame;
          }
          if (_gameState == GameState.waitingForPlayers) {
            return entryScreen(numPlayers: 3, playerIndex: _playerIndex,);
          }
          else {
            return gameTable(playerIndex: _playerIndex,);
          }
        }
    );
  }
}

