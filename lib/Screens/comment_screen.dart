import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagramcolon/Resources/firestore_methods.dart';
import 'package:instagramcolon/Utils/Colors.dart';
import 'package:provider/provider.dart';

import '../Models/Usermodel.dart';
import '../Providers/user_provider.dart';
import '../widgets/CommentCard.dart';

class CommentScreen extends StatefulWidget {
  var snap;

  CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController C_textEditingController = TextEditingController();
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.snap["postID"])
        .collection("comments")
        .orderBy("time", descending: true)
        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    C_textEditingController.dispose();
//
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            print("active");
            if (snapshot.hasData) {
              print("has data");
              return ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return CommentCard(
                      snap: snapshot.data!.docs[index].data(),
                    );
                  });
            } else {
              print("No comments yet!");
            }
          }
          return Container();
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            padding: EdgeInsets.only(right: 16, left: 8),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom), //TODO imppp!
            height: kToolbarHeight,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user!.profileurl),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: "Comment as ${user.username}",
                                    border: InputBorder.none),
                                controller: C_textEditingController,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                //TODO post user comment to DB from here
                                await FirestoreMethods().PostComment(
                                    widget.snap["postID"],
                                    C_textEditingController.text,
                                    user.profileurl,
                                    user.uid,
                                    user.username);
                                C_textEditingController.clear();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text("Done"),
                              ),
                            )
                          ],
                        )))
              ],
            )),
      ),
    );
  }
}
