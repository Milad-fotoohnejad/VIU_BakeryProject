import 'package:flutter/material.dart';
import 'package:viu_bakery/cookie_recipe.dart';

class CookieRecipeDisplay extends StatelessWidget {
  final CookieRecipe recipe;

  const CookieRecipeDisplay({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Colors.orange[300],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Ingredients',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                  },
                  border: TableBorder.all(color: Colors.lightBlue[100]!),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.orange[300],
                      ),
                      children: [
                        _buildTableHeader('Ingredient Name'),
                        _buildTableHeader('Ingredient Amount'),
                      ],
                    ),
                    ...recipe.ingredients.map((ingredient) {
                      return TableRow(
                        children: [
                          _buildTableCell(ingredient.name),
                          _buildTableCell(ingredient.amount),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoSection('Method', recipe.method),
              _buildInfoSection('Baking Time', recipe.bakingTime),
              _buildInfoSection('Yield', recipe.yield),
              _buildInfoSection('Instructions', recipe.instructions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildInfoSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
