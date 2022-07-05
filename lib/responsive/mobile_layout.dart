import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/Addpost_screen.dart';
import '../Utils/Colors.dart';

class Mobilelayout extends StatefulWidget {
  const Mobilelayout({Key? key}) : super(key: key);

  @override
  State<Mobilelayout> createState() => _MobilelayoutState();
}

class _MobilelayoutState extends State<Mobilelayout> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
  void OnTapped(int page) {
    pageController.jumpToPage(page);
  }
  void pagechanged(int value) {
    setState(() {
      _page=value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: PageView(
        children: [
          Center(child: Text("Home", style: TextStyle(color: Colors.white),)),
          Center(child: Text("Search", style: TextStyle(color: Colors.white),)),
          AddpostScreen(),
          Center(child: Text("Notification", style: TextStyle(color: Colors.white),)),
          Center(child: Text("Profile", style: TextStyle(color: Colors.white),)),
        ],
        controller: pageController,
        onPageChanged: pagechanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar:
          CupertinoTabBar(backgroundColor: mobileBackgroundColor, items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.email,
                color: _page == 0 ? primaryColor : secondaryColor)),
        BottomNavigationBarItem(
            icon: Icon(
          Icons.search,
          color: _page == 1 ? primaryColor : secondaryColor,
        )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  color: _page == 2 ? primaryColor : secondaryColor,
                )),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor)),
        BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor)),
      ],onTap: OnTapped),

    );
  }




}
