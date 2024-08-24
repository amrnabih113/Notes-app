import 'package:app7/pages/homepage.dart';
import 'package:app7/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? userid;

  @override
  void initState() {
    getusersittigs();
    super.initState();
  }

  Future<void> getusersittigs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userid = prefs.getInt("userid");
        print("userid = $userid");
      });
    } catch (e) {
      print("Failed to get user settings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: userid == null || userid == -1
          ? const LoginPage()
          : HomePage(
              user_id: userid!,
            ),
      routes: {
        "homepage": (context) => HomePage(user_id: userid!),
        "loginpage": (context) => const LoginPage()
      },
    );
  }
}
