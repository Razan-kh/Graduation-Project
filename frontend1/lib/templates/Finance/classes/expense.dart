class Expense {
  String name;
  double amount;
  DateTime date;
  String category;
  String? notes;

  Expense({
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    this.notes,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json['name'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      category: json['category']?? "",
      notes: json['notes'],
    );
  }
}