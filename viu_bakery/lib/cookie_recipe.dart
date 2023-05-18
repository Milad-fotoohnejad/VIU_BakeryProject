import 'bread_ingredient.dart';

class Ingredient {
  final String name;
  final String amount;

  Ingredient({required this.name, required this.amount});
}

class CookieRecipe {
  String name;
  List<Ingredient> ingredients;
  String method;
  String bakingTime;
  String yield;
  String instructions;

  CookieRecipe({
    required this.name,
    required this.ingredients,
    required this.method,
    required this.bakingTime,
    required this.yield,
    required this.instructions,
  });
}
