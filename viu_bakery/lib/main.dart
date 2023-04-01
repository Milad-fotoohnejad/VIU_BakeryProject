import 'package:flutter/material.dart';
import 'bread_recipe.dart';
import 'bread_recipe_display.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bakery Recipes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with actual data loaded from Firestore.
    BreadRecipe sampleRecipe = BreadRecipe(
      name: 'Sample Bread',
      ingredients: [
        Ingredient(name: 'Flour', amount: '500g'),
        Ingredient(name: 'Water', amount: '350g'),
        Ingredient(name: 'Salt', amount: '10g'),
        Ingredient(name: 'Yeast', amount: '5g'),
      ],
      starter: '100g',
      poolish: '450g',
      dough: '1000g',
      bakersPercentage: '70%',
      formula: 'Basic Formula',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Bakery Recipes'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(sampleRecipe.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BreadRecipeDisplay(recipe: sampleRecipe),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
