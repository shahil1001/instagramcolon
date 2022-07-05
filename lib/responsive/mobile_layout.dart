

import 'package:flutter/material.dart';
import 'package:instagramcolon/Models/Usermodel.dart' as model;
import 'package:instagramcolon/Providers/user_provider.dart';
import 'package:provider/provider.dart';
class Mobilelayout extends StatelessWidget {
  const Mobilelayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
model.User ? user=Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Center(child: Text(user!.bio,style: const TextStyle(color: Colors.white),)),
    );
  }
}
