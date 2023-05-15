// import 'package:flutter/material.dart';
// import 'ingredient.dart';
// import 'pastry_recipe.dart';

// class PastryRecipeForm extends StatefulWidget {
//   final Function(PastryRecipe) onSubmit;

//   PastryRecipeForm({required this.onSubmit});

//   @override
//   _PastryRecipeFormState createState() => _PastryRecipeFormState();
// }

// class _PastryRecipeFormState extends State<PastryRecipeForm> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final PastryRecipe _recipe = PastryRecipe(
//     name: '',
//     ingredients: [],
//     method: '',
//     bakingTemperature: '',
//     bakingTime: '',
//     instructions: '',
//   );

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _methodController = TextEditingController();
//   final TextEditingController _bakingTemperatureController =
//       TextEditingController();
//   final TextEditingController _bakingTimeController = TextEditingController();
//   final TextEditingController _instructionsController = TextEditingController();

//   List<List<String>> _ingredients = [
//     ['', ''],
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Pastry Recipe'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(labelText: 'Recipe Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a recipe name';
//                     }
//                     return null;
//                   },
//                 ),
//                 ..._buildIngredientsList(),
//                 _buildAddIngredientButton(),
//                 _buildOtherFields(),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   child: Text('Save Recipe'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildIngredientsList() {
//     return _ingredients.map((ingredient) {
//       return Row(
//         children: [
//           Expanded(
//             child: TextField(
//               onChanged: (value) => ingredient[0] = value,
//               decoration: InputDecoration(labelText: 'Ingredient Name'),
//             ),
//           ),
//           SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               onChanged: (value) => ingredient[1] = value,
//               decoration: InputDecoration(labelText: 'Ingredient Amount'),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               setState(() {
//                 _ingredients.remove(ingredient);
//               });
//             },
//           ),
//         ],
//       );
//     }).toList();
//   }

//   Widget _buildAddIngredientButton() {
//     return IconButton(
//       icon: Icon(Icons.add),
//       onPressed: () {
//         setState(() {
//           _ingredients.add(['', '']);
//         });
//       },
//     );
//   }

//   Widget _buildOtherFields() {
//     return Column(
//       children: [
//         TextFormField(
//           controller: _methodController,
//           decoration: InputDecoration(labelText: 'Method'),
//         ),
//         TextFormField(
//           controller: _bakingTemperatureController,
//           decoration: InputDecoration(labelText: 'Baking Temperature'),
//         ),
//         TextFormField(
//           controller: _bakingTimeController,
//           decoration: InputDecoration(labelText: 'Baking Time'),
//         ),
//         TextFormField(
//           decoration: InputDecoration(labelText: 'Instructions'),
//         ),
//       ],
//     );
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _recipe.name = _nameController.text;
//       _recipe.ingredients = _ingredients
//           .where((ingredient) =>
//               ingredient[0].isNotEmpty && ingredient[1].isNotEmpty)
//           .map((ingredient) => Ingredient(ingredient[0], ingredient[1]))
//           .toList();
//       _recipe.method = _methodController.text;
//       _recipe.bakingTemperature = _bakingTemperatureController.text;
//       _recipe.bakingTime = _bakingTimeController.text;
//       _recipe.instructions = _instructionsController.text;

//       widget.onSubmit(_recipe); // Pass the _recipe object directly
//       Navigator.pop(context);
//     }
//   }
// }
