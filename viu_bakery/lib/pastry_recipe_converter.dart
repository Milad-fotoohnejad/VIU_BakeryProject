import 'package:flutter/material.dart';

class PastryRecipeConverter {
  static Widget buildPastryDataTable(List<dynamic> parsedData) {
    List<Map<String, dynamic>> formula =
        List<Map<String, dynamic>>.from(parsedData[0]['formula']);
    String category = parsedData[0]['category'];
    String name = parsedData[0]['name'];
    String yieldValue = parsedData[0]['yield'].toString();
    String unitWeight = parsedData[0]['unitWeight']?.toString() ?? '';
    List<String> method = List<String>.from(parsedData[0]['method']);

    List<DataRow> rows = formula.map<DataRow>((row) {
      return DataRow(
        cells: [
          DataCell(Text(row['ingredients'] ?? '')),
          DataCell(Text(row['qty'].toString())),
          DataCell(Text(row['QUnit'] ?? '')),
          DataCell(Text(row['multiplier'].toString())),
          DataCell(Text(row['MUnit'] ?? '')),
          DataCell(Text(row['bakersPercentage'] ?? '')),
        ],
      );
    }).toList();

    List<Widget> methodWidgets = method.map<Widget>((item) {
      return Text(item);
    }).toList();

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
            Text('Unit Weight: $unitWeight', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Divider(thickness: 2),
            SizedBox(height: 8),
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
            Divider(thickness: 2),
            SizedBox(height: 16),
            Column(children: methodWidgets),
          ],
        ),
      ),
    );
  }

  static Map<String, dynamic> convertPastryToJson(List<List<dynamic>> rows) {
    Map<String, dynamic> recipe = {};

    int ingredientsStartRow = 9;
    int methodStartRow = 26;

    for (int i = 0; i < rows.length; i++) {
      if (rows[i][0] != null && rows[i][0].toString().contains('Pastry')) {
        recipe = {
          'name': rows[5][0].toString().split(': ').length > 1
              ? rows[5][0].toString().split(': ')[1].trim()
              : '',
          'category': rows[3][0].toString().split(': ').length > 1
              ? rows[3][0].toString().split(': ')[1].trim()
              : '',
          'yield': rows[3][5] ?? 0,
          'unitWeight': rows[5][4].toString().split(': ').length > 1
              ? rows[5][4].toString().split(': ')[1].trim()
              : '',
        };

        List<Map<String, dynamic>> formula = [];
        for (int j = ingredientsStartRow; j < methodStartRow - 1; j++) {
          if (rows[j][0] != null) {
            String bakersPercentage = '0%';
            if (rows[j][5] != null &&
                double.tryParse(rows[j][5].toString()) != null) {
              bakersPercentage = (double.parse(rows[j][5].toString()) * 100)
                      .toStringAsFixed(2) +
                  '%';
            }

            formula.add({
              'ingredients': rows[j][0] ?? '',
              'qty': rows[j][1] ?? 0,
              'QUnit': rows[j][2] ?? '',
              'multiplier': rows[j][3] ?? 0,
              'MUnit': rows[j][4] ?? '',
              'bakersPercentage': bakersPercentage,
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
          'weight': rows[ingredientsStartRow - 1][1] ?? 0,
          'multiplier': rows[ingredientsStartRow - 1][3] ?? 0
        };
        recipe['total'] = total;
      }
    }
    return recipe;
  }
}
