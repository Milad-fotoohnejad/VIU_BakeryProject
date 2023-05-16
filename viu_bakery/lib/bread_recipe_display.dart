import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bread_recipe_model.dart';
import 'ingredient.dart';
import 'bread_recipe_table.dart';

class BreadRecipeDisplay extends StatefulWidget {
  @override
  _BreadRecipeDisplayState createState() => _BreadRecipeDisplayState();
}

class _BreadRecipeDisplayState extends State<BreadRecipeDisplay> {
  List<BreadRecipe> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('formRecipes')
        .where('category', isEqualTo: 'Bread')
        .get();

    recipes = querySnapshot.docs.map((doc) {
      List ingredientsData = doc['ingredients'];
      List<Ingredient> ingredients = ingredientsData.map((ingredient) {
        return Ingredient(
          name: ingredient['name'],
          starterAmount: ingredient['starterAmount'],
          starterUnit: ingredient['starterUnit'],
          doughAmount: ingredient['doughAmount'],
          doughUnit: ingredient['doughUnit'],
          bakersPercentage: ingredient['bakersPercentage'],
          formula: ingredient['formula'],
        );
      }).toList();

      return BreadRecipe(
        category: doc['category'],
        name: doc['name'],
        yeild: doc['yeild'],
        ddt: doc['ddt'],
        scalingWeight: doc['scalingWeight'],
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
        title: Text('Bread Recipes'),
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
                      BreadRecipeTable(recipe: recipes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
