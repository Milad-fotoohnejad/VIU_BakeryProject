import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool _isLogin = true;

  void _login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User is logged in
      // Navigate to home page or another page
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void _signup(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User is signed up
      // Navigate to home page or another page
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
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
        title: Text('Sign-up Page'),
        backgroundColor: Colors.orange[300],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../background-assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[800],
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
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                _buildButton(
                  label: _isLogin ? 'Login' : 'Sign up',
                  onPressed: () {
                    // Implement login or sign up logic
                  },
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: _toggleLoginSignup,
                  child: Text(
                    _isLogin
                        ? 'Don\'t have an account? Sign up'
                        : 'Already have an account? Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
        primary: Colors.orange[300],
        padding: EdgeInsets.symmetric(vertical: 16),
        textStyle: TextStyle(fontSize: 18),
      ),
      onPressed: () {
        String email = _emailController.text;
        String password = _passwordController.text;
        if (_isLogin) {
          _login(email, password);
        } else {
          _signup(email, password);
        }
      },
      child: Text(label),
    );
  }
}
