import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animations/animations.dart';

///first page on tap on the card we are pushing this page and heading to the next one
class test2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        color: Colors.red,
        child:Column(children:[SizedBox(height: 100,), SizedBox(height: 20),GestureDetector(
          child: SvgPicture.asset('assets/Full_pack.svg', width: 100, height: 70,),
          onTap: () async{
            Navigator.of(context).push(new MaterialPageRoute(builder:
                (BuildContext context) => new test1()));
          })]));



  }

}
///2nd page in case x is equal to 3 and is unchanged for 15 secs we are heading back to the previous page
class test1 extends StatefulWidget {
  test1(){
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Map<String, dynamic> data = {'1':[1,2,3,45,56,6,7,4,32,32,3232,323,23,23,23,],
      '2':[1,2,43,5,6,7,3,3,2,23] , '3':[7,3,3,2,23] , '4':[7,3,3] , '5':[7,3] , '6':[]
    ,'totem': 0,'turn': 0};
    //_firestore = FirebaseFirestore.instance;
    _firestore.collection('N1').doc('N2').set(data,SetOptions(merge : false));
   // var cloudWords =   FirebaseFirestore.instance.collection('N1').doc('N2').
    //get().then((querySnapshot) {return querySnapshot.data();});
   // print("printing ${cloudWords}");



  }

  @override
  State<test1> createState() => test1State();

}



class test1State extends State<test1>{
  int x  = 0;

  @override
  void initState() {
    super.initState();
    //navigateHome();
    }

  //navigateHome() {Get.back();}
  var  searchOnStoppedTyping = new Timer(Duration(seconds: 15), () {});
  @override
  Widget build(BuildContext context) {
    print("x is ${x}");
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.green,
      child:Column(children:[SizedBox(height: 100,), SizedBox(height: 20),GestureDetector(
        child: SvgPicture.asset('assets/Full_pack.svg', width: 100, height: 70,),
        onTap: () async{
          setState(() {
            x +=1;
            if(x == 3){
              searchOnStoppedTyping = new Timer(Duration(seconds: 16), () async {
                await Future.delayed(Duration(seconds: 15));
                print("after 15 seconds");
                Navigator.of(context).pop();});
            }
            else{
              print("cancel the timer");
              searchOnStoppedTyping.cancel();
            }
            //searchOnStoppedTyping = new Timer(Duration(seconds: 15), () {Navigator.of(context).pop();});
          });},)]));


  }}

/*
x % 2 == 0 ?
      SnackBar( duration:Duration(seconds: 1),behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black.withOpacity(0.5), margin:
      EdgeInsets.only(top: size.height * 0.25,right: size.width * 0.25,
      left:size.width * 0.25, bottom: size.height * 0.6) ,
      content:Center(child: Text("hfghfhfhfhf"),)) :*/
//docRef.
/*docRef.snapshots().listen(
  (event) => print("current data: ${event.data()}"),
  onError: (error) => print("Listen failed: $error"),
  );*/
//var db = FirebaseFirestore.instance;//.db.collection("N1").doc("N2").onSnapshot;
//db.collection('N1').doc('N2').set(data,SetOptions(merge : false));
/*  final docRef = db.collection("N1").doc("N2");
    docRef.snapshots().listen((event){
            var data = event.data();
            setState(() {
              x = data!['check'];
            });
          } ,
      //onError: (error) => print("Listen failed: $error"),
    );*/