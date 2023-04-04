import 'package:flutter/material.dart';
import 'package:viu_bakery/bread_recipe.dart';
import 'package:viu_bakery/bread_recipe_display.dart';
import 'package:viu_bakery/bread_recipe_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bakery Recipes',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final List<BreadRecipe> _recipes = [];

  void _addRecipe(BreadRecipe recipe) {
    setState(() {
      _recipes.add(recipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bakery Recipes'),
        backgroundColor: Colors.orange[300],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../background-assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[800],
            ),
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Recipes Section',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildButton(
                  label: 'Add Recipe',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BreadRecipeForm(onSubmit: _addRecipe),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                _buildButton(
                  label: 'View Recipes',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDisplayScreen(recipes: _recipes),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.orange[300],
        padding: EdgeInsets.symmetric(vertical: 16),
        textStyle: TextStyle(fontSize: 18),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class RecipeDisplayScreen extends StatelessWidget {
  final List<BreadRecipe> recipes;

  RecipeDisplayScreen({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bakery Recipes'),
        backgroundColor: Colors.orange[300],
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BreadRecipeDisplay(recipe: recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
