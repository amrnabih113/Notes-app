import 'package:flutter/material.dart';
import 'package:app7/Database/database.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showPassword = false;
  final SqlDb _myDb = SqlDb();

  Future<bool> _checkExistingEmail(String email) async {
    final response = await _myDb.getdata('''
      SELECT "ID"
      FROM "USERS"
      WHERE "EMAIL" = ?
    ''', [email]);

    return response.isNotEmpty;
  }

  Future<void> _registerUser(
      String username, String email, String password) async {
    try {
      await _myDb.insert("""
        INSERT INTO "USERS" ("NAME", "EMAIL", "PASSWORD")
        VALUES (?, ?, ?)
      """, [username, email, password]);

      _showSuccessDialog();
    } catch (e) {
      print("Error registering user: $e");
      _showErrorDialog('An error occurred while registering the user.');
    }
  }

  Future<void> _handleSignUp() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    if (await _checkExistingEmail(email)) {
      _showErrorDialog('An account with this email already exists.');
      return;
    }

    await _registerUser(username, email, password);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Account created successfully.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pushReplacementNamed("loginpage");
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xff151515), // Dark background
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Correct usage of unfocus
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign up to get started',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2B2B2E),
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.person, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2B2B2E),
                  labelText: 'Email',
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
                obscureText: !showPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2B2B2E),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  suffixIcon: IconButton(
                    icon: Icon(showPassword
                        ? Icons.visibility_off_sharp
                        : Icons.visibility),
                    color: Colors.white70,
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleSignUp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color(0xff4e33ff),
                ),
                child: const Center(
                  child: Text(
                    'Sign Up',
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
                    Navigator.of(context).pushReplacementNamed("loginpage");
                  },
                  child: const Text(
                    'Back to Login',
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
