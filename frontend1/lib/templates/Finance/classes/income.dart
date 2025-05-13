class Income {
  String id; // _id from backend
  String name;
  double amount;
  DateTime date;
  String? notes; // Optional field
  String type; // e.g., 'monthly'
  DateTime? renewalDate; // Next renewal date
  /*
  DateTime createdAt; // When the income record was created
  DateTime updatedAt; // Last updated timestamp
*/
  Income({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    this.notes,
    required this.type,
     this.renewalDate,
   // required this.createdAt,
  //  required this.updatedAt,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['_id'] ?? '', // Map _id to id
      name: json['name'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      notes: json['notes'], // Handle optional field
      type: json['type'],
      
renewalDate: json['renewalDate'] != null
    ? DateTime.parse(json['renewalDate'])
    : null,
    //  createdAt: DateTime.parse(json['createdAt']),
    //  updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}