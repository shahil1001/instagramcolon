import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramcolon/Resources/auth_ethods.dart';
import 'package:instagramcolon/Screens/dempPage.dart';
import 'package:instagramcolon/Screens/signup_screen.dart';
import 'package:instagramcolon/Utils/utils.dart';

import '../widgets/textfeild_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email_controller = TextEditingController();
  TextEditingController pass_controller = TextEditingController();
  bool IsLoading = false;

  @override
  void dispose() {
    super.dispose();
    email_controller.dispose();
    pass_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: MediaQuery.of(context).size.width>600? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3):
          EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //logo
              Flexible(flex: 2, child: Container()),
              SvgPicture.asset(
                "images/insta.svg",
                color: Colors.white,
              ),
              const SizedBox(
                height: 25,
              ),
              TextFeildWidget("Your Email", TextInputType.emailAddress, false,
                  email_controller),
              const SizedBox(
                height: 25,
              ),
              TextFeildWidget("Password", TextInputType.visiblePassword, true,
                  pass_controller),
              const SizedBox(
                height: 20,
              ),
              IsLoading? Center(child: CircularProgressIndicator()): ElevatedButton(
                  onPressed: () {
                    //TODO LoginUser
                    LoginUser();
                  },
                  child: Text("Log In")),
              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Don't have an account? ")),
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Signup",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void LoginUser() async {
    setState(() {
      IsLoading = true;
    });

    String email = email_controller.text.trim();
    String password = pass_controller.text.trim();
    String res =
    await AuthMethods().LogInUser(email: email, password: password);
    if (res != null) {
      setState(() {
        IsLoading = false;
      });
      if(res=="succuss"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DemoPage(),));
      }
      ShowMessage(context, res);
    }

  }
}
