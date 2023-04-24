import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RecipeUploadPage extends StatefulWidget {
  @override
  _RecipeUploadPageState createState() => _RecipeUploadPageState();
}

class _RecipeUploadPageState extends State<RecipeUploadPage> {
  String _jsonArray = '';

  Future<void> _pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      var excel = Excel.decodeBytes(fileBytes);

      Map<String, dynamic> recipe = {
        "category": "",
        "yield": 0,
        "ddt": 0,
        "name": "",
        "scalingWeight": 0,
        "formula": [],
        "method": []
      };

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];

        // Extracting Recipe Details
        recipe["category"] = sheet!
                .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
                .value
                ?.toString() ??
            "";
        recipe["yield"] = int.tryParse(sheet
                    .cell(
                        CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1))
                    .value
                    ?.toString() ??
                "0") ??
            0;
        recipe["ddt"] = int.tryParse(sheet
                    .cell(
                        CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 2))
                    .value
                    ?.toString() ??
                "0") ??
            0;
        recipe["name"] = sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 3))
                .value
                ?.toString() ??
            "";
        recipe["scalingWeight"] = int.tryParse(sheet
                    .cell(
                        CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4))
                    .value
                    ?.toString() ??
                "0") ??
            0;

// Extracting Formula
        List<Map<String, dynamic>> formula = [];
        for (int rowIndex = 8; rowIndex <= 13; rowIndex++) {
          Map<String, dynamic> ingredient = {
            "ingredient": sheet
                    .cell(CellIndex.indexByColumnRow(
                        columnIndex: 0, rowIndex: rowIndex))
                    .value
                    ?.toString() ??
                "",
            "starter": int.tryParse(sheet
                        .cell(CellIndex.indexByColumnRow(
                            columnIndex: 1, rowIndex: rowIndex))
                        .value
                        ?.toString() ??
                    "0") ??
                0,
            "dough": int.tryParse(sheet
                        .cell(CellIndex.indexByColumnRow(
                            columnIndex: 2, rowIndex: rowIndex))
                        .value
                        ?.toString() ??
                    "0") ??
                0,
            "bakersPercentage": int.tryParse(sheet
                        .cell(CellIndex.indexByColumnRow(
                            columnIndex: 3, rowIndex: rowIndex))
                        .value
                        ?.toString() ??
                    "0") ??
                0,
            "overallFormula": int.tryParse(sheet
                        .cell(CellIndex.indexByColumnRow(
                            columnIndex: 4, rowIndex: rowIndex))
                        .value
                        ?.toString() ??
                    "0") ??
                0
          };
          if (ingredient["ingredient"].isNotEmpty) {
            formula.add(ingredient);
          }
        }
        recipe["formula"] = formula;

// Extracting Method
        List<String> method = [];
        for (int rowIndex = 16; rowIndex <= 21; rowIndex++) {
          String step = sheet
                  .cell(CellIndex.indexByColumnRow(
                      columnIndex: 1, rowIndex: rowIndex))
                  .value
                  ?.toString() ??
              "";
          if (step.isNotEmpty) {
            method.add(step);
          }
        }
        recipe["method"] = method;
      }

      setState(() {
        _jsonArray = jsonEncode([recipe]);
      });
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
          ],
        ),
      ),
    );
  }
}
