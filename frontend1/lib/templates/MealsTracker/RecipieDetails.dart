// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:frontend1/templates/MealsTracker/recipies.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;

// class RecipeDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> recipe;
//    final  String? id;
//    final String? mealTime;
//  final String token;
//   final String templateId;
// final String MealsArrayID;
//   RecipeDetailScreen({required this.recipe,
//     required this.id,
//     required this.mealTime,
//         required this.token,
//     required this.templateId,
//     required this.MealsArrayID
//   });
//   double calculateAndRound(dynamic value, dynamic servings) {
//     if (value == null || servings == null || servings == 0) {
//       return 0.0;
//     }
//     return (value / servings).toDouble().roundToDouble(); // Ensure value is rounded
//   }
//   @override
//   Widget build(BuildContext context) {
//     final ingredients = recipe['ingredientLines'];
//     final sourceUrl = recipe['url'];

//     return Scaffold(
//       appBar: AppBar(
//        leading: IconButton(
//         onPressed: (){
//   Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => RecipeScreen(token: token,templateId: templateId,mealTime:mealTime,id:id,MealsArrayID: MealsArrayID,),
//                             ),
//                           );
//         },
//         icon:Icon(Icons.arrow_back),
//        ),
//         title:
//          Row(children: [
//          // IconButton(onPressed: onPressed, icon: Icon(Ico))
//              Text(recipe['label']),
//         ],)
      
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.network(recipe['image']),
//               SizedBox(height: 16),
//               Text(
//                 recipe['label'],
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Calories: ${recipe['calories'].toStringAsFixed(0)} kcal',
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Ingredients:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               for (var ingredient in ingredients)
//                 Text('- $ingredient', style: TextStyle(fontSize: 16)),
//               SizedBox(height: 16),
//               Text(
//                 'Nutritional Information:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Text('Fat: ${recipe['totalNutrients']['FAT']?['quantity']?.toStringAsFixed(1) ?? 'N/A'} g'),
//               Text('Protein: ${recipe['totalNutrients']['PROCNT']?['quantity']?.toStringAsFixed(1) ?? 'N/A'} g'),
//               Text('Carbs: ${recipe['totalNutrients']['CHOCDF']?['quantity']?.toStringAsFixed(1) ?? 'N/A'} g'),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   // Open the source URL in a web browser
//                   launchUrl(Uri.parse(sourceUrl));
//                 },
//                 child: Text('View Full Recipe'),
//               ),
//                ElevatedButton(
//                 onPressed: () {
//                   // Open the source URL in a web browser
//                 addMealToDay();
//                 },
//                 child: Text('Add to my plan'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Future<void> addMealToDay() async {
//   final url = Uri.parse('http://$localhost/api/days/$id/meals');
//   Map<String, dynamic> mealData = {
//   'name': recipe['label'],
//   'ingredients': recipe['ingredientLines'],
//   'calories': calculateAndRound(recipe['calories'], recipe['yield']), // calories per serving
//     'protein': calculateAndRound(recipe['totalNutrients']['PROCNT']?['quantity'], recipe['yield']), // protein per serving
//     'carbohydrates': calculateAndRound(recipe['totalNutrients']['CHOCDF']?['quantity'], recipe['yield']), // carbs per serving
//     'fats': calculateAndRound(recipe['totalNutrients']['FAT']?['quantity'], recipe['yield']), // fats per serving
//     'fiber': calculateAndRound(recipe['totalNutrients']['FIBTG']?['quantity'], recipe['yield']), // fiber per serving
//     'sugar': calculateAndRound(recipe['totalNutrients']['SUGAR']?['quantity'], recipe['yield']), // sugar per serving
//     'cholesterol': calculateAndRound(recipe['totalNutrients']['CHOLE']?['quantity'], recipe['yield']), // cholesterol per serving
//   'type': mealTime, // type can be breakfast, lunch, dinner, or snacks
//    'quantity': recipe['servingSize'] ?? recipe['portionSize'] ??'Not available', // Use servingSize or portionSize // Adding health labels if available
// 'dishType': recipe['dishType'] != null && recipe['dishType'].isNotEmpty
//         ? recipe['dishType'][0]
//         : 'Not specified', // Extract the first dish type if available
// };

// /*
//     name,
//       ingredients,
//       calories,
//       protein,
//       carbohydrates,
//       fats,
//       fiber,
//       sugar,
//       cholesterol,
//       quantity,
//       healthLabels
//       */
// /*
//   Map<String, dynamic> mealData = {
//     'name': recipe['label'],
//     'ingredients':recipe['ingredientLines'],
//     'calories': recipe['calories'].round(),
//     'protein': recipe['totalNutrients']['PROCNT']?['quantity'].round(),
//     'carbohydrates': recipe['totalNutrients']['CHOCDF']?['quantity'].round(),
//     'fats': recipe['totalNutrients']['FAT']?['quantity'].round(),
//     'type': mealTime , // type can be breakfast, lunch, dinner, or snacks
//     'isEaten':false
//        fiber:
//       sugar,
//       cholesterol,
//       quantity: recipie['servingsize']
//   };
//   */
//    if (id == null || id!.isEmpty) {
//     print('Error: Day ID is empty.');
//     return;
//   }
//   /*
//   Map<String, dynamic> mealData = {
//     'name': recipe['label'],
//     'ingredients':recipe['ingredientLines'],
//     'calories': 10,
//     'protein': 10,
//     'carbohydrates': 10,
//     'fats':10,
//     'type': mealTime , // type can be breakfast, lunch, dinner, or snacks
//     'isEaten':false
//   };
// */
//   try {
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(mealData),
//     );

//     if (response.statusCode == 200) {
//       print('Meal added successfully: ${response.body}');
//     } else {
//       print('Failed to add meal: ${response.body}');
//     }
//   } catch (e) {
//     print('Error occurred: $e');
//   }
// }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/MealsTracker/recipies.dart';
import 'package:frontend1/templates/sideBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;
   final  String? id;
   final String? mealTime;
 final String token;
  final String templateId;
final String MealsArrayID;
final VoidCallback onAdd;

  RecipeDetailScreen({
     
    required this.recipe,
    required this.id,
    required this.mealTime,
        required this.token,
    required this.templateId,
    required this.MealsArrayID,
     required this.onAdd,
  });

  double calculateAndRound(dynamic value, dynamic servings) {
    if (value == null || servings == null || servings == 0) {
      return 0.0;
    }
    return (value / servings).toDouble().roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
        bool isWeb=MediaQuery.of(context).size.width>1200?true:false;

    final ingredients = recipe['ingredientLines'];
    final sourceUrl = recipe['url'];

    return Scaffold(
      appBar: AppBar(
       leading: IconButton(
        onPressed: (){
  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeScreen(token: token,templateId: templateId,mealTime:mealTime,id:id,MealsArrayID: MealsArrayID,onAdd: onAdd,),
                            ),
                          );
        },
        icon:Icon(Icons.arrow_back),
       ),
        title: Text(
          recipe['label'],
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Row(
  children: [
    if (isWeb) WebSidebar(), // Only show WebSidebar on the web
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isWeb)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    recipe['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 16),
              Text(
                recipe['label'],
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Calories: ${recipe['calories'].toStringAsFixed(0)} kcal',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Ingredients:',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...ingredients.map((ingredient) => Text(
                    '- $ingredient',
                    style: GoogleFonts.montserrat(fontSize: 16),
                  )),
              SizedBox(height: 16),
              Text(
                'Nutritional Information:',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Fat: ${recipe['totalNutrients']['FAT']?['quantity']?.toStringAsFixed(1) ?? 'N/A'} g',
                style: GoogleFonts.montserrat(fontSize: 16),
              ),
              Text(
                'Protein: ${recipe['totalNutrients']['PROCNT']?['quantity']?.toStringAsFixed(1) ?? 'N/A'} g',
                style: GoogleFonts.montserrat(fontSize: 16),
              ),
              Text(
                'Carbs: ${recipe['totalNutrients']['CHOCDF']?['quantity']?.toStringAsFixed(1) ?? 'N/A'} g',
                style: GoogleFonts.montserrat(fontSize: 16),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    launchUrl(Uri.parse(sourceUrl));
                  },
                  child: Text(
                    'View Full Recipe',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: addMealToDay,
                  child: Text(
                    'Add to My Plan',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
)

    );
  }

  Future<void> addMealToDay() async {
    final url = Uri.parse('http://$localhost/api/days/$id/meals');
    Map<String, dynamic> mealData = {
      'name': recipe['label'],
      'ingredients': recipe['ingredientLines'],
      'calories': calculateAndRound(recipe['calories'], recipe['yield']),
      'protein': calculateAndRound(recipe['totalNutrients']['PROCNT']?['quantity'], recipe['yield']),
      'carbohydrates': calculateAndRound(recipe['totalNutrients']['CHOCDF']?['quantity'], recipe['yield']),
      'fats': calculateAndRound(recipe['totalNutrients']['FAT']?['quantity'], recipe['yield']),
      'fiber': calculateAndRound(recipe['totalNutrients']['FIBTG']?['quantity'], recipe['yield']),
      'sugar': calculateAndRound(recipe['totalNutrients']['SUGAR']?['quantity'], recipe['yield']),
      'cholesterol': calculateAndRound(recipe['totalNutrients']['CHOLE']?['quantity'], recipe['yield']),
      'type': mealTime,
      'quantity': recipe['servingSize'] ?? recipe['portionSize'] ?? 'Not available',
      'dishType': recipe['dishType'] != null && recipe['dishType'].isNotEmpty
          ? recipe['dishType'][0]
          : 'Not specified',
    };

    if (id == null || id!.isEmpty) {
      print('Error: Day ID is empty.');
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(mealData),
      );

      if (response.statusCode == 200) {
        print('Meal added successfully: ${response.body}');
      } else {
        print('Failed to add meal: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
