import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email, bio, profileurl, username;
  List following, followers;
  String uid;

  User(this.email, this.bio, this.profileurl, this.username, this.following,
      this.followers,this.uid);

  Map<String, dynamic> toJson() => {
        "name": username,
        "email": email,
        "bio": bio,
        "profile": profileurl,
        "followers": followers,
        "following": following,
    "uid":uid
      };

   static User fromsnap(DocumentSnapshot documentSnapshot) {

    return User(
        documentSnapshot.get("email"),
        documentSnapshot.get("bio"),
        documentSnapshot.get("profile"),
        documentSnapshot.get("name"),
        documentSnapshot.get("following"),
        documentSnapshot.get("followers"),
        documentSnapshot.get("uid"));
  }  // Making this method static otherwise I have to paas parameters
}
