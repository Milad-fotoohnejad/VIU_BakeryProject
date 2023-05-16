// bread_recipe_table.dart

import 'package:flutter/material.dart';
import 'ingredient.dart';
import 'bread_recipe_model.dart';

class BreadRecipeTable extends StatelessWidget {
  final BreadRecipe recipe;

  BreadRecipeTable({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Yield')),
          DataColumn(label: Text('DDT')),
          DataColumn(label: Text('Scaling Weight')),
          DataColumn(label: Text('Ingredients')),
          DataColumn(label: Text('Method')),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(Text(recipe.name)),
              DataCell(Text(recipe.yeild)),
              DataCell(Text(recipe.ddt)),
              DataCell(Text(recipe.scalingWeight)),
              DataCell(_buildIngredientsCell(recipe.ingredients)),
              DataCell(Text(recipe.method)),
            ],
          ),
        ],
      ),
    );
  }

  // This function is used to create a Widget that can display a list of ingredients in a single cell.
  Widget _buildIngredientsCell(List<Ingredient> ingredients) {
    return Container(
      child: Column(
        children: ingredients.map((ingredient) {
          return Text(
            '${ingredient.name} - ${ingredient.starterAmount} ${ingredient.starterUnit} - ${ingredient.doughAmount} ${ingredient.doughUnit} - ${ingredient.bakersPercentage} - ${ingredient.formula}',
          );
        }).toList(),
      ),
    );
  }
}
