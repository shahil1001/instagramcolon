import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Resources/firestore_methods.dart';
import '../Utils/Colors.dart';

class ProfileScreen extends StatefulWidget {
  String Uid;

  ProfileScreen({Key? key, required this.Uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late var Userdata;
  int post = 0;
  int followers = 0;
  int folloing = 0;
  bool isFollowing = false;

  String name = "", bio = "";
  String profilrPic = "";
  List<String> images = [];
  bool Isloading = false;

  @override
  void initState() {
    super.initState();
    print("here !!!!!!!!${widget.Uid}");
    getUserData();
  }

  getUserData() async {
    setState(() {
      Isloading = true;
    });
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.Uid)
        .get();
    QuerySnapshot PostdocumentSnapshot = await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: widget.Uid)
        .get();
    PostdocumentSnapshot.docs.forEach((element) {
      images.add(element.get("postUrl"));
    });
    setState(() {
      Userdata = documentSnapshot;
    });
    name = Userdata.get("name");
    profilrPic = await Userdata.get("profile");
    post = images.length;
    followers = await Userdata.get("followers").length;
    folloing = Userdata.get("following").length;
    bio = await Userdata.get("bio");
    isFollowing = await Userdata.get("followers")
        .contains(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      Isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(isFollowing);
    return Isloading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(name),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(profilrPic),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PFFSection("Posts", images.length),
                                  PFFSection("Flollowers", followers),
                                  PFFSection("Following", folloing),
                                ],
                              ),
                            )
                          ],
                        ), // user image PFF
                        SizedBox(
                          height: 10,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.ptSans(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                bio,
                                style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.8)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            FirebaseAuth.instance.currentUser!.uid == widget.Uid
                                ? FollowButton(null, mobileBackgroundColor,
                                    Colors.white, Colors.white, "Edit Profile")
                                : isFollowing
                                    ? FollowButton(() async {
                                        setState(() {
                                          followers--;
                                          isFollowing = false;
                                        });
                                        await FirestoreMethods().FollowUnfollow(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            Userdata.get("uid"));
                                      }, mobileBackgroundColor, Colors.white,
                                        Colors.white, "Unfollow")
                                    : FollowButton(() async {
                                        setState(() {
                                          followers++;
                                          isFollowing = true;
                                        });
                                        await FirestoreMethods().FollowUnfollow(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            Userdata.get("uid"));
                                      }, Colors.blue, Colors.black,
                                        Colors.white, "Follow")
                          ],
                        ), // name and discription
                        const SizedBox(
                          height: 5,
                        ),

                        const Divider(
                          color: Colors.white24,
                          thickness: 1,
                        ),
                        Expanded(
                          child: GridView.builder(
                              itemCount: images.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 1.8,
                                      mainAxisSpacing: 1.8),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(images[index]),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget PFFSection(String lable, int num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2,
        ),
        Text(lable,
            style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: secondaryColor)),
      ],
    );
  }
}

class FollowButton extends StatelessWidget {
  Function()? function;
  Color backgroundColors;
  Color borderColor, textColor;
  String text;

  FollowButton(this.function, this.backgroundColors, this.borderColor,
      this.textColor, this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
          color: backgroundColors,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(
          text,
          style: GoogleFonts.lato(
              fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
        )),
      ),
    );
  }
}
