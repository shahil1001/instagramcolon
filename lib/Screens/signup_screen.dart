
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramcolon/Resources/auth_ethods.dart';
import 'package:instagramcolon/Screens/dempPage.dart';
import 'package:instagramcolon/Screens/login_screen.dart';
import 'package:instagramcolon/Utils/utils.dart';

import '../widgets/textfeild_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Uint8List? userimage;
  TextEditingController email_controller = TextEditingController();
  TextEditingController pass_controller = TextEditingController();
  TextEditingController username_controller = TextEditingController();
  TextEditingController bio_controller = TextEditingController();
bool _IsLoading=false;
  @override
  void dispose() {
    super.dispose();
    email_controller.dispose();
    pass_controller.dispose();
    username_controller.dispose();
    bio_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            padding: MediaQuery.of(context).size.width>600? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3):
          EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //logo
                  Container(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "images/insta.svg",
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              userimage != null
                                  ? CircleAvatar(
                                      backgroundImage: MemoryImage(userimage!),
                                      radius: 60,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          AssetImage("images/profile.png"),
                                      radius: 60,
                                    ),
                              Positioned(
                                  bottom: -10,
                                  left: 70,
                                  child: IconButton(
                                    onPressed: () {
                                      GetTheImage();
                                    },
                                    icon: Icon(
                                      Icons.add_a_photo,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),

                  Container(
                    child: Column(
                      children: [
                        TextFeildWidget("Enter your Username",
                            TextInputType.name, false, username_controller),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFeildWidget(
                            "Your Email",
                            TextInputType.emailAddress,
                            false,
                            email_controller),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFeildWidget(
                            "Password",
                            TextInputType.visiblePassword,
                            true,
                            pass_controller),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFeildWidget(
                            "Enter your Bio",
                            TextInputType.visiblePassword,
                            false,
                            bio_controller),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              //TODO LoginUser

                             SignUpuser();

                            },
                            child: _IsLoading? Center(child: CircularProgressIndicator(color: Colors.white,)):Text("SignUp")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text("Already have an account? ")),
                            InkWell(
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: const Text(
                                    "Signup",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                  //TextFeild(email)
                  //TextFeild(pass)
                  //ReigsterScreenLink
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void GetTheImage() async {
    // for IOS you need to edit your INFO.plist
    Uint8List image = await PickImage(ImageSource.gallery);
    setState(() {
      userimage = image;
    });
  }

  void SignUpuser() async {
    setState(() {
      _IsLoading=true;
    });
    String res = await AuthMethods().signupUser(
      email: email_controller.text.trim(),
      password: pass_controller.text.trim(),
      username: username_controller.text.trim(),
      bio: bio_controller.text.trim(),
      profile: userimage!,
    );


    if(res=="succuss"){
      Navigator.push(context, MaterialPageRoute(builder: (context) => DemoPage(),));
    }
    if (res != null) {
      ShowMessage(context,res);
      setState(() {
        _IsLoading=false;
      });

    }
  }
}
