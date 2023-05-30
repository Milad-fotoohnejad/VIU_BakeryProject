
import 'package:flutter/material.dart';

class MiscellaneousRecipeConverter {
  static Widget buildMiscellaneousDataTable(Map<String, dynamic> parsedData) {
    try {
      Map<String, dynamic> ingredients = parsedData['ingredients'];
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
              DataTable(
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('Ingredients')),
                  DataColumn(label: Text('Qty')),
                ],
                rows: rows,
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

  static Map<String, dynamic> MiscellaneousToJson(List<List<dynamic>> rows) {
    String category = rows[3][1] ?? '';
    int test = 5;
    String name = rows[5][1] ?? '';
    Map<String, double> ingredients = {};
    for (int i = 10; i < 14; i++) {
      String ingredientName = rows[i][0] ?? '';
      double quantity = double.tryParse(rows[i][1]?.toString() ?? '') ?? 0.0;
      ingredients[ingredientName] = quantity;
    }

    String notes = rows[29][0] ?? '';

    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['name'] = name;
    data['ingredients'] = ingredients;
    data['notes'] = notes;

    return data;
  }
}
