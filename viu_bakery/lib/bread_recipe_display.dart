import 'package:flutter/material.dart';
import 'bread_recipe.dart';

class BreadRecipeDisplay extends StatelessWidget {
  final BreadRecipe recipe;

  BreadRecipeDisplay({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Table(
          defaultColumnWidth: IntrinsicColumnWidth(),
          border: TableBorder.all(color: Colors.grey[300]!),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: [
                _buildHeaderCell('Ingredients'),
                _buildHeaderCell('Amount'),
                _buildHeaderCell('Starter'),
                _buildHeaderCell('Poolish'),
                _buildHeaderCell('Dough'),
                _buildHeaderCell("Bakers'"),
                _buildHeaderCell('Formula'),
              ],
            ),
            for (int i = 0; i < recipe.ingredients.length; i++)
              TableRow(
                decoration: BoxDecoration(
                  color: i % 2 == 0 ? Colors.white : Colors.grey[100],
                ),
                children: [
                  _buildDataCell(recipe.ingredients[i].name),
                  _buildDataCell(recipe.ingredients[i].amount),
                  i == 0 ? _buildDataCell(recipe.starter) : _buildDataCell(''),
                  i == 0 ? _buildDataCell(recipe.poolish) : _buildDataCell(''),
                  i == 0 ? _buildDataCell(recipe.dough) : _buildDataCell(''),
                  i == 0
                      ? _buildDataCell(recipe.bakersPercentage)
                      : _buildDataCell(''),
                  i == 0 ? _buildDataCell(recipe.formula) : _buildDataCell(''),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Text(text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildDataCell(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Text(text, style: TextStyle(fontSize: 16)),
    );
  }
}
