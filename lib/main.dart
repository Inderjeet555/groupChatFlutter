import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_chat/helper/helperFunctions.dart';
import 'package:group_chat/pages/auth/login_page.dart';
import 'package:group_chat/pages/auth/profile_page.dart';
import 'package:group_chat/pages/home_page.dart';
import 'package:group_chat/shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  _getUserLoggedInStatus() async {
    await HelperFunctions.isUserLoggedIn().then((value) => {
          //print('object')
          if (value != null)
            {
              setState(() {
                _isSignedIn = value;
              })
            }
        });
  }

  @override
  void initState() {
    super.initState();
    _getUserLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Constants().primaryColor,
          scaffoldBackgroundColor: Colors.white),
      home: _isSignedIn ? const HomePage() : const LogInPage(),
    );
  }
}
