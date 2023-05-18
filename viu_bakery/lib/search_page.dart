import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pastry_recipe_model.dart';
import 'pastry_ingredient.dart';
import 'pastry_recipe_table.dart';
import 'bread_ingredient.dart';
import 'bread_recipe_model.dart';
import 'bread_recipe_table.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  List<String> categories = ['Bread', 'Pastry'];
  List<PastryRecipe> recipes = [];
  List<BreadRecipe> breadRecipes = [];

  void onCategorySelected(String? category) {
    // Handle category selection logic
    setState(() {
      _selectedCategory = category;
    });
  }

  void onSearch() async {
    String searchString = _searchController.text;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('formRecipes')
        .where('name', isGreaterThanOrEqualTo: searchString)
        .where('category', isEqualTo: _selectedCategory)
        .get();

    if (_selectedCategory == "Pastry") {
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
    } else if (_selectedCategory == "Bread") {
      breadRecipes = querySnapshot.docs.map((doc) {
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
          yeild: doc['yield'],
          ddt: doc['ddt'],
          scalingWeight: doc['unitWeight'],
          ingredients: ingredients,
          method: doc['method'],
        );
      }).toList();
    }

    setState(() {}); // notify the UI to re-render
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipe'),
        backgroundColor: Colors.orange[300],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by recipe name',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: onSearch,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Filter by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedCategory,
              hint: Text('Select a category'),
              onChanged: onCategorySelected,
              items:
                  categories.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ListView.builder(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
