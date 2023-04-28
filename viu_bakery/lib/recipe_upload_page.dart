import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'dart:math';

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
      String jsonArray = _convertExcelToJson(fileBytes);
      setState(() {
        _jsonArray = jsonArray;
      });
    }
  }

  String _convertExcelToJson(Uint8List bytes) {
    var decoder = SpreadsheetDecoder.decodeBytes(bytes);
    var sheet = decoder.tables.values.first;
    var rows = sheet.rows;

    bool isNewType =
        rows[2][2] != null && rows[2][2].toString().contains('Pastry');
    List<Map<String, dynamic>> recipes = [];

    if (isNewType) {
      var category = rows[3][0]?.split(': ')[1]?.trim() ?? '';
      var yieldValue = rows[3][5] ?? 0;
      var name = rows[5][0]?.split(': ')[1]?.trim() ?? '';
      var unitWeight = rows[5][4]?.split(': ')[1]?.trim() ?? '';

      var formula = <Map<String, dynamic>>[];

      for (int i = 10; i < rows.length; i++) {
        if (rows[i][0] == 'Total' ||
            rows[i][0] == 'Method' ||
            rows[i][0] == null) break;

        formula.add({
          'ingredient': rows[i][0] ?? '',
          'qty': _parseCellValue(rows[i][1]) ?? 0,
          'unit': rows[i][2] ?? '',
          'bakersPercentage': _parseCellValue(rows[i][5]) ?? 0,
        });
      }

      int totalWeightRow = rows.indexWhere((row) => row[0] == 'Total');
      int totalMultiplier = _parseCellValue(rows[totalWeightRow][4]);

      int methodStartRow = rows.indexWhere((row) => row[0] == 'Method');
      var method = <String>[];

      for (int i = methodStartRow + 1; i < rows.length; i++) {
        if (rows[i] == null) break;
        if (rows[i][0] != null && rows[i][0] != '') {
          method.add(rows[i][0] ?? '');
        }
      }

      Map<String, dynamic> recipe = {
        'name':
            'Vancouver Island University Professional Baking and Pastry Arts Program',
        'recipe': {
          'name': name,
          'category': category,
          'yield': yieldValue,
          'unitWeight': unitWeight,
          'formula': formula,
          'total': {
            'weight': _parseCellValue(rows[totalWeightRow][1]),
            'multiplier': totalMultiplier,
          },
          'method': method,
        },
      };
      recipes.add(recipe);
    } else {
      var category = rows[3][0]?.split(': ')[1] ?? '';
      var yieldValue = rows[3][5] ?? 0;
      var ddt = rows[4][4]?.split(': ')[1] ?? '0';
      var name = rows[5][0]?.split(': ')[1] ?? '';
      var scalingWeight = rows[5][4]?.split(': ')[1] ?? '0';

      var formula = <Map<String, dynamic>>[];

      for (int i = 10; i < rows.length; i++) {
        if (rows[i][0] == 'Total' ||
            rows[i][0] == 'Method' ||
            rows[i][0] == null) break;

        if (rows[i].length < 7) {
          rows[i].length = 7;
          for (int j = rows[i].length; j < 7; j++) {
            rows[i].add(null);
          }
        }

        formula.add({
          'ingredient': rows[i][0] ?? '',
          'starter': rows[i][1] ?? 0,
          'dough': rows[i][3] ?? 0, // Change this from rows[i][2] to rows[i][3]
          'bakersPercentage': (rows[i][5] ?? 0) /
              100, // Change this from rows[i][4] to rows[i][5] and divide by 100
          'overallFormula': rows[i][6] ?? 0,
        });
      }

      int methodStartRow = rows.indexWhere((row) => row[0] == 'Method');
      var method = <String>[];

      for (int i = methodStartRow + 1; i < rows.length; i++) {
        if (rows[i] == null)
          break; // Add a check to see if the row starts with a number followed by a period
        if (rows[i][0] != null &&
            rows[i][0] != '' &&
            RegExp(r'^\d+\.\s').hasMatch(rows[i][0])) {
          method.add(rows[i][0] ?? '');
        }
      }

      Map<String, dynamic> recipe = {
        'category': category,
        'yield': yieldValue,
        'ddt': ddt,
        'name': name,
        'scalingWeight': scalingWeight,
        'formula': formula,
        'method': method,
      };
      recipes.add(recipe);
    }
    return jsonEncode(recipes);
  }

  dynamic _parseCellValue(dynamic value) {
    try {
      return double.parse(value.toString());
    } catch (e) {
      return value;
    }
  }

  Widget _buildTable(String jsonArray) {
    List<dynamic> data = jsonDecode(jsonArray);
    List<dynamic> formula = data[0]['formula'];
    List<dynamic> method = data[0]['method'];

    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: [
        // Header row
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Ingredients',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Method',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        // Data rows
        ...List<TableRow>.generate(
          max(formula.length, method.length),
          (index) => TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: index < formula.length
                      ? Text(
                          '${formula[index]['ingredient']}: ${formula[index]['overallFormula']}')
                      : SizedBox(),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                      index < method.length ? Text(method[index]) : SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
              SizedBox(height: 16),
              Text(
                'Method:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildMethodList(),
            ],
          ],
        ),
      ),
    );
  }

  Column _buildDataTable() {
    List<dynamic> parsedData = jsonDecode(_jsonArray);
    List<Map<String, dynamic>> formula =
        List<Map<String, dynamic>>.from(parsedData[0]['formula']);
    String category = parsedData[0]['category'];
    String name = parsedData[0]['name'];

    List<DataRow> rows = formula.map<DataRow>((row) {
      return DataRow(
        cells: [
          DataCell(Text(row['ingredient'])),
          DataCell(Text(row['starter'].toString())),
          DataCell(Text(row['dough'].toString())),
        ],
      );
    }).toList();

    return Column(
      children: [
        DataTable(
          columnSpacing: 24,
          columns: [
            DataColumn(label: Text('Category: $category')),
            DataColumn(label: Text('Name: $name')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Yield: ${parsedData[0]['yield']}')),
              DataCell(Text('DDT: ${parsedData[0]['ddt']}')),
            ]),
            DataRow(cells: [
              DataCell(
                  Text('Scaling Weight: ${parsedData[0]['scalingWeight']}')),
              DataCell(Text('')),
            ]),
          ],
        ),
        SizedBox(height: 16),
        DataTable(
          columnSpacing: 24,
          columns: [
            DataColumn(label: Text('Ingredients')),
            DataColumn(label: Text('Starter')),
            DataColumn(label: Text('Dough')),
          ],
          rows: rows,
        ),
      ],
    );
  }

  Widget _buildMethodList() {
    List<dynamic> parsedData = jsonDecode(_jsonArray);
    List<String> method = List<String>.from(parsedData[0]['method']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: method.map<Widget>((item) {
        return Text(item);
      }).toList(),
    );
  }
}
