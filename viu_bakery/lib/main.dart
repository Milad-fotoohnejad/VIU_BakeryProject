import 'package:flutter/material.dart';
import 'package:viu_bakery/home_page.dart';
import 'package:viu_bakery/navigation.dart';
import 'login_signup_page.dart';
import 'recipe_upload_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAQce9PR40vDxItWDpxB4btKB248a7b39U",
          authDomain: "bakeryproject-6f924.firebaseapp.com",
          projectId: "bakeryproject-6f924",
          storageBucket: "bakeryproject-6f924.appspot.com",
          messagingSenderId: "868989986714",
          appId: "1:868989986714:web:d0b3d6ba32ecf1b03b3c23",
          measurementId: "G-1VNP5SE2X0"),
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicated-app') {
      rethrow;
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bakery Recipes',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Column(
          children: [
            TopNavigationBar(),
            Expanded(child: HomePage()),
          ],
        ),
      ),
      routes: {
        '/upload': (context) => RecipeUploadPage(),
      },
    );
  }
}
