import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramcolon/Models/Usermodel.dart' as model;
import 'package:instagramcolon/Providers/user_provider.dart';
import 'package:instagramcolon/Resources/firestore_methods.dart';
import 'package:instagramcolon/Utils/Colors.dart';
import 'package:provider/provider.dart';

import '../Utils/utils.dart';

class AddpostScreen extends StatefulWidget {
  const AddpostScreen({Key? key}) : super(key: key);

  @override
  State<AddpostScreen> createState() => _AddpostScreenState();
}

class _AddpostScreenState extends State<AddpostScreen> {
  Uint8List? _file;
  TextEditingController dicription = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    dicription.dispose();
  }

  void uploadPost(String uid, username,
      String ProfileUrl) async {

    try {
      String res  = await FirestoreMethods()
          .UploadPost(dicription.text.trim(), _file!, uid, username, ProfileUrl);
      if(res=="succuss"){
        ShowMessage(context, "Posted!");
      }else{
        ShowMessage(context, res);
      }

    } catch (error) {
      ShowMessage(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ));
    }
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () {
                  showPhotoptions();
                },
                icon: Icon(Icons.upload_outlined, size: 50)),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              title: Text("Add Post"),
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      //TODO uploading post to FF
                      //TODO need to add this here user!.uid
                     uploadPost(FirebaseAuth.instance.currentUser!.uid, user!.username,  user!.profileurl);
                    },
                    child: const Text(
                      "Post",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user!.profileurl),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            controller: dicription,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Write a caption..."),
                            maxLines: 8,
                          )),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!), fit: BoxFit.fill)),
                      ),
                      Divider(),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  void showPhotoptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Upload Your Photo",
              style: GoogleFonts.lato(fontSize: 25),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    Uint8List file = await PickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  },
                  leading: Icon(Icons.photo),
                  title: Text(
                    "Select from Galary",
                    style: GoogleFonts.lato(fontSize: 20),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    //Fluttertoast.showToast(msg: "UnderConstruction");
                    Uint8List file = await PickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  },
                  leading: Icon(Icons.camera),
                  title: Text(
                    "Click from Camera",
                    style: GoogleFonts.lato(fontSize: 20),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
