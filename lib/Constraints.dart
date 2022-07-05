import 'package:flutter/material.dart';
import 'package:instagramcolon/Screens/Addpost_screen.dart';
class Contrains{
  List Navigation=<Widget>[
  Center(child: Text("Home", style: TextStyle(color: Colors.white),)),
  Center(child: Text("Search", style: TextStyle(color: Colors.white),)),
  AddpostScreen(),
  Center(child: Text("Notification", style: TextStyle(color: Colors.white),)),
  Center(child: Text("Profile", style: TextStyle(color: Colors.white),)),
  ];
}
