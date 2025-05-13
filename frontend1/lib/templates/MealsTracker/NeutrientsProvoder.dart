
import 'package:flutter/material.dart';

class NutritionalDataNotifier extends ChangeNotifier {
  // Initializing the data with goals
  NutritionalData _data = NutritionalData(
    protein: 30,
    carb: 27,
    fat: 3,
    kcal: 280,
    cholesterol: 100,
    fiber: 4,
    Sugar: 0,
    goalProtein: 50, // Example goal value
    goalCarb: 50,    // Example goal value
    goalFat: 20,     // Example goal value
    goalKcal: 2000,  // Example goal value
  );

  NutritionalData get data => _data;

  void updateData(NutritionalData newData) {
    _data = newData;
    notifyListeners();
  }

  // New function to update the nutrients and goals
  void updateNutrients({
    int? fiber,
    int? cholesterol,
    int? Sugar,

    int? goalProtein,
    int? goalCarb,
    int? goalFat,
    int? goalKcal,

    int ?protien,
    int ?carb,
    int? fat,
    int? kcal,
  }) {
    // Update the respective values if provided, otherwise retain the existing ones
    _data = NutritionalData(
      protein:protien ?? _data.protein,
      carb:carb??  _data.carb,
      fat: fat?? _data.fat,
      kcal: kcal ??_data.kcal,

      cholesterol:cholesterol?? _data.cholesterol,
      fiber: fiber ?? _data.fiber,
      Sugar: Sugar ?? _data.Sugar,

      goalProtein: goalProtein ?? _data.goalProtein,
      goalCarb: goalCarb ?? _data.goalCarb,
      goalFat: goalFat ?? _data.goalFat,
      goalKcal: goalKcal ?? _data.goalKcal,
    );

    // Notify listeners that data has been updated
    notifyListeners();
  }
}

class NutritionalData {
  final int protein;
  final int carb;
  final int fat;
  final int kcal;
  final int cholesterol;
  final int fiber;
  final int Sugar;

  // Add the goal fields
  final int goalProtein;
  final int goalCarb;
  final int goalFat;
  final int goalKcal;

  NutritionalData({
    required this.protein,
    required this.carb,
    required this.fat,
    required this.kcal,
    required this.cholesterol,
    required this.fiber,
    required this.Sugar,
    required this.goalProtein, // New parameter for goal
    required this.goalCarb,    // New parameter for goal
    required this.goalFat,     // New parameter for goal
    required this.goalKcal,    // New parameter for goal
  });
}