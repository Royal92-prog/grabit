import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grabit/Screens/entryScreen.dart';
import 'package:grabit/services/Login.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tuple/tuple.dart';

import '../services/auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  State<RegistrationScreen> createState() => RegistrationScreenState();

}

class RegistrationScreenState extends State<RegistrationScreen>{

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  bool _isValidUsername = false;
  bool _isValidPassword = false;
  bool _isValidNickname = false;
  bool _isFirstEntered = true;
  bool _isSignedIn = Login.instance().user != null;


  bool validateCredentials(isNicknameRequired){
    _isFirstEntered = false;
    _usernameController.text.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_usernameController.text) ? _isValidUsername = false : _isValidUsername = true;
    _passwordController.text.isEmpty ? _isValidPassword = false : _isValidPassword = true;

    _nicknameController.text.isEmpty && isNicknameRequired ? _isValidNickname = false : _isValidNickname = true;

    return isNicknameRequired ? _isValidUsername && _isValidPassword && _isValidNickname : _isValidUsername && _isValidPassword;
  }

  Widget createTextField(size, height,width, controller,String hintString,_validate,loggedParam,isPasswordEncrypt ){
    return Positioned(top: size.height * height, left: size.width * width,child://18
    Container(
        width:size.width * 0.25,
        height: size.height * 0.08,
        child: Scaffold(
          backgroundColor: Colors.transparent,

          resizeToAvoidBottomInset: false,
          body : Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: isPasswordEncrypt,
              enableSuggestions: !isPasswordEncrypt,
              autocorrect: !isPasswordEncrypt,
              style: _validate ? null : TextStyle(color: Colors.red,fontSize: 15) ,
              readOnly: _isSignedIn,
              maxLength: 25,
              controller: controller,
              decoration: InputDecoration(
                hintText: _isSignedIn ? loggedParam: "Enter " + hintString,
                hintStyle: _isFirstEntered||_validate ? TextStyle(fontSize: 15) : TextStyle(fontSize: 15,color: Colors.red), // you need this
                counterText: "",
                border: InputBorder.none,

                /*
                errorText: _validate ? hintString + 'Can\'t Be Empty' : null,
                errorStyle: TextStyle(height: 0),
                */
              ),
            ),
          ),
        ))
    );
  }

  void signIn(email,password) async {

    await Login.instance().signIn(email.toString().trim(), password.toString().trim());
  }
  void logout() async {
    await Login.instance().signOut();
    signOutGoogle();
    _isSignedIn = false;
  }

    Future<bool> login(email,password) async {
      try{

        await Login.instance().signUp(email.toString().trim(), password.toString().trim());
        if (Login.instance().user != null) {
          _isSignedIn = true;
          return true;
        }
      }
      on FirebaseAuthException catch (e){
        print(e.toString());
        if (e.code == 'weak-password') {

        }else if ( e.code == 'email-already-in-use') {

        } else if (e.code == 'operation-not-allowed') {

        } else if (e.code == 'weak-password') {

        } else {
          return false;
        }
      }
      return false;
    }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return Stack(fit: StackFit.expand, children:
    [
      Container(child: Image.asset('assets/Background.png', width: size.width, height: size.height,),),

     Positioned(top: 0.20 * size.height,left: 0.28 * size.width, child:SvgPicture.asset('assets/WoodenTable.svg',
     height: 0.62 * size.height,width: 0.25 * size.width ,fit: BoxFit.fitWidth)),

    Positioned(top: 0.132* size.height,left: 0.272 * size.width, child: Image.asset('assets/SignInLogo.png',
    height: 0.15 * size.height,width: 0.45 * size.width ,fit: BoxFit.fitWidth)),

     Visibility(child:
     Positioned(left: size.width * 0.4, top: size.height * 0.66, child: Container(width: 0.2 * size.width,
         height: 0.25 * size.height, child:
         GestureDetector(

           /// TODO: add google check if user logged in
             child: Image.asset('assets/logout_BTN.png',width: 0.2 * size.width, height: 0.25 * size.height),
             onTap: () {
               setState(()  {
                  // user is not logged in
                   logout();
                   Navigator.of(context).pop(Tuple3(false,"",""));
                   /*
                   MaterialPageRoute(
                     builder: (context) {
                       return entryScreen(numPlayers: 3);
                     },
                   );
                   */
               }
               );
             }
         ))),
         visible: _isSignedIn,

     ),

      Visibility(child:
      Positioned(left: size.width * 0.49, top: size.height * 0.58, child: Container(width: 0.2 * size.width,
          height: 0.25 * size.height, child:
          GestureDetector(

              child: Image.asset('assets/Register_BTN.png',width: 0.2 * size.width, height: 0.25 * size.height),
              onTap: () async {

                  /// user is not logged in
                    if (validateCredentials(true) == false) {
                      print("--------------- FAIL - Credentials have return Invalid---------------");
                      return;
                    }
                    else {
                      print("---------------Success - Credentials Were successful ---------------");
                      login(_usernameController.text, _passwordController.text);
                      Navigator.pop(context, Tuple3(true,_usernameController.text,_nicknameController.text));
                    }

                }

              }
          ))),
        visible: !_isSignedIn,

      ),


      Visibility(child:
      Positioned(left: size.width * 0.295, top: size.height * 0.58, child: Container(width: 0.2 * size.width,
          height: 0.25 * size.height, child:
          GestureDetector(

              child: Image.asset('assets/SignInButton.png',width: 0.2 * size.width, height: 0.25 * size.height),
              onTap: () async {
                // setState(() {
                  /// user is not logged in
                  if (validateCredentials(false) == false) {
                    return;
                  }
                  else {
                    signIn(_usernameController.text, _passwordController.text);
                    Navigator.of(context).pop(Tuple3(true,_usernameController.text,_nicknameController.text));
                  }
              }
          ))),
        visible: !_isSignedIn,

      ),

      ///To do: replace All blank field to a new adjusted pic, create textField
      Positioned(left: 0.33 * size.width, top:0.25 * size.height, child :
        Column(children:
        [SizedBox(height: size.height * 0.11,),
          Image.asset('assets/broadNameField.png',width: size.width * 0.35,height: size.height * 0.09),//,width: size.width * 0.6,height: size.height * 0.09, fit: BoxFit.fill
         //SizedBox(height: size.height * 0.0051,),
          Image.asset('assets/broadNameField.png',width: size.width * 0.35,height: size.height * 0.09),
         SizedBox(height: size.height * 0.01,),
          Image.asset('assets/broadNameField.png',width: size.width * 0.35,height: size.height * 0.09),
        ])),
     // Positioned(left: size.width * 0.35, top: size.height * 0.2, child:
     //  Row(children:
     //  [Text("Sign In",style: GoogleFonts.galindo( fontSize:14,color: Colors.white,)),
     //  SizedBox(width: size.width * 0.1,),
     //  Text("Register",style: GoogleFonts.galindo( fontSize:14,color: Colors.white,))
     //  ]),),



      Positioned(left: size.width * 0.05 , bottom: size.height * 0.05, child:
      GestureDetector(child:  Image.asset('assets/back.png', height: 0.2 * size.height,
          width: 0.25 * size.width),onTap: (){
              Navigator.of(context).pop(Tuple3(_isSignedIn,_isSignedIn ? _usernameController.text: "", _isSignedIn ? _nicknameController.text: ""));
      }
      )),

      Positioned(left: size.width * 0.46, top: size.height * 0.25, child: Container(
          width: 0.07 * size.width,
          height: 0.12 * size.height, child:
          GestureDetector(
              child:Image.asset('assets/Google_BTN.png',width: 0.2 * size.width, height: 0.25 * size.height),
              onTap: (){
                    Container();

                    signInWithGoogle().whenComplete(() {
                      if ( googleSignIn.currentUser != null){
                        Navigator.pop(context, Tuple3(true,_usernameController.text,_nicknameController.text));
                      }
                      else {
                        print("failed to sign in with google");
                      }
                      /// Todo add check if failed

                      /*
                    Navigator.of(context).push(
                    MaterialPageRoute(
                    builder: (context) {
                    return RegistrationScreen();
                    },
                    ),
                    );

                    */
                    });
              },
            ))),
          createTextField(size,0.367,0.38,_usernameController,'Email',_isValidUsername,Login.instance().user?.email,false),
          createTextField(size,0.455,0.38,_passwordController,'Password',_isValidPassword,"",true),
          createTextField(size,0.555,0.38,_nicknameController,'Nickname',_isValidNickname,"",false),
    ]
    );
  }

}
