import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool _isLogin = true;

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
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
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
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
