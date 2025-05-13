
import 'package:frontend1/templates/Finance/classes/expense.dart';

class Category {
  String id;
  String name;
  String? description;
  String? icon;
  String? color;
  List<Expense>? expenses;
double totalAmount;
  Category({
   required  this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
     this.expenses,
    required this.totalAmount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id :json['_id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      expenses: json['expenses'] != null ? 
     ( json['expenses'] as List)
          .map((e) => Expense.fromJson(e))
          .toList()
          :[],
      totalAmount: json['totalAmount'].toDouble(),
    );
  }


}