import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grabit/Screens/waitingRoomScreen.dart';
import 'package:grabit/services/gameNumberManager.dart';
import 'package:grabit/services/playerManager.dart';
import '../Screens/entryScreen.dart';
import 'card.dart';
import 'gameTable.dart';

enum GameState { waitingForPlayers, activeGame, endGame }


class GameManager extends StatelessWidget {
  GameManager({required this.playerIndex, required this.playersNum, required this.gameNum});
  int playerIndex;
  int playersNum;
  GameState _gameState = GameState.waitingForPlayers;
  int _connectedNum = 0;
  int winnerIndex = -1;
  int gameNum;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('game').doc('players${gameNum}').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          var nicknames;
          if (snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data;
            if (data != null) {
              _connectedNum = data['connectedPlayersNum'];
              nicknames = [data['player_0_nickname'], data['player_1_nickname'], data['player_2_nickname']];
            }
          }
          if (_gameState == GameState.waitingForPlayers && _connectedNum == 3) {
            _gameState = GameState.activeGame;
            increaseGameNum(gameNum);
          }

          if (_gameState == GameState.waitingForPlayers) {
            return WaitingRoom(connectedNum: _connectedNum,);
          }
          else {
            return GameTable(playerIndex: playerIndex, nicknames: nicknames, gameNum: gameNum, playersNumber: playersNum,);
          }
        }
    );
  }

}

