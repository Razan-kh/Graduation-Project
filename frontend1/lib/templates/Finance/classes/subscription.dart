class Subscription {
  String name;
  double amount;
  DateTime renewalDate;
  String frequency;
  String status;
  String? notes;
  String ?category;

  Subscription({
    required this.name,
    required this.amount,
    required this.renewalDate,
    required this.frequency,
    required this.status,
    this.notes,
    this.category,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      name: json['name'],
      amount: json['amount'].toDouble(),
      renewalDate: DateTime.parse(json['renewalDate']),
      frequency: json['frequency'],
      status: json['status'],
      notes: json['notes'],
      category :json['category']
    );
  }
}