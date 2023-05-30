import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:viu_bakery/main.dart';
import 'package:viu_bakery/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAccountPage extends StatefulWidget {
  final UserModel user;

  const MyAccountPage({Key? key, required this.user}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Variables to store user role and show/hide Add Admin button
  String _userRole = '';
  bool _showAddAdminButton = false;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get();
    setState(() {
      _userRole = userSnapshot['role'];
      _showAddAdminButton = _userRole == 'Admin';
      //fetch the name of the user
    });
  }

  void _displayAddAdminDialog() {
    // New Admin Text Controllers
    TextEditingController newAdminNameController = TextEditingController();
    TextEditingController newAdminEmailController = TextEditingController();
    TextEditingController newAdminPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Admin'),
          content: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: newAdminNameController,
                  decoration: const InputDecoration(hintText: "Admin Name"),
                ),
                TextField(
                  controller: newAdminEmailController,
                  decoration: const InputDecoration(hintText: "Admin Email"),
                ),
                TextField(
                  controller: newAdminPasswordController,
                  decoration: const InputDecoration(hintText: "Admin Password"),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                String name = newAdminNameController.text;
                String email = newAdminEmailController.text;
                String password = newAdminPasswordController.text;

                try {
                  UserCredential userCredential =
                      await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Update the user role to 'Admin' in the Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userCredential.user!.uid)
                      .set({
                    'name': name,
                    'role': 'Admin',
                    'email': email,
                    userCredential.user!.uid: true,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('New admin user has been added')),
                  );

                  Navigator.of(context).pop();
                } on FirebaseAuthException catch (e) {
                  String message;
                  if (e.code == 'weak-password') {
                    message = 'The password provided is too weak.';
                  } else if (e.code == 'email-already-in-use') {
                    message = 'The account already exists for that email.';
                  } else {
                    message =
                        'An unexpected error occurred. Please try again later.';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: Colors.orange[300],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('background-assets/myaccount.jpg'),
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
                      'User Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Name: ${_auth.currentUser?.displayName ?? 'No user logged in'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Email: ${_auth.currentUser?.email ?? 'No user logged in'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[300],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () async {
                      // Sign out
                      await _auth.signOut();
                      // Navigate back to the main.dart after sign out
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                      );
                    },
                    child: const Text('Sign Out'),
                  ),
                  if (_showAddAdminButton)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[300],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        onPressed: _displayAddAdminDialog,
                        child: const Text('Add Admin'),
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
}
