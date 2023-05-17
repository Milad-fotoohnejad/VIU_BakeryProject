import 'ingredient.dart';

class BreadRecipe {
  String category;
  String name;
  String yeild;
  String ddt;
  String scalingWeight;
  List<Ingredient> ingredients;
  String method;
  double totalStarterAmount;
  double totalDoughAmount;

  BreadRecipe({
    required this.category,
    required this.name,
    required this.yeild,
    required this.ddt,
    required this.scalingWeight,
    required this.ingredients,
    required this.method,
    this.totalStarterAmount = 0.0,
    this.totalDoughAmount = 0.0,
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
      'totalStarterAmount': totalStarterAmount,
      'totalDoughAmount': totalDoughAmount,
    };
  }
}
