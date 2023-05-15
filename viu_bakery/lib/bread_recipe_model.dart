import 'ingredient.dart';

class BreadRecipe {
  String category;
  String name;
  String yeild;
  String ddt;
  String scalingWeight;
  List<Ingredient> ingredients;
  String method;

  BreadRecipe({
    required this.category,
    required this.name,
    required this.yeild,
    required this.ddt,
    required this.scalingWeight,
    required this.ingredients,
    required this.method,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'yeild': yeild,
      'ddt': ddt,
      'scalingWeight': scalingWeight,
      'ingredients':
          ingredients.map((ingredient) => ingredient.toJson()).toList(),
      'method': method,
    };
  }
}
