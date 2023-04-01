class Ingredient {
  final String name;
  final String amount;

  Ingredient(this.name, this.amount);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}
