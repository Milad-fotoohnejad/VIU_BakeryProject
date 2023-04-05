import 'package:flutter/material.dart';
import 'package:viu_bakery/home_page.dart';
import 'package:viu_bakery/navigation.dart';

void main() {
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
    );
  }
}
