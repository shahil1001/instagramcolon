import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagramcolon/Providers/user_provider.dart';
import 'package:instagramcolon/Screens/login_screen.dart';
import 'package:instagramcolon/Utils/Colors.dart';

import 'package:instagramcolon/responsive/mobile_layout.dart';
import 'package:instagramcolon/responsive/responsivelayout.dart';
import 'package:instagramcolon/responsive/web_layout.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDD8Byzn-igzAGtfAZeXcHdWxeGM7DXukg",
            appId: "1:307342355157:web:61b06e1e6d328fb3fcd05c",
            messagingSenderId: "307342355157",
            storageBucket: "instagram-ee63f.appspot.com",
            projectId: "nstagram-ee63f"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()
            // this is how you initilize you provider
            )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
           scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            // it will see if user has logged in or out that reffers to authstate
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ResponsiveLayout(Mobilelayout(), Weblayout());
                } else if (snapshot.hasError) {
                  Text("Some Internal error occoured !");
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }
              return LoginScreen();
            },
          )   //ResponsiveLayout(Mobilelayout(), Weblayout()),

          ),
    );
  }
}
