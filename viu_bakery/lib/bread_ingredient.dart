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

  static Ingredient fromJson(Map<String, dynamic> map) {
    // return new Ingredient from map
    return Ingredient(
      name: map['name'],
      starterAmount: map['starterAmount'],
      starterUnit: map['starterUnit'],
      doughAmount: map['doughAmount'],
      doughUnit: map['doughUnit'],
      bakersPercentage: map['bakersPercentage'],
      formula: map['formula'],
    );
  }
}
