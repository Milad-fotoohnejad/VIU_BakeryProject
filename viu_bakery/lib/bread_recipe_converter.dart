import 'dart:convert';
import 'package:flutter/material.dart';

class BreadRecipeConverter {
  static Widget buildBreadDataTable(List<dynamic> parsedData) {
    List<Map<String, dynamic>> formula =
        List<Map<String, dynamic>>.from(parsedData[0]['formula']);
    String category = parsedData[0]['category'];
    String name = parsedData[0]['name'];
    String yieldValue = parsedData[0]['yield'].toString();
    String ddt = parsedData[0]['ddt'].toString();

    List<DataRow> rows = formula.map<DataRow>((row) {
      return DataRow(
        cells: [
          DataCell(Text(row['ingredient'] ?? '')),
          DataCell(Text(row['starter'].toString())),
          DataCell(Text(row['dough'].toString())),
        ],
      );
    }).toList();

    List<Widget> methodWidgets = parsedData[0]['method']
        .map<Widget>((method) => Text(method, style: TextStyle(fontSize: 16)))
        .toList();

    return Card(
      color: Colors.orange[100],
      elevation: 2.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Category: $category',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Name: $name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Divider(thickness: 2),
            SizedBox(height: 8),
            Text('Yield: $yieldValue', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('DDT: $ddt', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Divider(thickness: 2),
            SizedBox(height: 8),
            DataTable(
              columnSpacing: 24,
              columns: [
                DataColumn(label: Text('Ingredients')),
                DataColumn(label: Text('Starter')),
                DataColumn(label: Text('Dough')),
              ],
              rows: rows,
            ),
            Divider(thickness: 2),
            SizedBox(height: 16),
            Column(children: methodWidgets),
          ],
        ),
      ),
    );
  }

  static Map<String, dynamic> convertBreadToJson(List<List<dynamic>> rows) {
    var category = rows[3][0]?.split(': ')[1] ?? '';
    var yieldValue = rows[3][5] ?? 0;
    var ddt = rows[4][4]?.split(': ')[1] ?? '0';
    var name = rows[5][0]?.split(': ')[1] ?? '';
    var scalingWeight = rows[5][4]?.split(': ')[1] ?? '0';

    var formula = <Map<String, dynamic>>[];

    for (int i = 10; i < rows.length; i++) {
      if (rows[i][0] == 'Total' || rows[i][0] == 'Method' || rows[i][0] == null)
        break;

      if (rows[i] != null && rows[i].length < 7) {
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
}
