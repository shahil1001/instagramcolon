import 'package:flutter/material.dart';
import 'package:instagramcolon/Providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'mobile_layout.dart';

class ResponsiveLayout extends StatefulWidget {
  Widget mobilelayout, weblayout;

  ResponsiveLayout(this.mobilelayout, this.weblayout, {Key? key}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() async {
    UserProvider userProvider = Provider.of(context,listen: false); //listen: false will only enable provider once
    await userProvider.refreshUSer();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        //web
        return widget.weblayout;
      } else {
        //mobile
        return Mobilelayout();
      }
    });
  }
}
