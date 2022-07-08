import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagramcolon/Utils/Colors.dart';

import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AppBar Container
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.camera),
                    SvgPicture.asset(
                      "images/insta.svg",
                      height: 30,
                      color: Colors.white,
                    ),
                    Icon(Icons.message),
                  ],
                ),
              ),
              // FeedPost Container
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.length==0) {
                        const Center(
                            child: Text(
                              "Please upload somthing!",
                              style: TextStyle(color: primaryColor),
                            ));
                      } else {
                        return ListView.builder(
                          reverse: true,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) =>
                                PostCard(
                                  snap: snapshot.data!.docs[index].data(),
                                ));
                      }
                    }
                    return const Center(
                      child: Text(
                        "No data is here",
                        style: TextStyle(color: primaryColor),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
