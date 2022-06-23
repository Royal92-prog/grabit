import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> getAvatar() async{
  return FirebaseFirestore.instance.collection('game').doc('avatar').get().then((snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null) {
        return data['picture'];
      }
    }
    return null;
  });
}

Future<String?> updateAvatar() async {
  FilePickerResult? pickerResult = await FilePicker.platform.pickFiles();
  if (pickerResult != null) {
    final picture = File(pickerResult.files.single.path!);
    final fileName = pickerResult.files.single.name;
    UploadTask pictureUpload = FirebaseStorage.instance.ref().child('avatars/$fileName').putFile(picture);
    String url = await (await pictureUpload).ref.getDownloadURL();
    return FirebaseFirestore.instance.collection('game').doc('avatar').set({"picture": url}, SetOptions(merge: true)).then((value) => url);
  }
  else {
    return Future(() => null);
  }
}
