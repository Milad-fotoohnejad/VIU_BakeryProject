import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient.dart';

class BreadRecipe {
  String name;
  List<Ingredient> ingredients;
  String starter;
  String poolish;
  String dough;
  String bakersPercentage;
  String formula;

  BreadRecipe({
    required this.name,
    required this.ingredients,
    required this.starter,
    required this.poolish,
    required this.dough,
    required this.bakersPercentage,
    required this.formula,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'starter': starter,
      'poolish': poolish,
      'dough': dough,
      'bakersPercentage': bakersPercentage,
      'formula': formula,
    };
  }

  Future<void> addToFirestore() async {
    // Create a new collection for the recipe
    CollectionReference recipeCollection =
        FirebaseFirestore.instance.collection('recipes');

    // Add the recipe data to the collection and get the new document ID
    DocumentReference newRecipeDoc = await recipeCollection.add(toMap());

    // Create a new subcollection for the recipe ingredients
    CollectionReference ingredientsCollection =
        newRecipeDoc.collection('ingredients');

    // Add each ingredient as a new document in the subcollection
    for (Ingredient ingredient in ingredients) {
      await ingredientsCollection.add(ingredient.toMap());
    }
  }
}
