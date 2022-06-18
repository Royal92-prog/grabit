import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grabit/services/Login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/googleAuthentication.dart';
import '../services/google_sign_in_button.dart';



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
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  bool validateCredentials(){
    _isFirstEntered = false;
    _usernameController.text.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_usernameController.text) ? _isValidUsername = false : _isValidUsername = true;
    _passwordController.text.isEmpty ? _isValidPassword = false : _isValidPassword = true;

    _nicknameController.text.isEmpty ? _isValidNickname = false : _isValidNickname = true;
    print(_isValidUsername && _isValidPassword && _isValidNickname);
    return _isValidUsername && _isValidPassword && _isValidNickname;
  }

  Widget createTextField(size, height,width, controller,String hintString,_validate ){
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
              style: _validate ? null : TextStyle(color: Colors.red,fontSize: 15) ,

              maxLength: 20,
              controller: controller,
              decoration: InputDecoration(

                hintText: "Enter " + hintString,
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

    Future<bool> login(email,password) async {
      try{
        await Login.instance().signUp(email, password);
        return true;
      }
      on FirebaseAuthException catch (e){
        print(e.toString());
        if (e.code == 'weak-password') {

        }else if ( e.code == 'email-already-in-use') {


        } else if (e.code == 'operation-not-allowed') {

        } else if (e.code == 'weak-password') {

        } else {

        }
      }
      return false;
    }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    var size = MediaQuery.of(context).size;
    return Stack(fit: StackFit.loose, children:

    [Container(child: Image.asset('assets/Background.png', width: size.width, height: size.height,),),
     Positioned(top: 0.20 * size.height,left: 0.28 * size.width, child:SvgPicture.asset('assets/WoodenTable.svg',
     height: 0.62 * size.height,width: 0.25 * size.width ,fit: BoxFit.fitWidth)),
     Positioned(left: size.width * 0.4, top: size.height * 0.66, child: Container(width: 0.2 * size.width,
     height: 0.25 * size.height, child:
      GestureDetector(
        child:Image.asset('assets/Register_BTN.png',width: 0.2 * size.width, height: 0.25 * size.height),
          onTap: () {
            setState(()  {
              if (validateCredentials() == false){
                print("i am error ! ");
                return;
              }
              else{
                  login(_usernameController.text,_passwordController.text);
                  if(Login.instance().user!=null) {
                    ///use Return Navigation
                  }

    }
            }
            );
        }
      ))),
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
     Positioned(left: size.width * 0.35, top: size.height * 0.2, child:
      Row(children:
      [Text("Sign In",style: GoogleFonts.galindo( fontSize:14,color: Colors.white,)),
      SizedBox(width: size.width * 0.1,),
      Text("Register",style: GoogleFonts.galindo( fontSize:14,color: Colors.white,))
      ]),),
      Positioned(left: size.width * 0.46, top: size.height * 0.25, child: Container(
          width: 0.07 * size.width,
          height: 0.12 * size.height, child:
          GestureDetector(
              child:Image.asset('assets/Google_BTN.png',width: 0.2 * size.width, height: 0.25 * size.height),
              onTap: (){
                  print("got here to sign in button");
                  FutureBuilder(
                    future: Authentication.initializeFirebase(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error initializing Firebase');
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        return GoogleSignInButton();
                      }
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                          //CustomColors.firebaseOrange,
                        ),
                      );
                    }
                  );



              },
            ))),
          createTextField(size,0.367,0.38,_usernameController,'Email',_isValidUsername),
          createTextField(size,0.455,0.38,_passwordController,'Password',_isValidPassword),
          createTextField(size,0.555,0.38,_nicknameController,'Nickname',_isValidNickname),








    ]
    );
  }

}
