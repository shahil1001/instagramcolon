import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String discription;
  final String uid;
  final String username;
  final String postID;
  final String postUrl;
  final String ProfileUrl;
  final DatePublished;
  final Likes;

  Post(this.discription, this.uid, this.username, this.postID, this.postUrl,
      this.ProfileUrl, this.DatePublished, this.Likes);

  Map<String, dynamic> toJson() => {
        "name": username,
        "uid": uid,
        "discription": discription,
        "postID": postID,
        "postUrl": postUrl,
        "ProfileUrl": ProfileUrl,
        "DatePublished": DatePublished,
        "likes": Likes
      };

  static Post fromsnap(DocumentSnapshot documentSnapshot) {
    return Post(
      documentSnapshot.get("discription"),
      documentSnapshot.get("uid"),
      documentSnapshot.get("username"),
      documentSnapshot.get("postID"),
      documentSnapshot.get("postUrl"),
      documentSnapshot.get("ProfileUrl"),
      documentSnapshot.get("DatePublished"),
      documentSnapshot.get("likes"),
    );
  } // Making this method static otherwise I have to paas parameters
}
