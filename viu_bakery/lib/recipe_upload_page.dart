import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'bread_recipe_converter.dart';
import 'pastry_recipe_converter.dart';
import 'cakes_fillings_recipe_converter.dart';
import 'package:flutter/services.dart';
import 'Miscellaneous_recipe_converter.dart';
import 'Pudding_recipe_converter.dart';
import 'cookies_recipe_converter.dart';
import 'qbreads_recipe_converter.dart';
import 'savoury_recipe_converter.dart';
import 'sweet_recipe_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeUploadPage extends StatefulWidget {
  const RecipeUploadPage({super.key});

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
        _jsonArray = const JsonEncoder.withIndent('  ').convert(jsonArray);
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
    print('Length: ${rows[1][3]}'); // print value of cell [1][3]

    // Check cell [5][0] for 'Pastry'
    if (rows[5][0] != null &&
        cleanString(rows[5][0].toString()).contains('Pastry')) {
      recipes.add(PastryRecipeConverter.convertPastryToJson(rows));
    } else if (rows[3][1] != null &&
        cleanString(rows[3][1].toString()).contains('Cakes')) {
      recipes
          .add(CakesFillingsRecipeConverter.convertCakesFillingsToJson(rows));
    } else if (rows[3][1] != null &&
        cleanString(rows[3][1].toString()).contains('Miscellaneous')) {
      recipes.add(MiscellaneousRecipeConverter.MiscellaneousToJson(rows));
    } else if (rows[3][1] != null &&
        cleanString(rows[3][1].toString())
            .contains('Custards Puddings and Mousses')) {
      recipes.add(PuddingRecipeConverter.convertPuddingToJson(rows));
    } else if (rows[3][1] != null &&
        cleanString(rows[3][1].toString()).contains('Cookies')) {
      recipes.add(CookiesRecipeConverter.convertCookiesToJson(rows));
    } else if (rows[3][1] != null &&
        cleanString(rows[3][1].toString()).contains('Quick Breads')) {
      recipes.add(QuickBreadsRecipeConverter.convertQuickBreadsToJson(rows));
    } else if (rows[3][1] != null &&
        cleanString(rows[3][1].toString())
            .contains('Savoury & Misc. Yeasted')) {
      recipes.add(SavouryRecipeConverter.convertSavouryToJson(rows));
    } else if (rows[3][1] != null &&
        cleanString(rows[3][1].toString()).contains('Sweet Yeasted')) {
      recipes.add(SweetYeastedRecipeConverter.convertSweetYeastedToJson(rows));
    }

    // If neither cell [5][0] is 'Pastry' nor cell [1][3] is 'Cakes', assume it's a bread recipe
    else {
      recipes.add(BreadRecipeConverter.convertBreadToJson(rows));
    }

    return recipes;
  }

  Widget _buildDataTable() {
    List<dynamic> parsedDataList = jsonDecode(_jsonArray);

    if (parsedDataList.isNotEmpty) {
      String recipeType = parsedDataList[0]['category'];
      print(parsedDataList[0]['category']);

      if (recipeType.contains('Creams')) {
        print('Pastry Recipe Detected');
        return PastryRecipeConverter.buildPastryDataTable(parsedDataList);
      } else if (recipeType.contains('Cakes')) {
        print('Cake Recipe Detected');
        // Pass the first recipe map in the list to the CakesFillingsRecipeConverter
        return CakesFillingsRecipeConverter.buildCakesFillingsDataTable(
            parsedDataList[0]);
      } else if (recipeType.contains('Miscellaneous')) {
        print('Miscellaneous Recipe Detected');
        return MiscellaneousRecipeConverter.buildMiscellaneousDataTable(
            parsedDataList[0]);
      } else if (recipeType.contains('Custards Puddings and Mousses')) {
        print('Custards Puddings and Mousses Recipe Detected');
        return PuddingRecipeConverter.buildPuddingRecipeDataTable(
            parsedDataList[0]);
      } else if (recipeType.contains('Category: Cookies & Bars')) {
        print('Cookies & Bars Recipe Detected');
        return CookiesRecipeConverter.buildCookiesDataTable(parsedDataList[0]);
      } else if (recipeType.contains('Quick Breads')) {
        print('Quick Breads Detected');
        return QuickBreadsRecipeConverter.buildQuickBreadsDataTable(
            parsedDataList[0]);
      } else if (recipeType.contains('Savoury & Misc. Yeasted')) {
        print('Savoury & Misc. Yeasted Detected');
        return SavouryRecipeConverter.buildSavouryDataTable(parsedDataList[0]);
      } else if (recipeType.contains('Sweet Yeasted')) {
        print('Sweet Yeasted Detected');
        return SweetYeastedRecipeConverter.buildSweetYeastedDataTable(
            parsedDataList[0]);
      } else {
        print('Bread Recipe Detected');
        return BreadRecipeConverter.buildBreadDataTable(parsedDataList);
      }
    } else {
      return const SizedBox(); // Return an empty widget if the parsed data list is empty
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Recipe Excel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: _pickExcelFile,
                        style: TextButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 66, 66, 66),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Select Excel File',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      if (_filePicked)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: TextButton(
                            onPressed: uploadDataToFirestore,
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 66, 66, 66),
                              backgroundColor: Colors.yellow[300],
                            ), // call upload function when this button is pressed
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Upload Data to Database',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        'Generated JSON Array:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _jsonArray.isNotEmpty
                          ? Expanded(
                              child: Card(
                                color: Colors.orange[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                                    child: SelectableText(
                                      _jsonArray,
                                      style: const TextStyle(
                                          fontFamily: 'monospace'),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const Text(
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
            const SizedBox(width: 16),
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
