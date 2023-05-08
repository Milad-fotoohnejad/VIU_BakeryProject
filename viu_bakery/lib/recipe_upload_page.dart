import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'bread_recipe_converter.dart';
import 'pastry_recipe_converter.dart';

class RecipeUploadPage extends StatefulWidget {
  @override
  _RecipeUploadPageState createState() => _RecipeUploadPageState();
}

class _RecipeUploadPageState extends State<RecipeUploadPage> {
  String _jsonArray = '';

  Future<void> _pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      Uint8List fileBytes = result.files.single.bytes!;
      List<Map<String, dynamic>> jsonArray = _convertExcelToJson(fileBytes);
      setState(() {
        _jsonArray = jsonEncode(jsonArray);
      });
    }
  }

  List<Map<String, dynamic>> _convertExcelToJson(Uint8List bytes) {
    var decoder = SpreadsheetDecoder.decodeBytes(bytes);
    var sheet = decoder.tables.values.first;
    var rows = sheet.rows;

    // bool pastryType = rows[2][0]?.toString().contains('Pastry') ?? false;

    List<Map<String, dynamic>> recipes = [];

    print('Length: ${rows[5][0].length}');
    for (int i = 0; i < rows[5][0].length; i++) {
      print('Char $i: ${rows[5][0][i]}');
    }

    String cleanString(String input) {
      // Replace any non-printable ASCII characters
      return input.replaceAll(RegExp(r'[^\x20-\x7E]+'), '');
    }

    if (rows[5][0] != null &&
        cleanString(rows[5][0].toString()).contains('Name: Pastry Cream')) {
      recipes.add(PastryRecipeConverter.convertPastryToJson(rows));
    } else {
      recipes.add(BreadRecipeConverter.convertBreadToJson(rows));
    }

    return recipes;
  }

  Widget _buildDataTable() {
    List<dynamic> parsedData = jsonDecode(_jsonArray);
    String recipeType = parsedData[0]['category'];

    if (recipeType.contains('Pastry')) {
      print('Pastry Recipe Detected');
      return PastryRecipeConverter.buildPastryDataTable(parsedData);
    } else {
      print('Bread Recipe Detected');
      return BreadRecipeConverter.buildBreadDataTable(parsedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Recipe Excel'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: _pickExcelFile,
              child: Text('Select Excel File'),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Generated JSON Array:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _jsonArray.isNotEmpty
                ? SelectableText(
                    _jsonArray,
                    style: TextStyle(fontFamily: 'monospace'),
                  )
                : Text('No JSON array to display'),
            SizedBox(height: 16),
            if (_jsonArray.isNotEmpty) ...[
              _buildDataTable(),
            ],
          ],
        ),
      ),
    );
  }
}
