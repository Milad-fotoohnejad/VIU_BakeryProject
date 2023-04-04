import 'package:flutter/material.dart';
import 'package:viu_bakery/ingredient.dart';
import 'ingredient.dart';
import 'bread_recipe.dart';

class BreadRecipeForm extends StatefulWidget {
  final Function(BreadRecipe) onSubmit;

  BreadRecipeForm({required this.onSubmit});

  @override
  _BreadRecipeFormState createState() => _BreadRecipeFormState();
}

class _BreadRecipeFormState extends State<BreadRecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BreadRecipe _recipe = BreadRecipe(
    name: '',
    ingredients: [],
    starter: '',
    poolish: '',
    dough: '',
    bakersPercentage: '',
    formula: '',
  );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _starterController = TextEditingController();
  final TextEditingController _poolishController = TextEditingController();
  final TextEditingController _doughController = TextEditingController();
  final TextEditingController _bakersPercentageController =
      TextEditingController();
  final TextEditingController _formulaController = TextEditingController();

  // String _ingredientName = '';
  // String _ingredientAmount = '';
  List<List<String>> _ingredients = [
    ['', ''],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bread Recipe'),
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
                  decoration: InputDecoration(labelText: 'Recipe Name'),
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
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
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
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: (value) => ingredient[1] = value,
              decoration: InputDecoration(labelText: 'Ingredient Amount'),
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
          _ingredients.add(['', '']);
        });
      },
    );
  }

  Widget _buildOtherFields() {
    return Column(
      children: [
        TextFormField(
          controller: _starterController,
          decoration: InputDecoration(labelText: 'Starter'),
        ),
        TextFormField(
          controller: _poolishController,
          decoration: InputDecoration(labelText: 'Poolish'),
        ),
        TextFormField(
          controller: _doughController,
          decoration: InputDecoration(labelText: 'Dough'),
        ),
        TextFormField(
          controller: _bakersPercentageController,
          decoration: InputDecoration(labelText: "Bakers' Percentage"),
        ),
        TextFormField(
          controller: _formulaController,
          decoration: InputDecoration(labelText: 'Formula'),
        ),
      ],
    );
  }

  // await _recipe.addToFirestore(); // Uncomment this line if you want to add the recipe to Firestore
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _recipe.name = _nameController.text;
      _recipe.ingredients = _ingredients
          .where((ingredient) =>
              ingredient[0].isNotEmpty && ingredient[1].isNotEmpty)
          .map((ingredient) => Ingredient(ingredient[0], ingredient[1]))
          .toList();
      _recipe.starter = _starterController.text;
      _recipe.poolish = _poolishController.text;
      _recipe.dough = _doughController.text;
      _recipe.bakersPercentage = _bakersPercentageController.text;
      _recipe.formula = _formulaController.text;

      widget.onSubmit(_recipe); // Pass the _recipe object directly
      Navigator.pop(context);
    }
  }
}
