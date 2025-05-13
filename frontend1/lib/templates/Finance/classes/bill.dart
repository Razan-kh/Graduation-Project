import 'package:intl/intl.dart';

class Bill {
  final String id;
  final String name;
  final double amount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String paymentMethod;
  final String status;
  final String frequency;
  final String? category;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor
  Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.paymentMethod,
    required this.status,
    required this.frequency,
    this.category,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Method to create a Bill from a JSON object
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['_id'] ?? '', // Assuming _id is the ID from the backend
      name: json['name'],
      amount: json['amount'].toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      paidDate: json['paidDate'] != null ? DateTime.parse(json['paidDate']) : null,
      paymentMethod: json['paymentMethod'],
      status: json['status'] ?? 'Due', // Default to 'Due'
      frequency: json['frequency'] ?? 'Monthly', // Default to 'Monthly'
      category: json['category'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert Bill to JSON for sending to the backend
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'dueDate': DateFormat('yyyy-MM-dd').format(dueDate),
      'paidDate': paidDate != null ? DateFormat('yyyy-MM-dd').format(paidDate!) : null,
      'paymentMethod': paymentMethod,
      'status': status,
      'frequency': frequency,
      'category': category,
      'userId': userId,
      'createdAt': DateFormat('yyyy-MM-dd').format(createdAt),
      'updatedAt': DateFormat('yyyy-MM-dd').format(updatedAt),
    };
  }
}