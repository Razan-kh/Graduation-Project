
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/DashBoard.dart';
import 'package:frontend1/pages/Template.dart';
import 'package:frontend1/templates/MealsTracker/ChartsMeals.dart';
import 'package:frontend1/templates/MealsTracker/MealModel.dart';
import 'package:frontend1/templates/MealsTracker/NeutrientsProvoder.dart';
import 'package:frontend1/templates/MealsTracker/recipies.dart';
import 'package:frontend1/templates/sideBar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:frontend1/templates/MealsTracker/NeutrientsProvoder.dart';

class NutritionalCell extends StatefulWidget {
  final String itemName;
final String mealId;
final String Dayid;
final String MealsArrayID;
 bool isMealDone;
   final String quantity;
     final String dishType;
       final VoidCallback onDelete; // Add the callback
   NutritionalCell({Key? key, required this.itemName,required this.mealId,required this.Dayid,
   required this.isMealDone,required this.MealsArrayID,required this.quantity,
   required this.dishType,required this.onDelete}) : super(key: key);

  @override
  _NutritionalCellState createState() => _NutritionalCellState();
}

class _NutritionalCellState extends State<NutritionalCell> {
  // Track the meal done status

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
    onLongPress: () {
      // Show confirmation dialog on long press
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Delete Meal"),
          content: Text(
              "Are you sure you want to delete the item: ${widget.itemName}?"),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async{
                // Call the delete function and close the dialog
             await  deleteMeal(widget.mealId);
                widget.onDelete();
                Navigator.of(context).pop();
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    },
    child:
     Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.itemName, // Access itemName through widget
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 38, 80, 132),
                ),
              ),
              IconButton(
                icon: Icon(
                  widget.isMealDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: widget.isMealDone ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    widget.isMealDone = !widget.isMealDone;
                    toggleMealEatenStatus(widget.Dayid,widget.mealId,widget.MealsArrayID);// Toggle meal done status
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  "Type:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 219, 149, 95),
                  ),
                ),
              ),
              Text(widget.dishType), // Replace with actual food type if needed
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child:widget.quantity!="Not available"?
                 Text(
                  "Quantity:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 219, 149, 95),
                  ),
                ): Text("")
              ),

             widget.quantity!="Not available"?
                 Text(widget.quantity): Text("")
              // Replace with actual quantity if needed
            ],
          ),
        ],
      ),
     )
    );
  }

Future<void> deleteMeal(String mealId) async {
  const String baseUrl = "http://$localhost/api"; // Replace with your server URL

  try {
    final url = Uri.parse("$baseUrl/meals/$mealId");

    // Send DELETE request
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Check the response status
    if (response.statusCode == 200) {
      print("Meal deleted successfully.");
await getTodayy();
    } else {
      print("Failed to delete meal. Status code: ${response.statusCode}");
      print("Response: ${response.body}");
    }
  } catch (e) {
    print("Error deleting meal: $e");
  }
}

   Future<void> getTodayy() async {
  //final neutrientsProvider = Provider.of<NeutrientsProvider>(context, listen: false);
    // Fetch or create the Day instance for today's date
    print("inside getTodayy");
        if (widget.MealsArrayID != null) {
  today= await getOrCreateDay(selectedDate,widget.MealsArrayID!,context); 
      print("after getorcreate day to calc totals");
        if(today != null){
    setState(() {
    print("inside setState to calc goals");
   int    DayGoalCal=today!.goalCalories.toInt();
 int  DayGoalCarb=today!.goalCarbohydrates.toInt();
 int  DayGoalProtein=today!.goalProtein.toInt();
 int  DayGoalFat=today!.goalFats.toInt();


int totalCalories=today!.totalCalories.toInt();
int totalCarbohydrates=today!.totalCarbohydrates.toInt();
int totalProtein=today!.totalProtein.toInt();
int totalFats=today!.totalFats.toInt();
     /*
     neutrientsProvider.updateProtien(totalProtein);
     neutrientsProvider.updateCarbs(totalCarbohydrates);
     neutrientsProvider.updateFat(totalFats);
     neutrientsProvider.updateKcal(totalCalories);
     */
   int Fiber=today!.Fiber;
   int Sugar=today!.Sugar;
   int cholesterol=today!.Cholesterol;
//print(" totals Sugar is $Sugar  fiber is $Fiber  cholesterol is $cholesterol");
     NutritionalData updatedData = NutritionalData(
                protein: totalProtein,
                carb:totalCarbohydrates,
                fat: totalFats,
                kcal: totalCalories,
                
                cholesterol: cholesterol,
                fiber: Fiber,
                Sugar: Sugar,

                goalCarb: DayGoalCarb,
                goalFat: DayGoalFat,
                goalKcal: DayGoalCal,
                goalProtein: DayGoalProtein
                
              );
print("before provider");
              // Update the data in the notifier
              Provider.of<NutritionalDataNotifier>(context, listen: false)
                  .updateData(updatedData);
    });
    print("after provider");

  }
  }
   }
   Future<void> toggleMealEatenStatus(String dayId, String mealId,String MealsArrayID) async {
    final url = Uri.parse('http://$localhost/api/days/$dayId/$mealId/toggle-eaten');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final updatedDay = jsonDecode(response.body);
        print('Day updated successfully: $updatedDay');
        getOrCreateDay(selectedDate, MealsArrayID, context);
        // Handle the updatedDay response as needed, e.g., update the UI
      } else {
        print('Failed to update meal status: ${response.body}');
        throw Exception('Failed to update meal status');
      }
    } catch (error) {
      print('Error toggling meal eaten status: $error');
      throw Exception('Error toggling meal eaten status: $error');
    }
  }
}

