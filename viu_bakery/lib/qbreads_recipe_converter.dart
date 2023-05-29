import 'dart:convert';

import 'package:flutter/material.dart';

class QuickBreadsRecipeConverter {
  static Widget buildQuickBreadsDataTable(Map<String, dynamic> parsedData) {
    try {
      Map<String, dynamic> ingredients = parsedData['ingredients'];
      String category = parsedData['category'];
      String name = parsedData['name'];
      String yieldValue = parsedData['yield'].toString();
      String notes = parsedData['notes'];

      List<DataRow> rows = ingredients.entries.map<DataRow>((entry) {
        return DataRow(
          cells: [
            DataCell(Text(entry.key ?? '')),
            DataCell(Text(entry.value.toString())),
          ],
        );
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
              Divider(thickness: 2),
              SizedBox(height: 8),
              DataTable(
                columnSpacing: 24,
                columns: [
                  DataColumn(label: Text('Ingredients')),
                  DataColumn(label: Text('Qty')),
                ],
                rows: rows,
              ),
              Divider(thickness: 2),
              SizedBox(height: 16),
              Text(notes),
            ],
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('ERROR: $e\nStack trace: $stackTrace');
      return SizedBox(); // Return an empty widget or handle the error accordingly
    }
  }

  static Map<String, dynamic> convertQuickBreadsToJson(
      List<List<dynamic>> rows) {
    String category = rows[3][1] ?? '';
    String name = rows[5][1] ?? '';
    double yieldValue = double.tryParse(rows[3][5]?.toString() ?? '') ?? 0.0;
    String notes = rows[28][0] ?? '';

    Map<String, double> ingredients = {};
    for (int i = 10; i < 23; i++) {
      String ingredientName = rows[i][0] ?? '';
      double quantity = double.tryParse(rows[i][1]?.toString() ?? '') ?? 0.0;
      ingredients[ingredientName] = quantity;
    }

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = category;
    data['name'] = name;
    data['yield'] = yieldValue;
    data['ingredients'] = ingredients;
    data['notes'] = notes;

    // return json.encode(data);
    return data;
  }
}
