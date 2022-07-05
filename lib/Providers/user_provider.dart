import 'package:flutter/cupertino.dart';
import 'package:instagramcolon/Resources/auth_ethods.dart';

import '../Models/Usermodel.dart';

class UserProvider extends ChangeNotifier {
  User? _user; // initially is empty
  User ? get getUser => _user;
  // final AuthMethods _authMethods = AuthMethods();

  Future<void> refreshUSer() async {
    User user = await AuthMethods().getUserDetails();
    _user = user;
    print("in Provider  $_user");
    notifyListeners(); // data of our global _user changed now notifayall
  }
}
