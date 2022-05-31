import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grabit/services/playerManager.dart';
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
  int _playerIndex = -1;

  @override
  Widget build(BuildContext context) {
    setConnectedNum(_connectedNum);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('game').doc('game1').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data;
            if (data != null) {
              _connectedNum = data['connectedPlayersNum'];
            }
          }
          if (_connectedNum == 3) {
            _gameState = GameState.activeGame;
          }
          if (_gameState == GameState.waitingForPlayers) {
            if (_playerIndex == -1) {
              // ++_connectedNum;
              // setConnectedNum(_connectedNum);
              _playerIndex = _connectedNum;
            }
            return entryScreen(numPlayers: 3);
          }
          else {
            return gameTable(playerIndex: _playerIndex,);
          }
        }
    );
  }
}
