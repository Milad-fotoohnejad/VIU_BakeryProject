import 'package:flutter/material.dart';
import 'package:viu_bakery/pastry_ingredient.dart' as pi;
import 'package:viu_bakery/pastry_recipe_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class PastryRecipeForm extends StatefulWidget {
  final Function(PastryRecipe) onSubmit;

  PastryRecipeForm({required this.onSubmit});

  @override
  _PastryRecipeFormState createState() => _PastryRecipeFormState();
}

class _PastryRecipeFormState extends State<PastryRecipeForm> {
  bool _isSubmitting = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PastryRecipe _recipe = PastryRecipe(
    name: '',
    category: '',
    yield: '',
    unitWeight: '',
    ingredients: [],
    method: '',
  );

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yieldController = TextEditingController();
  final TextEditingController _unitWeightController = TextEditingController();
  final TextEditingController _methodController = TextEditingController();

  List<List<String>> _ingredients = [
    ['', '', '', '', '', ''],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pastry Recipe'),
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
                  decoration: InputDecoration(labelText: 'Recipe Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe category';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Recipe Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _yieldController,
                  decoration: InputDecoration(labelText: 'Recipe Yield'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe yield';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _unitWeightController,
                  decoration: InputDecoration(labelText: 'Unit Weight'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a unit weight';
                    }
                    return null;
                  },
                ),
                ..._buildIngredientsList(),
                _buildAddIngredientButton(),
                TextFormField(
                  controller: _methodController,
                  decoration: InputDecoration(labelText: 'Method'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a method';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: Text('Save Recipe'),
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
              decoration: InputDecoration(labelText: 'Ingredient Name'),
            ),
          ),
          SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) {
                ingredient[1] = value;
                setState(() {});
              },
              decoration: InputDecoration(labelText: 'QTY'),
            ),
          ),
          SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) => ingredient[2] = value,
              decoration: InputDecoration(labelText: 'Unit'),
            ),
          ),
          SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) {
                ingredient[3] = value;
                setState(() {});
              },
              decoration: InputDecoration(labelText: 'Multiplier'),
            ),
          ),
          SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) => ingredient[4] = value,
              decoration: InputDecoration(labelText: 'Unit'),
            ),
          ),
          SizedBox(width: 2),
          Expanded(
            child: TextField(
              onChanged: (value) => ingredient[5] = value,
              decoration: InputDecoration(labelText: 'Bakers %'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
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
      icon: Icon(Icons.add),
      onPressed: () {
        setState(() {
          _ingredients.add(['', '', '', '', '', '']);
        });
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      _recipe.name = _nameController.text;
      _recipe.category = _categoryController.text;
      _recipe.yield = _yieldController.text;
      _recipe.unitWeight = _unitWeightController.text;
      _recipe.method = _methodController.text;

      _recipe.ingredients = _ingredients
          .map((ingredient) => pi.PastryIngredient(
                name: ingredient[0],
                qty: ingredient[1],
                qtyUnit: ingredient[2],
                multiplier: ingredient[3],
                multiplierUnit: ingredient[4],
                bakersPercentage: ingredient[5],
              ))
          .toList();

      Map<String, dynamic> recipeJson = _recipe.toJson();

      // Create a new collection and add data
      CollectionReference recipes =
          FirebaseFirestore.instance.collection('formRecipes');

      recipes.add(recipeJson).then((DocumentReference document) {
        print("Document added with ID: ${document.id}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
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
            SnackBar(
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
