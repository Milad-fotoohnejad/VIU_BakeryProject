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

      List<Map<String, dynamic>> jsonArray = [];

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        List<String> headers = [];

        for (int rowIndex = 0; rowIndex < sheet!.maxRows; rowIndex++) {
          if (rowIndex == 0) {
            for (int colIndex = 0; colIndex < sheet.maxCols; colIndex++) {
              headers.add(sheet
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: colIndex, rowIndex: rowIndex))
                      .value
                      ?.toString() ??
                  "");
            }
          } else {
            Map<String, dynamic> jsonObject = {};

            for (int colIndex = 0; colIndex < sheet.maxCols; colIndex++) {
              String header = headers[colIndex];
              String value = sheet
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: colIndex, rowIndex: rowIndex))
                      .value
                      ?.toString() ??
                  "";
              jsonObject[header] = value;
            }

            jsonArray.add(jsonObject);
          }
        }
      }

      setState(() {
        _jsonArray = jsonEncode(jsonArray);
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
