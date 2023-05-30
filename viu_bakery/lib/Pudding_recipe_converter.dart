

import 'package:flutter/material.dart';

class PuddingRecipeConverter {
  static Widget buildPuddingRecipeDataTable(Map<String, dynamic> parsedData) {
    try {
      Map<String, dynamic> ingredients = parsedData['ingredients'];
      Map<String, dynamic> sauceIngredients = parsedData['sauceIngredients'];
      String category = parsedData['category'];
      String name = parsedData['name'];
      String notes = parsedData['notes'];

      List<DataRow> rows = ingredients.entries.map<DataRow>((entry) {
        return DataRow(
          cells: [
            DataCell(Text(entry.key ?? '')),
            DataCell(Text(entry.value.toString())),
          ],
        );
      }).toList();

      List<DataRow> sauceRows = sauceIngredients.entries.map<DataRow>((entry) {
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Name: $name',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(thickness: 2),
              const SizedBox(height: 8),
              const Text('Ingredients', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DataTable(
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('Ingredients')),
                  DataColumn(label: Text('Qty')),
                ],
                rows: rows,
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 8),
              const Text('Sauce Ingredients', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DataTable(
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('Ingredients')),
                  DataColumn(label: Text('Qty')),
                ],
                rows: sauceRows,
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 16),
              Text(notes),
            ],
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('ERROR: $e\nStack trace: $stackTrace');
      return const SizedBox(); // Return an empty widget or handle the error accordingly
    }
  }

  static Map<String, dynamic> convertPuddingToJson(List<List<dynamic>> rows) {
    String category = rows[3][1] ?? '';
    String name = rows[5][1] ?? '';
    Map<String, double> ingredients = {};
    for (int i = 10; i < 20; i++) {
      String ingredientName = rows[i][0] ?? '';
      double quantity = double.tryParse(rows[i][1]?.toString() ?? '') ?? 0.0;
      ingredients[ingredientName] = quantity;
    }

    Map<String, double> sauceIngredients = {};
    for (int i = 22; i < 25; i++) {
      String ingredientName = rows[i][0] ?? '';
      double quantity = double.tryParse(rows[i][1]?.toString() ?? '') ?? 0.0;
      sauceIngredients[ingredientName] = quantity;
    }

    String notes = rows[32][0] ?? '';

    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
        data['name'] = name;
    data['ingredients'] = ingredients;
    data['sauceIngredients'] = sauceIngredients;
    data['notes'] = notes;

    return data;
  }
}