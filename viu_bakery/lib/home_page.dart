import 'package:flutter/material.dart';
import 'package:viu_bakery/bread_recipe_model.dart';
import 'package:viu_bakery/bread_recipe_display.dart';
import 'package:viu_bakery/bread_recipe_form.dart';
import 'package:viu_bakery/pastry_recipe_form.dart';
import 'package:viu_bakery/pastry_recipe_model.dart';
import 'package:viu_bakery/pastry_recipe_display.dart';
// import 'package:viu_bakery/cookie_recipe_form.dart';
// import 'package:viu_bakery/cookie_recipe.dart';
// import 'package:viu_bakery/cookies_recipe_display.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RecipeListScreen();
  }
}

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final List<BreadRecipe> _breadRecipes = [];
  final List<PastryRecipe> _pastryRecipes = [];
  // final List<CookieRecipe> _cookieRecipes = [];
  bool _showAddSubMenus = false;
  bool _showViewSubMenus = false;

  void _addBreadRecipe(BreadRecipe recipe) {
    setState(() {
      _breadRecipes.add(recipe);
    });
  }

  void _addPastryRecipe(PastryRecipe recipe) {
    setState(() {
      _pastryRecipes.add(recipe);
    });
  }

  // void _addCookieRecipe(CookieRecipe recipe) {
  //   setState(() {
  //     _cookieRecipes.add(recipe);
  //   });
  // }

  void _toggleAddSubMenus() {
    setState(() {
      _showAddSubMenus = !_showAddSubMenus;
    });
  }

  void _toggleViewSubMenus() {
    setState(() {
      _showViewSubMenus = !_showViewSubMenus;
    });
  }

  Widget _buildAddSubMenu() {
    if (_showAddSubMenus) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _buildButton(
                label: 'Bread Recipe',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BreadRecipeForm(onSubmit: _addBreadRecipe),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildButton(
                label: 'Pastry Recipe',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PastryRecipeForm(
                        onSubmit: _addPastryRecipe,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            // Expanded(
            //   child: _buildButton(
            //     label: 'Cookie Recipe',
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => CookieRecipeForm(
            //             onSubmit: _addCookieRecipe,
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildViewSubMenu() {
    if (_showViewSubMenus) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _buildButton(
                label: 'Bread Recipes',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BreadRecipeDisplay(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildButton(
                label: 'Pastry Recipes',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PastryRecipeDisplay(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            // Expanded(
            //   child: _buildButton(
            //     label: 'Cookie Recipes',
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => RecipeDisplayScreen<CookieRecipe>(
            //             recipes: _cookieRecipes,
            //             recipeNameGetter: (recipe) => recipe.name,
            //             recipeDisplayBuilder: (recipe) =>
            //                 CookieRecipeDisplay(recipe: recipe),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../background-assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Opacity(
          opacity: 0.9,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[900],
              ),
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'Recipes Section',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    label: 'Add a Recipe',
                    onPressed: _toggleAddSubMenus,
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: _buildAddSubMenu(),
                    crossFadeState: _showAddSubMenus
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    label: 'View Recipes',
                    onPressed: _toggleViewSubMenus,
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: _buildViewSubMenu(),
                    crossFadeState: _showViewSubMenus
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
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
        backgroundColor: Colors.orange[300],
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class RecipeDisplayScreen<T> extends StatelessWidget {
  final List<T> recipes;
  final String Function(T) recipeNameGetter;
  final Widget Function(T) recipeDisplayBuilder;

  const RecipeDisplayScreen(
      {super.key,
      required this.recipes,
      required this.recipeNameGetter,
      required this.recipeDisplayBuilder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bakery Recipes'),
        backgroundColor: Colors.orange[300],
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipeNameGetter(recipe)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => recipeDisplayBuilder(recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
