import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'bread_recipe_converter.dart';
import 'pastry_recipe_converter.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeUploadPage extends StatefulWidget {
  @override
  _RecipeUploadPageState createState() => _RecipeUploadPageState();
}

class _RecipeUploadPageState extends State<RecipeUploadPage> {
  String _jsonArray = '';
  bool _filePicked = false;

  Future<void> _pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      Uint8List fileBytes = result.files.single.bytes!;
      List<Map<String, dynamic>> jsonArray = _convertExcelToJson(fileBytes);
      setState(() {
        // using JsonEncoder with indentation to pretty print the JSON array
        _jsonArray = JsonEncoder.withIndent('  ').convert(jsonArray);
        _filePicked = true;
      });
    }
  }

  void uploadDataToFirestore() {
    // Assuming you're using Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<dynamic> parsedData = jsonDecode(_jsonArray);

    // Assuming 'recipes' is the collection you want to add documents to
    CollectionReference recipes = firestore.collection('recipes');

    // Add all the documents in the parsedData list to Firestore
    for (var documentData in parsedData) {
      recipes.add(documentData);
    }
  }

  List<Map<String, dynamic>> _convertExcelToJson(Uint8List bytes) {
    var decoder = SpreadsheetDecoder.decodeBytes(bytes);
    var sheet = decoder.tables.values.first;
    var rows = sheet.rows;

    List<Map<String, dynamic>> recipes = [];

    String cleanString(String input) {
      // Replace any non-printable ASCII characters
      return input.replaceAll(RegExp(r'[^\x20-\x7E]+'), '');
    }

    print('Length: ${rows[5][0]}');
    if (rows[5][0] != null &&
        cleanString(rows[5][0].toString()).contains('Pastry')) {
      recipes.add(PastryRecipeConverter.convertPastryToJson(rows));
    } else {
      recipes.add(BreadRecipeConverter.convertBreadToJson(rows));
    }

    return recipes;
  }

  Widget _buildDataTable() {
    List<dynamic> parsedData = jsonDecode(_jsonArray);
    String recipeType = parsedData[0]['category'];
    print(parsedData[0]['category']);

    if (recipeType.contains('Creams')) {
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: _pickExcelFile,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Select Excel File',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          primary: Color.fromARGB(255, 66, 66, 66),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      if (_filePicked) // Add this condition
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: TextButton(
                            onPressed:
                                uploadDataToFirestore, // call upload function when this button is pressed
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Upload Data to Database',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              primary: Color.fromARGB(255, 66, 66, 66),
                              backgroundColor: Colors.yellow[300],
                            ),
                          ),
                        ),
                      SizedBox(height: 16),
                      Text(
                        'Generated JSON Array:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      _jsonArray.isNotEmpty
                          ? Expanded(
                              child: Card(
                                color: Colors.orange[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                                    child: SelectableText(
                                      _jsonArray,
                                      style: TextStyle(fontFamily: 'monospace'),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              'No JSON array to display',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: _jsonArray.isNotEmpty
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: _buildDataTable(),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
