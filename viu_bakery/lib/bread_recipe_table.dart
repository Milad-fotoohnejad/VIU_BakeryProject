// bread_recipe_table.dart
import 'package:flutter/material.dart';
import 'bread_ingredient.dart';
import 'bread_recipe_model.dart';

class BreadRecipeTable extends StatelessWidget {
  final BreadRecipe recipe;

  const BreadRecipeTable({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Colors.orange[100],
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Name:', recipe.name),
                  _buildRow('Category:', recipe.category),
                  _buildRow('Yield:', recipe.yeild),
                  _buildRow('DDT:', recipe.ddt),
                  _buildRow('Scaling Weight:', recipe.scalingWeight),
                  Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    child: const Text('Ingredients:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                            decoration: TextDecoration.none)),
                  ),
                  _buildIngredientsTable(recipe.ingredients),
                  _buildTotalRow(recipe),
                  const Text('Method:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                          decoration: TextDecoration.none)),
                  _buildMethodRow(recipe.method.split('\n')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 1.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.none))),
            Expanded(
                child: Text(value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ))),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsTable(List<Ingredient> ingredients) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(width: 2.0),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                _buildTableCell('Name'),
                _buildTableCell('Starter Amount'),
                _buildTableCell('Starter Unit'),
                _buildTableCell('Dough Amount'),
                _buildTableCell('Dough Unit'),
                _buildTableCell('Bakers %'),
                _buildTableCell('Formula'),
              ],
            ),
            ...ingredients.map((ingredient) {
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
    );
  }

  Widget _buildTotalRow(BreadRecipe recipe) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 1.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            const Expanded(
                child: Text('Total Starter Amount:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.none))),
            Expanded(
                child: Text(recipe.totalStarterAmount.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ))),
            const Expanded(
                child: Text('Total Dough Amount:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.none))),
            Expanded(
                child: Text(recipe.totalDoughAmount.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ))),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildMethodRow(List<String> methodSteps) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: methodSteps
              .where((step) => step.trim().isNotEmpty)
              .map((step) => Text(step,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  )))
              .toList(),
        ),
      ),
    );
  }
}
