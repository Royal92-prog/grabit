import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:grabit/Screens/registrationScreen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


import '../services/auth.dart';
import '../services/google_sign_in_button.dart';
import '../services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/Google_BTN.png"),
                height: 150,
                width: 150,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () {
                    signInWithGoogle().whenComplete(() {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ),
                      );
                    });
                  },
                  child: null,),
            ],
          ),
        ),
      ),
    );
  }
}