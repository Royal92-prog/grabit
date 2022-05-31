import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_database/firebase_database.dart';


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
  late int x  = 0;
  @override
  void initState() {
    super.initState();
  }

  //docRef.
  /*docRef.snapshots().listen(
  (event) => print("current data: ${event.data()}"),
  onError: (error) => print("Listen failed: $error"),
  );*/
  @override
  Widget build(BuildContext context) {
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
    return Container(
      width: 400,
      height: 250,
      color: Colors.green,
      child: Column(children:[SizedBox(height: 100,),Text("trtrtr",style:
      TextStyle(fontSize: 21,color: Colors.black)),GestureDetector(
        child: SvgPicture.asset('assets/Full_pack.svg', width: 100, height: 70,),
        onTap: () async{
          print("kalamari");
          //var cloudWords =  await FirebaseFirestore.instance.collection('N1').doc('N2').
          //get().then((querySnapshot) {return querySnapshot.data();});
          //Map<String, dynamic> c1 = {'check':cloudWords!['check'] + 1};
         // db.collection('N1').doc('N2').set(c1,SetOptions(merge : false));
        },
      )]));


  }}


