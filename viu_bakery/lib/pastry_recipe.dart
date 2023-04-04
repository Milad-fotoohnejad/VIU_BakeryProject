import 'ingredient.dart';

class PastryRecipe {
  String name;
  List<Ingredient> ingredients;
  String method;
  String bakingTemperature;
  String bakingTime;
  String instructions;

  PastryRecipe({
    required this.name,
    required this.ingredients,
    required this.method,
    required this.bakingTemperature,
    required this.bakingTime,
    required this.instructions,
  });
}
