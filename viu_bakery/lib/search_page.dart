import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pastry_recipe_model.dart';
import 'pastry_recipe_table.dart';
import 'bread_recipe_table.dart';
import 'bread_recipe_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

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

    onSearch();
  }

  void onSearch() async {
    String searchString = _searchController.text;
    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('formRecipes')
        .where('name', isGreaterThanOrEqualTo: searchString)
        .where('category', isEqualTo: _selectedCategory)
        .get();

    // Query on 'recipes' collection
    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('recipes')
        .where('name', isGreaterThanOrEqualTo: searchString)
        .where('category', isEqualTo: _selectedCategory)
        .get();

    // Combine results from both collections
    List<QueryDocumentSnapshot> allResults = [];
    allResults.addAll(querySnapshot1.docs);
    allResults.addAll(querySnapshot2.docs);

    // Clear the previous search results.
    recipes.clear();
    breadRecipes.clear();

    // Loop through the documents in the query snapshot.
    for (var doc in querySnapshot1.docs) {
      var data = doc.data();
      // Only process the document if it contains data.
      if (data != null) {
        // Check if the document is a pastry recipe or bread recipe and add it to the respective list.
        if (_selectedCategory == 'Pastry') {
          recipes.add(PastryRecipe.fromJson(data as Map<String, dynamic>));
        } else if (_selectedCategory == 'Bread') {
          breadRecipes.add(BreadRecipe.fromJson(data as Map<String, dynamic>));
        }
      }
    }

    // Notify the UI to re-render with the new search results.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipe'),
        backgroundColor: Colors.orange[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by recipe name',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: onSearch,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Filter by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: _selectedCategory,
                hint: const Text('Select a category'),
                onChanged: onCategorySelected,
                items:
                    categories.map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: _selectedCategory == "Pastry"
                    ? recipes.isEmpty
                        ? Center(
                            child: Text(
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                                "There are no results to show yet!"))
                        : ListView.builder(
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              PastryRecipe recipe = recipes[index];
                              return ListTile(
                                title: Text(recipe.name),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PastryRecipeTable(recipe: recipe),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                    : breadRecipes.isEmpty
                        ? Center(
                            child: Text(
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                                "There are no results to show yet!"))
                        : ListView.builder(
                            itemCount: breadRecipes.length,
                            itemBuilder: (context, index) {
                              BreadRecipe recipe = breadRecipes[index];
                              return ListTile(
                                title: Text(recipe.name),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BreadRecipeTable(recipe: recipe),
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
