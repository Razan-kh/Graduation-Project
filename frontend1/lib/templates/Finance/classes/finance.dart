import 'package:frontend1/templates/Finance/classes/bill.dart';
import 'package:frontend1/templates/Finance/classes/category.dart';
import 'package:frontend1/templates/Finance/classes/income.dart';
import 'package:frontend1/templates/Finance/classes/subscription.dart';

class Finance {
  String id;
  String userId; // ID of the user associated with this finance data
  String title; // Title of the finance document
  String type; // Type of finance (e.g., personal, business)
  List<Subscription> subscriptions; // List of subscriptions
  List<Category> categories; // List of categories
  List<Bill> bills; // List of bills
  List<Income> incomes; // List of incomes
  double net; // Net financial balance
  DateTime createdAt; // Creation timestamp

  Finance({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.subscriptions,
    required this.categories,
    required this.bills,
    required this.incomes,
    required this.net,
    required this.createdAt,
  });

  factory Finance.fromJson(Map<String, dynamic> json) {
    return Finance(
      id:json['_id'],
      userId: json['userId'] ?? '', // Provide a default empty string if null
      title: json['title'] ?? '', // Default empty title if null
      type: json['type'] ?? '',
     // subscriptions: [],
   //   categories: [],
    //  bills: [],
    //  incomes:[],
    
      
       // Default empty type if null
      subscriptions: (json['subscriptions'] as List? ?? [])
          .map((e) => Subscription.fromJson(e))
          .toList(),
          
      categories: (json['categories'] as List? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
          
      bills: (json['bills'] as List? ?? [])
          .map((e) => Bill.fromJson(e))
          .toList(),
      incomes: (json['incomes'] as List? ?? [])
          .map((e) => Income.fromJson(e))
          .toList(),
          
          
        //  incomes:[],
          
      net: (json['net'] ?? 0).toDouble(), // Default to 0 if null
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}