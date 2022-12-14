import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> getAvatarByUsername(username) async{
  return FirebaseFirestore.instance.collection('usersData').doc(username).get().then((snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null) {
        return data['avatar'];
      }
    }
    return null;
  });
}

Future<String?> updateAvatarByUsername(username) async {
  FilePickerResult? pickerResult = await FilePicker.platform.pickFiles();
  if (pickerResult != null) {
    final picture = File(pickerResult.files.single.path!);
    final fileName = pickerResult.files.single.name;
    UploadTask pictureUpload = FirebaseStorage.instance.ref().child('avatars/$fileName').putFile(picture);
    String url = await (await pictureUpload).ref.getDownloadURL();
    return FirebaseFirestore.instance.collection('usersData').doc(username).set({"avatar": url}, SetOptions(merge: true)).then((value) => url);
  }
  else {
    return Future(() => null);
  }
}

void setAvatarForGame(gameNum, avatarUrl, playerIndex) async{
  await FirebaseFirestore.instance.collection('game').doc('players${gameNum}').set({
    'player_${playerIndex}_avatar' : avatarUrl
  }, SetOptions(merge: true));
}

Future<String?> getAvatarByGameIndex(playerIndex, gameNum) async{
  return FirebaseFirestore.instance.collection('game').doc('players${gameNum}').get().then((snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null) {
        return data['player_${playerIndex}_avatar'];
      }
    }
    return null;
  });
}