import 'package:flutter/material.dart';
import 'package:viu_bakery/cookie_recipe.dart';

class CookieRecipeForm extends StatefulWidget {
  final Function(CookieRecipe) onSubmit;

  const CookieRecipeForm({super.key, required this.onSubmit});

  @override
  _CookieRecipeFormState createState() => _CookieRecipeFormState();
}

class _CookieRecipeFormState extends State<CookieRecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CookieRecipe _recipe = CookieRecipe(
      name: '',
      ingredients: [],
      method: '',
      bakingTime: '',
      yield: '',
      instructions: '');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _bakingTimeController = TextEditingController();
  final TextEditingController _yieldController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  final List<List<String>> _ingredients = [
    ['', ''],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Cookie Recipe'),
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
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Recipe Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a recipe name';
                    }
                    return null;
                  },
                ),
                ..._buildIngredientsList(),
                _buildAddIngredientButton(),
                _buildOtherFields(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
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
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: (value) => ingredient[1] = value,
              decoration: const InputDecoration(labelText: 'Ingredient Amount'),
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
          _ingredients.add(['', '']);
        });
      },
    );
  }

  Widget _buildOtherFields() {
    return Column(
      children: [
        TextFormField(
          controller: _methodController,
          decoration: const InputDecoration(labelText: 'Method'),
        ),
        TextFormField(
          controller: _bakingTimeController,
          decoration: const InputDecoration(labelText: 'Baking Time'),
        ),
        TextFormField(
          controller: _yieldController,
          decoration: const InputDecoration(labelText: 'Yield'),
        ),
        TextFormField(
          controller: _instructionsController,
          decoration: const InputDecoration(labelText: 'Instructions'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _recipe.name = _nameController.text;
      _recipe.ingredients = _ingredients
          .where((ingredient) =>
              ingredient[0].isNotEmpty && ingredient[1].isNotEmpty)
          .map((ingredient) =>
              Ingredient(name: ingredient[0], amount: ingredient[1]))
          .toList();
      _recipe.method = _methodController.text;
      _recipe.bakingTime = _bakingTimeController.text;
      _recipe.yield = _yieldController.text;
      _recipe.instructions = _instructionsController.text;

      widget.onSubmit(_recipe);
      Navigator.pop(context);
    }
  }
}
