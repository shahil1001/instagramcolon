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

  Future<void> likePost(String postId, String Uid, List likes) async {
    try {
      if (likes.contains(Uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([Uid])
          // dislike the post beause i've already liked it
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([Uid])
          //like the post
        });
      }
    } catch (error) {
      print(error.toString());
    }
    //Like the post
  }

  Future<void> PostComment(String postId, String comment,
      String picUrl, String uid, String name) async {
    String CommentId = Uuid().v1();
    try {
      if (comment.isNotEmpty) {
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(CommentId)
            .set({
          "Comment": comment,
          "picUrl": picUrl,
          "uid": uid,
          "name": name,
          "time": DateTime.now(),
          "commentId": CommentId
        }).then((value) => print("Succussfully Commented!!!!!!"));
      } else {
        print("empty!");
      }
    } catch (error) {
      print(error.toString());
    }
    //Like the post
  }
}
