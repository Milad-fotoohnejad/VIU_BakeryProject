// Import the required packages and files
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pastry_recipe_model.dart';
import 'pastry_ingredient.dart';
import 'pastry_recipe_table.dart';

class PastryRecipeDisplay extends StatefulWidget {
  @override
  _PastryRecipeDisplayState createState() => _PastryRecipeDisplayState();
}

class _PastryRecipeDisplayState extends State<PastryRecipeDisplay> {
  List<PastryRecipe> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('formRecipes')
        .where('category', isEqualTo: 'Pastry')
        .get();

    recipes = querySnapshot.docs.map((doc) {
      List ingredientsData = doc['ingredients'];
      List<PastryIngredient> ingredients = ingredientsData.map((ingredient) {
        return PastryIngredient(
          name: ingredient['name'],
          qty: ingredient['qty'],
          qtyUnit: ingredient['qtyUnit'],
          multiplier: ingredient['multiplier'],
          multiplierUnit: ingredient['multiplierUnit'],
          bakersPercentage: ingredient['bakersPercentage'],
        );
      }).toList();

      return PastryRecipe(
        category: doc['category'],
        name: doc['name'],
        yield: doc['yield'],
        unitWeight: doc['unitWeight'],
        ingredients: ingredients,
        method: doc['method'],
      );
    }).toList();

    setState(() {}); // notify the UI to re-render
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pastry Recipes'),
        backgroundColor: Colors.orange[300],
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recipes[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PastryRecipeTable(recipe: recipes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
