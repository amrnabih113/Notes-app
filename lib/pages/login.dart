// ignore_for_file: avoid_print

import 'package:app7/Database/database.dart';
import 'package:app7/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController =
      TextEditingController(); // Changed from _usernameController
  final _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> Scaffoldkey = GlobalKey();
  FocusNode focusNode = FocusNode();
  bool rememberMe = false; // Manage the checkbox state
  bool showpasssword = false;
  SqlDb MyDb = SqlDb();

  _checkuser(String email, String password) async {
    var response = await MyDb.getdata('''
              SELECT "ID"
              FROM "USERS" 
              WHERE "EMAIL" = "$email"  
              AND "PASSWORD" = "$password"
    ''');
    return response;
  }

  _showerrordialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Incorrect email or password. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ));
  }

  Future<void> saveuserid(int userid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setInt("userid", userid);
      if (!result) {
        print("Failed to save userid");
      }
    } catch (e) {
      print("Error saving userid: $e");
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    _emailController.dispose(); // Changed from _usernameController
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Scaffoldkey,
      backgroundColor: const Color(0xff151515), // Dark background
      body: GestureDetector(
        onTap: () {
          setState(() {
            focusNode.unfocus(); // Correct usage of unfocus
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Welcome back,',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller:
                    _emailController, // Changed from _usernameController
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2B2B2E),
                  labelText: 'Email', // Changed from 'Username'
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.email, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: !showpasssword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2B2B2E),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  suffixIcon: !showpasssword
                      ? IconButton(
                          icon: const Icon(Icons.visibility),
                          color: Colors.white70,
                          onPressed: () {
                            setState(() {
                              showpasssword = !showpasssword;
                            });
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.visibility_off_sharp),
                          color: Colors.white70,
                          onPressed: () {
                            setState(() {
                              showpasssword = !showpasssword;
                            });
                          },
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool? newValue) {
                          setState(() {
                            rememberMe = newValue!;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xff4e33ff)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  List response = await _checkuser(email, password);
                  if (response.isEmpty) {
                    _showerrordialog();
                  } else {
                    final userId = response[0]['ID'];
                    rememberMe ? saveuserid(userId) : null;
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacementNamed("homepage");
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color(0xff4e33ff),
                ),
                child: const Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: MaterialButton(
                  height: 40,
                  minWidth: double.infinity,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        width: 2,
                        color: Color(0xff4e33ff),
                      )),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                  },
                  child: const Text(
                    'Create account',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

