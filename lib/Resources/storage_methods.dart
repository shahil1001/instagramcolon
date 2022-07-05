import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> UploadImagesTostorage(
      String path, Uint8List file, bool isPost) async {
    Reference reference = await firebaseStorage
        .ref()
        .child(path)
        .child(_firebaseAuth.currentUser!.uid);
    Task uploadtask = reference.putData(file);
    TaskSnapshot taskSnapshot=await uploadtask;
    return taskSnapshot.ref.getDownloadURL();
  }
}
