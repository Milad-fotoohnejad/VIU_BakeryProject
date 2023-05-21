import 'package:flutter/material.dart';
import 'package:viu_bakery/home_page.dart';
import 'package:viu_bakery/navigation.dart';
import 'recipe_upload_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      // commented this out to make it to work on iOS and android
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicated-app') {
      rethrow;
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bakery Recipes',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        body: Column(
          children: [
            TopNavigationBar(),
            Expanded(child: HomePage()),
          ],
        ),
      ),
      routes: {
        '/upload': (context) => const RecipeUploadPage(),
      },
    );
  }
}
