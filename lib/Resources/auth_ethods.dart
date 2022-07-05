import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:instagramcolon/Models/Usermodel.dart' as Model;
import 'package:instagramcolon/Resources/storage_methods.dart';


class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<Model.User>getUserDetails()async{
  DocumentSnapshot documentSnapshot=await  _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).get();
  return  Model.User.fromsnap(documentSnapshot);
  }


  Future<String> signupUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List profile}) async {
    String res = "Error Occured";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          profile != null) {
        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);


        res = "succuss";
        String downloadUrl = await StorageMethods()
            .UploadImagesTostorage("profilePics", profile, false);

        Model.User user = Model.User(email, bio, downloadUrl, username, [], [],_firebaseAuth.currentUser!.uid);

        _firestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        // _firestore.collection("users").doc(userCredential.user!.uid).set({
        //   "name": username,
        //   "email": email,
        //   "bio": bio,
        //   "profile": downloadUrl,
        //   "followers": []
        // });

      } else {
        res = "Please fill up the details";
      }
    } catch (error) {
      res = error.toString();
      print("The erroe is $error");
    }
    return res;
  }

  Future<String> LogInUser({
    required String email,
    required String password,
  }) async {
    String resp = "Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => print("LoggedIn!!"));
        resp = "succuss";
      } else {
        resp = "Please fill up the details";
      }
    } catch (error) {
      resp = error.toString();
      print("The erroe is $error");
    }
    return resp;
  }
}
