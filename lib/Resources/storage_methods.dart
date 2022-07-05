import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> UploadImagesTostorage(
      String path, Uint8List file, bool isPost) async {
    Reference reference = await firebaseStorage
        .ref()
        .child(path)
        .child(_firebaseAuth.currentUser!.uid);
    if (isPost) {
      String Pid = Uuid().v1();
      reference = reference.child(Pid);
    }
    Task uploadtask = reference.putData(file);
    TaskSnapshot taskSnapshot = await uploadtask;

    return taskSnapshot.ref.getDownloadURL();
  }
}
