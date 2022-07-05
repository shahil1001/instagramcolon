import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String email, bio, profileurl, username;
  List following, followers;

  User(this.email, this.bio, this.profileurl, this.username, this.following,
      this.followers);

  Map<String, dynamic> toJson() => {
        "name": username,
        "email": email,
        "bio": bio,
        "profile": profileurl,
        "followers": followers,
        "following": following
      };

   static User fromsnap(DocumentSnapshot documentSnapshot) {

    return User(
        documentSnapshot.get("email"),
        documentSnapshot.get("bio"),
        documentSnapshot.get("profile"),
        documentSnapshot.get("name"),
        documentSnapshot.get("following"),
        documentSnapshot.get("followers"));
  }  // Making this method static otherwise I have to paas parameters
}
