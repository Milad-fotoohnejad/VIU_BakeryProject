import 'pastry_ingredient.dart';

class PastryRecipe {
  String name;
  String category;
  String yield;
  String unitWeight;
  List<PastryIngredient> ingredients;
  String method;

  PastryRecipe({
    required this.name,
    required this.category,
    required this.yield,
    required this.unitWeight,
    required this.ingredients,
    required this.method,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'yield': yield,
      'unitWeight': unitWeight,
      'ingredients':
          ingredients.map((ingredient) => ingredient.toJson()).toList(),
      'method': method,
    };
  }
}
