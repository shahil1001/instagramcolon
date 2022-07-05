import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramcolon/Models/PostModel.dart';
import 'package:instagramcolon/Resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> UploadPost(String discription, Uint8List file, String uid,
      username, ProfileUrl) async {
    String res = "error occored";
    try {
      String Pid = Uuid().v1();
      String postUrl =
          await StorageMethods().UploadImagesTostorage("posts", file, true);
      Post post = Post(discription, uid, username, Pid, postUrl, ProfileUrl,
          DateTime.now(), []);
      await _firestore.collection("posts").doc(Pid).set(post.toJson());
      res = "succuss";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
