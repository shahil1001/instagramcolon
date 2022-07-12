import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagramcolon/Models/Usermodel.dart';
import 'package:instagramcolon/Providers/user_provider.dart';
import 'package:instagramcolon/Resources/firestore_methods.dart';
import 'package:instagramcolon/Screens/comment_screen.dart';
import 'package:instagramcolon/widgets/heart_animation_widget.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../Utils/Colors.dart';

class PostCard extends StatefulWidget {
  var snap;

  PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isHeartAnimating = false;
  bool isLiked = false;
  int comment = 0;

  @override
  void initState() {
    super.initState();
    getCommentsLength();
  }

  void getCommentsLength() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.snap["postID"])
        .collection("comments")
        .get();
    comment=querySnapshot.docs.length;
  setState(() {

  });
  }

  @override
  Widget build(BuildContext context) {

    Timestamp timestamp = widget.snap["DatePublished"];
    User? user = Provider.of<UserProvider>(context).getUser;

    return Column(
      children: [
        // header Container
        Container(
          padding: EdgeInsets.all(10),
          color: mobileBackgroundColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.snap["ProfileUrl"]),
                    radius: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 9),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap["name"],
                            style: GoogleFonts.lato(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.black54,
                              title: Text("Do you want to delete this Post?"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      //TODO delete the post from firebase
                                    },
                                    child: Text("Yes")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("No")),
                              ],
                            );
                          });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        // User post section is here
        SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: GestureDetector(
                  onDoubleTap: () async {
                    await FirestoreMethods().likePost(widget.snap["postID"],
                        widget.snap["uid"], widget.snap["likes"]);
                    setState(() {
                      isHeartAnimating = true;
                      isLiked = widget.snap["likes"].length > 0;
                    });
                  },
                  child: Image(
                    filterQuality: FilterQuality.medium,
                    image: NetworkImage(
                      widget.snap["postUrl"],
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: isHeartAnimating ? 1 : 0,
                child: HeartAnimation(
                  duration: Duration(milliseconds: 200),
                  isAnimating: isHeartAnimating,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 100,
                  ),
                  onend: () {
                    setState(() {
                      isHeartAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                HeartAnimation(
                  isAnimating: isLiked,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                      icon: isLiked
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            )
                          : Icon(
                              Icons.favorite_outline_rounded,
                              color: Colors.white,
                            )),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                    snap: widget.snap,
                                  )));
                    },
                    icon: const Icon(Icons.comment_outlined)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.send_outlined)),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.bookmark_border))),
                )
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${widget.snap["likes"].length} likes',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: widget.snap["name"],
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "  ${widget.snap["discription"]}",
                        style: GoogleFonts.lato(fontSize: 16)),
                  ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  "View all ${comment} comments",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  Jiffy().from(timestamp.toDate()),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
