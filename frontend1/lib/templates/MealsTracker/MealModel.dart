import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/MealsTracker/ChartsMeals.dart';
import 'package:frontend1/templates/MealsTracker/NeutrientsProvoder.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class Meal {
  dynamic id;
  String name;
    String quantity;
      String dishType;
  List<String> ingredients;
  double calories;
  double protein;
  double carbohydrates;
  double fats;
  DateTime date;
  bool isEaten;
   int fiber;
  int sugar;
int  cholesterol;

  Meal({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fats,
    required this.date,
        required this.quantity,
    required this.dishType,
    this.isEaten = false,
       required this.fiber,
   required this.sugar,
   required this.cholesterol
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unnamed Meal',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble() ?? 0.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      isEaten: json['isEaten'] ?? false,
      quantity:json['quantity'],
      dishType:json['dishType'],
      fiber:json['fiber'],
  sugar:json['sugar'],
  cholesterol:json['cholesterol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'ingredients': ingredients,
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fats': fats,
      'date': date.toIso8601String(),
      'isEaten': isEaten,
    };
  }
}

class Day {
  dynamic
      id; // Add id field as a String or ObjectId (depending on your backend setup)
  DateTime date;
  List<Meal> breakfast;
  List<Meal> lunch;
  List<Meal> dinner;
  List<Meal> snacks;
  double totalCalories;
  double totalProtein;
  double totalCarbohydrates;
  double totalFats;
  double goalCalories;
  double goalProtein;
  double goalCarbohydrates;
  double goalFats;
  int Sugar;
  int Fiber;
  int Cholesterol;

  Day({
    required this.id,
    required this.date,
    this.breakfast = const [],
    this.lunch = const [],
    this.dinner = const [],
    this.snacks = const [],
    this.totalCalories = 0.0,
    this.totalProtein = 0.0,
    this.totalCarbohydrates = 0.0,
    this.totalFats = 0.0,
    this.goalCalories = 2000.0,
    this.goalProtein = 150.0,
    this.goalCarbohydrates = 250.0,
    this.goalFats = 70.0,
    this.Cholesterol=0,
    this.Fiber=0,
    this.Sugar=0,

  });

  factory Day.fromJson(Map<String, dynamic> json, BuildContext context) {
  //  print("json is $json");
  //  print("json id is ${json['_id']}");
    dynamic id = json['_id'] ?? '';
    Map<String, dynamic> mealsJson = json['meals'] ?? {};

    List<Meal> parseMeals(List? mealsList) {
      return mealsList
              ?.whereType<Map<String, dynamic>>() // Only take valid maps
              .map((mealJson) => Meal.fromJson(mealJson))
              .toList() ??
          [];
    }

    NutritionalDataNotifier notifier =
        Provider.of<NutritionalDataNotifier>(context, listen: false);
    notifier.updateNutrients(
     
        protien: (json['totalProtein'] as num?)?.toInt() ?? 0,
        carb: (json['totalCarbohydrates'] as num?)?.toInt() ?? 0,
        fat: (json['totalFats'] as num?)?.toInt() ?? 0,
        kcal: (json['totalCalories'] as num?)?.toInt() ?? 0,
        cholesterol:(json['Cholesterol'] as num?)?.toInt() ?? 0,  
        fiber: (json['Fiber'] as num?)?.toInt() ?? 0,
        Sugar: (json['Sugar'] as num?)?.toInt() ?? 0,
      
    );
    return Day(
      id: id, // Ensure the id is correctly parsed
      date: DateTime.tryParse(json['day']?['date'] ?? '') ?? DateTime.now(),
      breakfast: parseMeals(mealsJson['breakfast'] as List?),
      lunch: parseMeals(mealsJson['lunch'] as List?),
      dinner: parseMeals(mealsJson['dinner'] as List?),
      snacks: parseMeals(mealsJson['snacks'] as List?),
      totalCalories: (json?['totalCalories'] as num?)?.toDouble() ?? 0.0,
      totalProtein: (json?['totalProtein'] as num?)?.toDouble() ?? 0.0,
      totalCarbohydrates:
          (json?['totalCarbohydrates'] as num?)?.toDouble() ?? 0.0,
      totalFats: (json?['totalFats'] as num?)?.toDouble() ?? 0.0,
      goalCalories: (json?['goalCalories'] as num?)?.toDouble() ?? 2000.0,
      goalProtein: (json?['goalProtein'] as num?)?.toDouble() ?? 150.0,
      goalCarbohydrates:
          (json?['goalCarbohydrates'] as num?)?.toDouble() ?? 250.0,
      goalFats: (json?['goalFats'] as num?)?.toDouble() ?? 70.0,
      Sugar: json['Sugar'],
      Fiber: json['Fiber'],
      Cholesterol: json['Cholesterol']
    );
  }  

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Include id in the serialized output
      'date': date.toIso8601String(),
      'meals': {
        'breakfast': breakfast.map((meal) => meal.toJson()).toList(),
        'lunch': lunch.map((meal) => meal.toJson()).toList(),
        'dinner': dinner.map((meal) => meal.toJson()).toList(),
        'snacks': snacks.map((meal) => meal.toJson()).toList(),
      },
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbohydrates': totalCarbohydrates,
      'totalFats': totalFats,
      'goalCalories': goalCalories,
      'goalProtein': goalProtein,
      'goalCarbohydrates': goalCarbohydrates,
      'goalFats': goalFats,
    };
  }
}

Future<Day> getOrCreateDay(
    DateTime selectedDate, String DaysArrayID, BuildContext context) async {
 // print(DateTime.now().toUtc()); // Print current UTC time
  final url = 'http://$localhost/api/days';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Specify JSON format
      },
      body: jsonEncode({
        "DaysArrayID": DaysArrayID,
        "date": selectedDate
            .toIso8601String()
            .substring(0, 10), // Just the date part (YYYY-MM-DD)
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
     // print('API Response: $responseData'); // Log successful response

      // Check if 'day' exists in the response and handle it
      if (responseData['day'] != null) {
        return Day.fromJson(
            responseData['day'], context); // Pass the 'day' object if it exists
      } else {
        throw Exception('Missing "day" in the response');
      }
    } else {
      // Log the error response body for better insight
      print('Error Response: ${response.body}');
      throw Exception('Failed to load day');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error calling API: $e');
  }
}
