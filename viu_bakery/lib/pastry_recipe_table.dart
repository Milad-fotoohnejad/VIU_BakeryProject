// pastry_recipe_table.dart
import 'package:flutter/material.dart';
import 'pastry_ingredient.dart';
import 'pastry_recipe_model.dart';

class PastryRecipeTable extends StatelessWidget {
  final PastryRecipe recipe;

  PastryRecipeTable({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.orange[100],
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(8.0)),
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow('Name:', recipe.name),
                _buildRow('Category:', recipe.category),
                _buildRow('Yield:', recipe.yield),
                _buildRow('Unit Weight:', recipe.unitWeight),
                Container(
                  margin: EdgeInsets.only(top: 12.0),
                  child: Text('Ingredients:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                          decoration: TextDecoration.none)),
                ),
                _buildIngredientsTable(recipe.ingredients),
                Text('Method:',
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
    );
  }

  Widget _buildRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 1.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.none))),
            Expanded(
                child: Text(value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ))),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsTable(List<PastryIngredient> ingredients) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(width: 2.0),
          columnWidths: {
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
                _buildTableCell('Quantity'),
                _buildTableCell('Quantity Unit'),
                _buildTableCell('Multiplier'),
                _buildTableCell('Multiplier Unit'),
                _buildTableCell('Bakers %'),
              ],
            ),
            ...ingredients.map((ingredient) {
              return TableRow(
                children: [
                  _buildTableCell(ingredient.name),
                  _buildTableCell(ingredient.qty),
                  _buildTableCell(ingredient.qtyUnit),
                  _buildTableCell(ingredient.multiplier),
                  _buildTableCell(ingredient.multiplierUnit),
                  _buildTableCell(ingredient.bakersPercentage),
                ],
              );
            }).toList(),
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
        style: TextStyle(
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
                  style: TextStyle(
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
