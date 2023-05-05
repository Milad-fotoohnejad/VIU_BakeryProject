import 'dart:convert';
import 'package:flutter/material.dart';

class BreadRecipeConverter {
  static Column buildBreadDataTable(List<dynamic> parsedData) {
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
}
