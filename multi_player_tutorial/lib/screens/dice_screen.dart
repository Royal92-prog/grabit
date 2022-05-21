import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_player_tutorial/services/firestore_manager.dart';

class Dice extends StatefulWidget {
  const Dice({Key? key}) : super(key: key);

  @override
  _DiceState createState() => _DiceState();
}

class _DiceState extends State<Dice> {
// Initialize the dice to 1 //
  int playerOne = 1;
  int playerTwo = 1;
  String result = "";
// Function to roll the dice and decide the winner//
  void rollDice1() {
    setState(() {
      // Randomise the dice //
      playerOne = Random().nextInt(6) + 1;
      // Check which player won //
      setDiceData(1, playerOne);
      updateWinner();
    });
  }

  void rollDice2() {
    setState(() {
      // Randomise the dice //
      playerTwo = Random().nextInt(6) + 1;
      // Check which player won //
      setDiceData(2, playerTwo);
      updateWinner();
    });
  }

  void updateWinner() {
    if (playerOne > playerTwo) {
      result = "Player 1 Wins";
    } else if (playerTwo > playerOne) {
      result = "Player 2 Wins";
    } else {
      result = "Draw";
    }
  }

  @override
  Widget build(BuildContext context) {
      return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('diceGame').doc('dice').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data;
              if (data != null) {
                playerOne = data['die1'];
                playerTwo = data['die2'];
              }
            }
            updateWinner();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        MaterialButton(
                          child: Image.asset('images/dice$playerOne.png',
                              height: 150, width: 150),
                          onPressed: () {
                            rollDice1();
                          },
                        ),
                        const Text(
                          "Player 1",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        MaterialButton(
                          child: Image.asset(
                            'images/dice$playerTwo.png',
                            height: 150,
                            width: 150,
                          ),
                          onPressed: () {
                            rollDice2();
                          },
                        ),
                        const Text(
                          "Player 2",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                // To create space between dice and result //
                const SizedBox(
                  height: 20,
                ),
                Text(
                  result,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            );
          }
      );
    }
  }