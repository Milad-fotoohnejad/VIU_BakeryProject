class PastryIngredient {
  String name;
  String qty;
  String qtyUnit;
  String multiplier;
  String multiplierUnit;
  String bakersPercentage;

  PastryIngredient({
    required this.name,
    required this.qty,
    required this.qtyUnit,
    required this.multiplier,
    required this.multiplierUnit,
    required this.bakersPercentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'qtyUnit': qtyUnit,
      'multiplier': multiplier,
      'multiplierUnit': multiplierUnit,
      'bakersPercentage': bakersPercentage,
    };
  }

  static PastryIngredient fromJson(Map<String, dynamic> map) {
    // return new PastryIngredient from map
    return PastryIngredient(
      name: map['name'],
      qty: map['qty'],
      qtyUnit: map['qtyUnit'],
      multiplier: map['multiplier'],
      multiplierUnit: map['multiplierUnit'],
      bakersPercentage: map['bakersPercentage'],
    );
  }
}
