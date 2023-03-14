import 'package:flutter/material.dart';
import 'ExcelReader.dart'; // import the ExcelReader widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excel Reader',
      home: ExcelReader(), // display the ExcelReader widget
    );
  }
}
