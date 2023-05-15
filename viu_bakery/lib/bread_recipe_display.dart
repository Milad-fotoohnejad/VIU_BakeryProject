import 'package:flutter/material.dart';
import 'bread_recipe_model.dart';

class BreadRecipeDisplay extends StatelessWidget {
  final BreadRecipe recipe;

  const BreadRecipeDisplay({required this.recipe});

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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'Ingredients',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1),
                    6: FlexColumnWidth(1),
                  },
                  border: TableBorder.all(color: Colors.lightBlue[100]!),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.orange[300],
                      ),
                      children: [
                        _buildTableHeader('Ingredient Name'),
                        _buildTableHeader('Starter Amount'),
                        _buildTableHeader('Starter Unit'),
                        _buildTableHeader('Dough Amount'),
                        _buildTableHeader('Dough Unit'),
                        _buildTableHeader('Bakers Percentage'),
                        _buildTableHeader('Formula'),
                      ],
                    ),
                    ...recipe.ingredients.map((ingredient) {
                      return TableRow(
                        children: [
                          _buildTableCell(ingredient.name),
                          _buildTableCell(ingredient.starterAmount),
                          _buildTableCell(ingredient.starterUnit),
                          _buildTableCell(ingredient.doughAmount),
                          _buildTableCell(ingredient.doughUnit),
                          _buildTableCell(ingredient.bakersPercentage),
                          _buildTableCell(ingredient.formula),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Method',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // Add your method data here
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
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
