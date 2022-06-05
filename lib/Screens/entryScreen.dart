import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/Classes/gameTable.dart';
import 'package:grabit/Classes/player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:grabit/services/playerManager.dart';

import '../Classes/card.dart';
import '../Classes/gameManager.dart';

class entryScreen extends StatelessWidget {
  entryScreen({required this.numPlayers}); //super(key: key)
  int numPlayers;
  final _nicknameController = TextEditingController();
  int _connectedPlayersNum = 0;
  int _playerIndex = 0;
  late var cardsArr;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    return Stack(fit: StackFit.passthrough, children: [Container(child: Image.asset('assets/Background.png',
      width: size.width, height: size.height,),),Positioned(top: size.height*0.03,
        left: size.width * 0.3, child:Container(child: Image.asset('assets/nickname.png',width: 0.2 * size.width,
            height: 0.35 * size.height),width:size.width * 0.35, height: size.height * 0.35 )),
      Positioned(top: 0.13 * size.height, right:0.585 * size.width,child:
      Container(width:0.15 * size.width,height: 0.15 * size.height,
          decoration: BoxDecoration(
            color:Colors.blue, shape: BoxShape.circle,))),
      Positioned(top: size.height * 0.028, left: size.width * 0.25,child://18
      Container(
          width:size.width * 0.45,
          height: size.height * 0.35,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 108, vertical: 50),
              child: TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter nickname',
                ),
              ),
            ),
          ))
      ),
      Positioned(bottom: size.height * 0.04, left: size.width * 0.37,child://18
      Container(
          width:size.width * 0.25,
          height: size.height * 0.25,
          child:GestureDetector(
              child:Image.asset('assets/playButton.png',width: 0.2 * size.width,
                  height: 0.25 * size.height),
              onTap: () async{
                FirebaseFirestore _firestore = FirebaseFirestore.instance;
                _connectedPlayersNum = await getConnectedNum();
                _playerIndex = _connectedPlayersNum;
                ++_connectedPlayersNum;
                Map<String,dynamic> dataUpload = {};
                if (_connectedPlayersNum == 1) {
                  cardsArr = [for(int i = 1; i <= (numberOfRegularCards+((numberOfUniqueCards)*numberOfUniqueCardsRepeats)); i++) i];
                  cardsArr.shuffle();
                  dataUpload['cardsData'] = cardsArr;
                }
                else {
                  await _firestore.collection('game').doc('game1').get().then(
                          (snapshot) {
                            if (snapshot.exists) {
                              final data = snapshot.data();
                              if (data != null) {
                                cardsArr = data['cardsData'];
                              }
                            }
                            return null;
                          }
                          );
                  print(_connectedPlayersNum);
                }
                int cards = ((numberOfRegularCards+((numberOfUniqueCards)*numberOfUniqueCardsRepeats)) / numPlayers).toInt();
                Map<String, dynamic> uploadData = {};
                var cardsHandler = [];
                //cardsHandler.add([cardsArr.sublist(cards*i,(cards*(i+1))),[]]);
                dataUpload['totem'] = false;
                dataUpload['turn'] = 0;
                dataUpload['matchingCards'] = [for(int i = 0; i < (numberOfRegularCards~/4); i++) 0]; /// zero list of zeros ///
                dataUpload['matchingColorCards'] = [0,0,0,0];
                dataUpload['cardsActiveUniqueArray'] = [for(int i = 0; i < (numberOfUniqueCards + 1); i++) 0];
                dataUpload['player_${_playerIndex.toString()}_deck'] = cardsArr.sublist(cards*(_playerIndex), (cards * (_playerIndex + 1)));
                dataUpload['player_${(_playerIndex).toString()}_openCards'] = [];
                dataUpload['player_${_playerIndex.toString()}_nickname'] = _nicknameController.text;
                await _firestore.collection('game').doc('game1').set(dataUpload, SetOptions(merge : true));
                setConnectedNum(_connectedPlayersNum);
                Navigator.of(context).push(
                MaterialPageRoute<void>(
                builder: (context) {
                return GameManager(playerIndex: _playerIndex, playersNum: numPlayers,);
                      }
                      ));
              })))]);
  }

}



