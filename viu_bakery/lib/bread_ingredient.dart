class Ingredient {
  String name;
  String starterAmount;
  String starterUnit;
  String doughAmount;
  String doughUnit;
  String bakersPercentage;
  String formula;

  Ingredient({
    required this.name,
    required this.starterAmount,
    required this.starterUnit,
    required this.doughAmount,
    required this.doughUnit,
    required this.bakersPercentage,
    required this.formula,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'starterAmount': starterAmount,
      'starterUnit': starterUnit,
      'doughAmount': doughAmount,
      'doughUnit': doughUnit,
      'bakersPercentage': bakersPercentage,
      'formula': formula,
    };
  }
}
