import 'package:flutter/material.dart';
import 'package:viu_bakery/bread_ingredient.dart';
import 'bread_recipe_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BreadRecipeForm extends StatefulWidget {
  final Function(BreadRecipe) onSubmit;

  const BreadRecipeForm({super.key, required this.onSubmit});

  @override
  _BreadRecipeFormState createState() => _BreadRecipeFormState();
}

class _BreadRecipeFormState extends State<BreadRecipeForm> {
  bool _isSubmitting = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BreadRecipe _recipe = BreadRecipe(
    category: '',
    name: '',
    yeild: '',
    ddt: '',
    scalingWeight: '',
    ingredients: [],
    method: '',
  );

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yeildController = TextEditingController();
  final TextEditingController _ddtController = TextEditingController();
  final TextEditingController _scalingWeightController =
      TextEditingController();
  final TextEditingController _methodController = TextEditingController();

  final List<List<String>> _ingredients = [
    ['', '', '', '', '', '', ''],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bread Recipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Recipe Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe category';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Recipe Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _yeildController,
                  decoration: const InputDecoration(labelText: 'Recipe Yeild'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe yeild';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ddtController,
                  decoration: const InputDecoration(labelText: 'Recipe DDT'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe DDT';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _scalingWeightController,
                  decoration:
                      const InputDecoration(labelText: 'Recipe Scaling Weight'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe scaling weight';
                    }
                    return null;
                  },
                ),
                ..._buildIngredientsList(),
                _buildAddIngredientButton(),
                _buildOtherFields(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: const Text('Save Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIngredientsList() {
    return _ingredients.map((ingredient) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => ingredient[0] = value,
              decoration: const InputDecoration(labelText: 'Ingredient Name'),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) {
                ingredient[1] = value;
                setState(() {});
              },
              decoration: const InputDecoration(labelText: 'Starter Amount'),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) => ingredient[2] = value,
              decoration: const InputDecoration(labelText: 'Starter Unit'),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) {
                ingredient[3] = value;
                setState(() {});
              },
              decoration: const InputDecoration(labelText: 'Dough Amount'),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) => ingredient[4] = value,
              decoration: const InputDecoration(labelText: 'Dough Unit'),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) => ingredient[5] = value,
              decoration: const InputDecoration(labelText: 'Bakers %'),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) => ingredient[6] = value,
              decoration: const InputDecoration(labelText: 'Formula'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _ingredients.remove(ingredient);
              });
            },
          ),
        ],
      );
    }).toList();
  }

  Widget _buildAddIngredientButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        setState(() {
          _ingredients.add(['', '', '', '', '', '', '']);
        });
      },
    );
  }

  double calculateTotalStarterAmount() {
    double totalStarterAmount = 0;
    for (List<String> ingredient in _ingredients) {
      String starterAmount = ingredient[1];
      if (starterAmount.isNotEmpty) {
        totalStarterAmount += double.tryParse(starterAmount) ?? 0;
      }
    }
    return totalStarterAmount;
  }

  double calculateTotalDoughAmount() {
    double totalDoughAmount = 0;
    for (List<String> ingredient in _ingredients) {
      String doughAmount = ingredient[3];
      if (doughAmount.isNotEmpty) {
        totalDoughAmount += double.tryParse(doughAmount) ?? 0;
      }
    }
    return totalDoughAmount;
  }

  Widget _buildOtherFields() {
    return Column(
      children: [
        TextFormField(
          controller: _methodController,
          decoration: const InputDecoration(labelText: 'Method'),
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      _recipe.name = _nameController.text;
      _recipe.category = _categoryController.text;
      _recipe.yeild = _yeildController.text;
      _recipe.ddt = _ddtController.text;
      _recipe.scalingWeight = _scalingWeightController.text;
      _recipe.method = _methodController.text;
      _recipe.ingredients = _ingredients
          .map((ingredient) => Ingredient(
              name: ingredient[0],
              starterAmount: ingredient[1],
              starterUnit: ingredient[2],
              doughAmount: ingredient[3],
              doughUnit: ingredient[4],
              bakersPercentage: ingredient[5],
              formula: ingredient[6]))
          .toList();

      _recipe.totalStarterAmount = calculateTotalStarterAmount();
      _recipe.totalDoughAmount = calculateTotalDoughAmount();

      Map<String, dynamic> recipeJson = _recipe.toJson();

      // Create a new collection and add data
      CollectionReference recipes =
          FirebaseFirestore.instance.collection('formRecipes');

      recipes.add(recipeJson).then((DocumentReference document) {
        print("Document added with ID: ${document.id}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recipe added successfully!'),
            ),
          );
          setState(() {
            _isSubmitting = false;
          });
        }
      }).catchError((error) {
        print("Failed to add document: $error");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add recipe!'),
            ),
          );
          setState(() {
            _isSubmitting = false;
          });
        }
      });

      widget.onSubmit(_recipe); // Pass the _recipe object directly
      Navigator.pop(context);
    }
  }
}
