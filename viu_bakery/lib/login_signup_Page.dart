import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:viu_bakery/home_page.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _nameController = TextEditingController();

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool _isLogin = true;

  void _login(BuildContext context, String email, String password) async {
    const String adminUser = "david.nolan@viu.ca"; // the admin email

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String role; // will store the role of the user

      // if the email entered matches the admin's email, set role to 'Admin'
      if (email == adminUser) {
        role = 'Admin';
      } else {
        // get the user role from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        role = userData['role'];
      }

      UserModel user = UserModel(role: role);

      // User is logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully logged in')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: user)),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'An unexpected error occurred. Please try again later.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _signup(
      BuildContext context, String email, String password, String name) async {
    // The domain you want to check
    String studentDomain = '@stumail.viu.ca';

    // Check if the entered email ends with the specified domain
    if (!email.endsWith(studentDomain)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Invalid email. Only @stumail.viu.ca emails are allowed.')),
      );
      return;
    }

    // Regex pattern to check if the password is 8 characters or more,
    // contains at least 1 uppercase letter, 1 lowercase letter,
    // 1 number, and 1 special character.
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Password must be at least 8 characters and include at least one uppercase letter, one lowercase letter, one number, and one special character.')),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'role': 'Student',
        // add any other user data you need
      });
      // User is signed up
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully signed up')),
      );
      // Create a UserModel with the role
      UserModel user = UserModel(role: 'Student');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: user)),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = 'An unexpected error occurred. Please try again later.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      print(e);
    }
  }

  void _toggleLoginSignup() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign-up Page'),
        backgroundColor: Colors.orange[300],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('background-assets/login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Opacity(
          opacity: 0.9,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[900],
              ),
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      _isLogin ? 'Login' : 'Sign up',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!_isLogin) ...[
                    // Name field only appears for Sign Up
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    label: _isLogin ? 'Login' : 'Sign up',
                    onPressed: () {
                      // Implement login or sign up logic
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _toggleLoginSignup,
                    child: Text(
                      _isLogin
                          ? 'Don\'t have an account? Sign up'
                          : 'Already have an account? Login',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange[300],
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      onPressed: () {
        String email = _emailController.text;
        String password = _passwordController.text;
        if (_isLogin) {
          _login(context, email, password); // Pass the context to _login
        } else {
          String name = _nameController.text;
          _signup(
              context, email, password, name); // Pass the context to _signup
        }
      },
      child: Text(label),
    );
  }
}
