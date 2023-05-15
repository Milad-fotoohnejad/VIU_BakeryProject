import 'dart:convert';
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
      List<Map<String, dynamic>> jsonArray = _convertExcelToJson(fileBytes);
      setState(() {
        _jsonArray = jsonEncode(jsonArray);
      });
    }
  }

  Map<String, String> _parseTitleCell(String cellValue) {
    final parts = cellValue.split(': ');
    return {
      'name': parts[0].trim(),
      'value': parts.length > 1 ? parts[1].trim() : '',
    };
  }

  int _findFirstRowIndex(
      List<List<dynamic>> rows, bool Function(dynamic) condition) {
    for (int i = 0; i < rows.length; i++) {
      if (condition(rows[i][0])) return i;
    }
    return -1;
  }

  Map<String, dynamic> _convertPastryToJson(List<List<dynamic>> rows) {
    Map<String, dynamic> recipe = {};

    int ingredientsStartRow = 9;
    int methodStartRow = 26;

    for (int i = 0; i < rows.length; i++) {
      if (rows[i][0] != null && rows[i][0].toString().contains('Pastry')) {
        recipe = {
          'name': rows[5][0].toString().split(': ')[1].trim(),
          'category': rows[3][0].toString().split(': ')[1].trim(),
          'yield': rows[3][5],
          'unitWeight': rows[5][4].toString().split(': ')[1].trim(),
        };

        List<Map<String, dynamic>> formula = [];
        for (int j = ingredientsStartRow; j < methodStartRow - 1; j++) {
          if (rows[j][0] != null) {
            formula.add({
              'ingredients': rows[j][0],
              'qty': rows[j][1],
              'QUnit': rows[j][2],
              'multiplier': rows[j][3],
              'MUnit': rows[j][4],
              'bakersPercentage': (rows[j][4] * 100).toDouble()
            });
          }
        }
        recipe['formula'] = formula;

        List<String> method = [];
        for (int j = methodStartRow; j < rows.length; j++) {
          if (rows[j][0] != null) {
            method.add(rows[j][0]);
          }
        }
        recipe['method'] = method;

        Map<String, dynamic> total = {
          'weight': rows[ingredientsStartRow - 1][1],
          'multiplier': rows[ingredientsStartRow - 1][3]
        };
        recipe['total'] = total;
      }
    }
    return recipe;
  }

  Map<String, dynamic> _convertBreadToJson(List<List<dynamic>> rows) {
    var category = rows[3][0]?.split(': ')[1] ?? '';
    var yieldValue = rows[3][5] ?? 0;
    var ddt = rows[4][4]?.split(': ')[1] ?? '0';
    var name = rows[5][0]?.split(': ')[1] ?? '';
    var scalingWeight = rows[5][4]?.split(': ')[1] ?? '0';

    var formula = <Map<String, dynamic>>[];

    for (int i = 10; i < rows.length; i++) {
      if (rows[i][0] == 'Total' || rows[i][0] == 'Method' || rows[i][0] == null)
        break;

      if (rows[i].length < 7) {
        rows[i].length = 7;
        for (int j = rows[i].length; j < 7; j++) {
          rows[i].add(null);
        }
      }

      formula.add({
        'ingredient': rows[i][0] ?? '',
        'starter': rows[i][1] ?? 0,
        'dough': rows[i][3] ?? 0,
        'bakersPercentage': (rows[i][5] ?? 0) / 100,
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

    return {
      'category': category,
      'yield': yieldValue,
      'ddt': ddt,
      'name': name,
      'scalingWeight': scalingWeight,
      'formula': formula,
      'method': method,
    };
  }

  List<Map<String, dynamic>> _convertExcelToJson(Uint8List bytes) {
    var decoder = SpreadsheetDecoder.decodeBytes(bytes);
    var sheet = decoder.tables.values.first;
    var rows = sheet.rows;

    bool pastryType = rows[1]
        .any((cell) => cell != null && cell.toString().contains('Pastry'));

    List<Map<String, dynamic>> recipes = [];

    if (pastryType) {
      recipes.add(_convertPastryToJson(rows));
    } else {
      recipes.add(_convertBreadToJson(rows));
    }

    return recipes;
  }

  Widget _buildDataTable() {
    List<dynamic> parsedData = jsonDecode(_jsonArray);
    String recipeType = parsedData[0]['category'];

    if (recipeType.contains('Pastry')) {
      return _buildPastryDataTable(parsedData);
    } else {
      return _buildBreadDataTable(parsedData);
    }
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
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Ingredients',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Method',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
        // Data rows
        ...List<TableRow>.generate(
          max(formula.length, method.length),
          (index) => TableRow(
            decoration: BoxDecoration(
              color: index % 2 == 0 ? Colors.grey.shade100 : Colors.white,
            ),
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: index < formula.length
                      ? Text(
                          '${formula[index]['ingredient']}: ${formula[index]['dough']}')
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

  Column _buildPastryDataTable(List<dynamic> parsedData) {
    List<Map<String, dynamic>> formula =
        List<Map<String, dynamic>>.from(parsedData[0]['formula']);
    String category = parsedData[0]['category'];
    String name = parsedData[0]['name'];

    List<DataRow> rows = formula.map<DataRow>((row) {
      return DataRow(
        cells: [
          DataCell(Text(row['ingredient'])),
          DataCell(Text(row['qty'].toString())),
          DataCell(Text(row['QUnit'])),
          DataCell(Text(row['multiplier'].toString())),
          DataCell(Text(row['MUnit'])),
          DataCell(Text((row['bakersPercentage'] ?? 0).toString())),
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
              DataCell(Text('Unit Weight: ${parsedData[0]['unitWeight']}')),
            ]),
          ],
        ),
        SizedBox(height: 16),
        DataTable(
          columnSpacing: 24,
          columns: [
            DataColumn(label: Text('Ingredients')),
            DataColumn(label: Text('Qty')),
            DataColumn(label: Text('Unit')),
            DataColumn(label: Text('Multiplier')),
            DataColumn(label: Text('Unit')),
            DataColumn(label: Text('Bakers Percentage')),
          ],
          rows: rows,
        ),
      ],
    );
  }

  Column _buildBreadDataTable(List<dynamic> parsedData) {
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
      children: method
          .asMap()
          .map(
            (index, item) => MapEntry(
              index,
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '$item',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
