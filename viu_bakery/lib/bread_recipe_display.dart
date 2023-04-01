import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < recipe.ingredients.length; i++) ...[
                if (i == 0) _buildHeaderRow(),
                _buildDataRow(i),
                if (i < recipe.ingredients.length - 1)
                  Divider(height: 1, thickness: 1),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add the recipe to Firestore
          await recipe.addToFirestore();

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Recipe added to Firestore!'),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Expanded(child: Text('')),
        Expanded(child: Text('Ingredients')),
        Expanded(child: Text('Amount')),
        Expanded(child: Text('Starter')),
        Expanded(child: Text('Poolish')),
        Expanded(child: Text('Dough')),
        Expanded(child: Text("Bakers'")),
        Expanded(child: Text('Formula')),
      ],
    );
  }

  Widget _buildDataRow(int i) {
    return Container(
      color: i % 2 == 0 ? Colors.white : Colors.grey[100],
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text((i + 1).toString())),
          Expanded(child: Text(recipe.ingredients[i].name)),
          Expanded(child: Text(recipe.ingredients[i].amount)),
          Expanded(child: i == 0 ? Text(recipe.starter) : Text('')),
          Expanded(child: i == 0 ? Text(recipe.poolish) : Text('')),
          Expanded(child: i == 0 ? Text(recipe.dough) : Text('')),
          Expanded(child: i == 0 ? Text(recipe.bakersPercentage) : Text('')),
          Expanded(child: i == 0 ? Text(recipe.formula) : Text('')),
        ],
      ),
    );
  }
}
