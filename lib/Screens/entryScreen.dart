import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grabit/Classes/gameTable.dart';
import 'package:grabit/Classes/player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:grabit/Screens/infoScreen.dart';
import 'package:grabit/Screens/registrationScreen.dart';
import 'package:grabit/services/gameNumberManager.dart';
import 'package:grabit/services/playerManager.dart';
import 'package:tuple/tuple.dart';

import '../Classes/card.dart';
import '../Classes/gameManager.dart';
import '../main.dart';
import '../services/Login.dart';
import 'friendlyGameScreen.dart';
import 'loadingScreen.dart';

class entryScreen extends StatefulWidget {
  entryScreen({required this.numPlayers}); //super(key: key)
  int numPlayers;
  @override
  State<entryScreen> createState() => entryScreenState();

}

class entryScreenState extends State<entryScreen>{
  bool isLoginMode = false;
  bool instructionsMode = false;
  final _nicknameController = TextEditingController();
  int _connectedPlayersNum = 0;
  int _playerIndex = 0;
  late var cardsArr;
  late var _gameNum;

  @override
  void initState() {
    super.initState();
  }

  @mustCallSuper
  @protected
  void dispose() async{
    print("entry Line 42");
    await Login.instance().signOut();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentGameNum();
    var size = MediaQuery.of(context).size;

    return Stack(fit: StackFit.passthrough, children:
      [
        Container(child:
          Image.asset('assets/Background.png',
            width: size.width,
            height: size.height,),),
    Positioned(
          top: size.height * 0.05,
          left: size.width * 0.31,
          child: Container(
            width: size.width * 0.39,
            height: size.height * 0.32,
            child: Image.asset('assets/Lobby/writingArea.png',
              width: 0.2 * size.width,
              height: 0.35 * size.height),)),
        Positioned(
          top: 0.11 * size.height,
          left: 0.305 * size.width,
          child: isLoginMode == false ?
            Image.asset('assets/Lobby/Avatar_photo.png',
              width: 0.15 * size.width,
              height: 0.15 * size.height) : SizedBox()),
        Positioned(
          top: 0.18 * size.height,
          left: 0.3 * size.width,
          child: GestureDetector(
              child: isLoginMode == true ? Image.asset('assets/Lobby/+ BTN.png',
                width: 0.125 * size.width,
                height: 0.125 * size.height) : SizedBox())),
        isLoginMode == true ? Positioned(
          top: size.height * 0.21,
          left: size.width * 0.435,
          child: GestureDetector(
            child: Image.asset('assets/Lobby/Signout_BTN.png',
                width: 0.15 * size.width,
                height: 0.15 * size.height),
            onTap: () async {
              var res = await Navigator.of(context).push(
                  MaterialPageRoute<Tuple3>(
                      builder: (context) {
                        return RegistrationScreen();
                      }));
              setState(() {
                isLoginMode = res?.item1; });
            },),) :
        Positioned(
          top: size.height * 0.21,
          left: size.width * 0.435,
          child: GestureDetector(
              child: Image.asset('assets/Lobby/SignIn_BTN.png',
              width: 0.15 * size.width,
              height: 0.15 * size.height),
            onTap: () async {
              var res = await Navigator.of(context).push(
              MaterialPageRoute<Tuple3>(
                builder: (context) {
                  return RegistrationScreen();
                }));
              setState(() {
                isLoginMode = res?.item1; });
            },),),
        Positioned(
          left: size.width * 0.07,
          top: size.height * 0.65,
          child: GestureDetector(
            child: Image.asset('assets/Lobby/Info_BTN.png',
              height: 0.14 * size.height,
              width: 0.14 * size.width),
            onTap: () => setState(() { instructionsMode = true; }),)),
        Positioned(
          left: size.width * 0.13,
          bottom: size.height * 0.09,
          child: GestureDetector(
            child: Image.asset('assets/Lobby/FriendlyBattle_BTN.png',
              width: 0.2 * size.width,
              height: 0.12 * size.height),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void> (builder: (context) {
              return FriendlyGame();
            }));})),
        Positioned(
          top: size.height * 0.145,
          left: size.width * 0.425,
          child: SizedBox(
              width: 0.235 * size.width,
              height: 0.1 * size.height,
              child: TextField(
                controller: _nicknameController,
                showCursor: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'YOUR NICKNAME',),))),
        Positioned(
          bottom: size.height * 0.04,
          left: size.width * 0.39,
          child: Container(
            width: size.width * 0.25,
            height: size.height * 0.25,
            child: GestureDetector(
              child: Image.asset('assets/playButton.png',
                width: 0.2 * size.width,
                height: 0.25 * size.height),
              onTap: () async{
                FirebaseFirestore _firestore = FirebaseFirestore.instance;
                _connectedPlayersNum = await getConnectedNum(_gameNum);
                _playerIndex = _connectedPlayersNum;
                ++_connectedPlayersNum;
                Map<String,dynamic> dataUpload = {};
                if (_connectedPlayersNum == 1) {
                  initializePlayers(_gameNum);
                  cardsArr = [for(int i = 1; i <= (numberOfRegularCards+((numberOfUniqueCards)*numberOfUniqueCardsRepeats)); i++) i];
                  cardsArr.shuffle();
                  dataUpload['cardsData'] = cardsArr;
                  ///ADDED here - will be initialized only by player 1
                  dataUpload['underTotemCards'] = [];
                  dataUpload['totem'] = false;
                  for(int i = 0; i < widget.numPlayers; i++ ){
                    dataUpload['totem${i}Pressed'] = false;
                  };
                  dataUpload['turn'] = 0;
                  dataUpload['matchingCards'] = [for(int i = 0; i < (numberOfRegularCards~/4); i++) 0];
                  dataUpload['matchingColorCards'] = [0,0,0,0];
                  dataUpload['cardsActiveUniqueArray'] = [for(int i = 0; i < (numberOfUniqueCards + 1); i++) 0];
                }
                else {
                  await _firestore.collection('game').doc('game${_gameNum}').get().then(
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
                int totalCardsNum = cardsArr.length;//(numberOfRegularCards + ((numberOfUniqueCards)*numberOfUniqueCardsRepeats))
                int cards = (totalCardsNum / widget.numPlayers).toInt();
                int remainder = _playerIndex + 1 > (totalCardsNum) % widget.numPlayers ? 0 :
                  (totalCardsNum) % widget.numPlayers - _playerIndex;
                //var cardsHandler = [];
                //cardsHandler.add([cardsArr.sublist(cards*i,(cards*(i+1))),[]]);
                ///TO DO :  all shared variables hould be initialized only once at firebase
                /*
                dataUpload['underTotemCards'] = [];
                dataUpload['totem'] = false;
                dataUpload['totem0Pressed'] = false;
                dataUpload['totem1Pressed'] = false;
                dataUpload['totem2Pressed'] = false;
                dataUpload['turn'] = 0;
                dataUpload['matchingCards'] = [for(int i = 0; i < (numberOfRegularCards~/4); i++) 0]; /// zero list of zeros ///
                dataUpload['matchingColorCards'] = [0,0,0,0];
                dataUpload['cardsActiveUniqueArray'] = [for(int i = 0; i < (numberOfUniqueCards + 1); i++) 0];*/
                if (remainder > 0){
                  dataUpload['player_${_playerIndex.toString()}_deck'] =
                      cardsArr.sublist(cards*(_playerIndex), (cards * (_playerIndex + 1))) +
                      cardsArr.sublist(totalCardsNum - remainder, totalCardsNum - remainder + 1);
                }
                else{
                  dataUpload['player_${_playerIndex.toString()}_deck'] =
                    cardsArr.sublist(cards*(_playerIndex), (cards * (_playerIndex + 1)));
                }
                dataUpload['player_${(_playerIndex).toString()}_openCards'] = [];
                // dataUpload['player_${_playerIndex.toString()}_nickname'] = _nicknameController.text;
                await _firestore.collection('game').doc('game${_gameNum}').set(dataUpload, SetOptions(merge : true));
                setConnectedNum(_connectedPlayersNum, _gameNum);
                updateNicknameByIndex(_playerIndex, _nicknameController.text, _gameNum);
                Navigator.of(context).push(
                MaterialPageRoute<void>(
                builder: (context) {
                return GameManager(playerIndex: _playerIndex, playersNum: widget.numPlayers, gameNum: _gameNum,);
                      }
                      ));
              }))),
        instructionsMode == true ? InfoScreen(func: setInstructionMode) : SizedBox()]);
  }
  setInstructionMode(){
    setState (() {
      this.instructionsMode = false;
    });
  }

  void getCurrentGameNum() async {
    _gameNum = await getGameNum();
  }

}


