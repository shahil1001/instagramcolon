
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:instagramcolon/Screens/profile_screen.dart';
import 'package:instagramcolon/Utils/Colors.dart';

class SearchScreen extends StatefulWidget {


  SearchScreen({Key? key,}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = false;
  var future= FirebaseFirestore.instance.collection("posts").get();
  List searchCategories = [
    "Shop",
    "Decor",
    "Travel",
    "Architechture",
    "Food",
    "Art",
    "Style",
    "TV & Movies",
    "Music",
    "DIY",
    "Comics"
  ];
  TextEditingController serch = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    serch.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Container(
            margin: EdgeInsets.only(top: 5),
            width: size.width - 33,
            height: 40,
            decoration: BoxDecoration(
              color: textFieldBackground,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: serch,
              decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
              style: TextStyle(color: Colors.white.withOpacity(0.4)),
              onSubmitted: (val) {
                print("${serch.text}");
                setState(() {
                  isSearching = true;
                });
              },
            ),
          ),
        ),
        body: isSearching
            ? FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where("name", isGreaterThanOrEqualTo: serch.text)
                    .get(),
                builder: (index, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: (){
                                print(snapshot.data!.docs[index].get("name"));
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>ProfileScreen(Uid: snapshot.data!.docs[index].get("uid"),),),);
                              },
                              subtitle: Text(
                                snapshot.data!.docs[index].get("email"),
                                style: GoogleFonts.lato(fontSize: 15),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data!.docs[index].get("profile")),
                              ),
                              title: Text(
                                snapshot.data!.docs[index].get("name"),
                                style: GoogleFonts.lato(fontSize: 20),
                              ),
                            );
                          });
                    }
                  }
                  return Center(child: Text("Loading...."));
                })
            : Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(searchCategories.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              searchCategories[index],
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: FutureBuilder<QuerySnapshot>(
                    future:
                    future,
                    builder: (index, snapshot) {
                      if (snapshot.hasData) {
                        return StaggeredGridView.countBuilder(
                          itemCount: snapshot.data!.docs.length,
                          crossAxisCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                                width: (size.width - 3) / 3,
                                height: (size.width - 3) / 3,
                                child: Image(
                                  image: NetworkImage(snapshot.data!.docs[index]
                                      .get("postUrl")),
                                  fit: BoxFit.cover,
                                ));
                          },
                          staggeredTileBuilder: (index) => StaggeredTile.count(
                              (index % 7 == 0) ? 2 : 1,
                              (index % 7 == 0) ? 2 : 1),
                          crossAxisSpacing: 1.5,
                          mainAxisSpacing: 1.5,
                        );
                      }
                      return Text("Loading..");
                    },
                  ))
                ],
              ),
      ),
    );
  }
}
