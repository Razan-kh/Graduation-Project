// import 'package:flutter/material.dart';
// import 'package:frontend1/templates/MealsTracker/ChartsMeals.dart';
// import 'package:frontend1/templates/MealsTracker/MealModel.dart';
// import 'package:provider/provider.dart';
// import 'fetchMeals.dart';
// import 'RecipieDetails.dart';

// class RecipeScreen extends StatefulWidget {
//    final  String? id;
//    final String? mealTime;
//     final String token;
//   final String templateId;
// final String MealsArrayID;
//    const RecipeScreen({
//     Key? key,
//     required this.id,
//     required this.mealTime,
//         required this.token,
//     required this.templateId,
//     required this.MealsArrayID,
//   }) : super(key: key);

//   @override
//   _RecipeScreenState createState() => _RecipeScreenState();
// }
// class _RecipeScreenState extends State<RecipeScreen> {

//   final RecipeService _recipeService = RecipeService();
//   List<dynamic> _recipes = [];
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//  fetchRecipes();
//   }

//   Future<void> fetchRecipes() async {
//     try {
//       final recipes = await _recipeService.fetchRecipes(_searchQuery);
//       setState(() {
//         _recipes = recipes;
//       });
//     } catch (e) {
//       print('Error fetching recipes: $e');
//     }
//   }

//   void _onSearchChanged(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//   }

//   void _onSearchSubmitted() {
//     fetchRecipes();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading:  IconButton(onPressed: (){
//             print("arrow back is pressed");
//           getTodayy();
//   Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MealsMain(token: widget.token,templateId: widget.templateId,),
//                             ),
//                           );
                          

              
//           }, 
//           icon: Icon(Icons.arrow_back)),
//         title:Row(
//         children: [
         
//      Text('Recipes'),

//         ],
//       )
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'Enter meal name',
//                 hintText: 'e.g., chicken',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: _onSearchSubmitted,
//                 ),
//               ),
//               onChanged: _onSearchChanged,
//               onSubmitted: (_) => _onSearchSubmitted(),
//             ),
//           ),
//           Expanded(
//             child: _recipes.isEmpty
//                 ?// Center(child: CircularProgressIndicator()
//                 (Text(''))
//                 : ListView.builder(
//                     itemCount: _recipes.length,
//                     itemBuilder: (context, index) {
//                       final recipe = _recipes[index]['recipe'];

//                       return ListTile(
//                         leading: Image.network(recipe['image']),
//                         title: Text(recipe['label']),
//                         subtitle: Text('Calories: ${recipe['calories'].toStringAsFixed(0)} kcal'),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => RecipeDetailScreen(recipe: recipe,mealTime: widget.mealTime,id: widget.id,token: widget.token,templateId: widget.templateId,MealsArrayID: widget.MealsArrayID,),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//     int DayGoalCal=0;
//   int DayGoalFat=0;
//   int DayGoalCarb=0;
//   int DayGoalProtein=0;
// int totalCalories=0;
// int totalCarbohydrates=0;
// int totalFats=0;
// int totalProtein=0;

// int cholesterol=0;
// int Sugar=0;
// int Fiber=0;
//    Future<void> getTodayy() async {
//   //final neutrientsProvider = Provider.of<NeutrientsProvider>(context, listen: false);
//     // Fetch or create the Day instance for today's date
//     print("inside getTodayy");
//         if (widget.MealsArrayID != null) {
//   today= await getOrCreateDay(selectedDate,widget.MealsArrayID!,context); 
//       print("after getorcreate day to calc totals");
//         if(today != null){
//     setState(() {
//     print("inside setState to calc goals");
//        DayGoalCal=today!.goalCalories.toInt();
//    DayGoalCarb=today!.goalCarbohydrates.toInt();
//    DayGoalProtein=today!.goalProtein.toInt();
//    DayGoalFat=today!.goalFats.toInt();


// totalCalories=today!.totalCalories.toInt();
// totalCarbohydrates=today!.totalCarbohydrates.toInt();
// totalProtein=today!.totalProtein.toInt();
// totalFats=today!.totalFats.toInt();
//      /*
//      neutrientsProvider.updateProtien(totalProtein);
//      neutrientsProvider.updateCarbs(totalCarbohydrates);
//      neutrientsProvider.updateFat(totalFats);
//      neutrientsProvider.updateKcal(totalCalories);
//      */
//     Fiber=today!.Fiber;
//     Sugar=today!.Sugar;
//     cholesterol=today!.Cholesterol;
// //print(" totals Sugar is $Sugar  fiber is $Fiber  cholesterol is $cholesterol");
//      NutritionalData updatedData = NutritionalData(
//                 protein: totalProtein,
//                 carb:totalCarbohydrates,
//                 fat: totalFats,
//                 kcal: totalCalories,
                
//                 cholesterol: cholesterol,
//                 fiber: Fiber,
//                 Sugar: Sugar,

//                 goalCarb: DayGoalCarb,
//                 goalFat: DayGoalFat,
//                 goalKcal: DayGoalCal,
//                 goalProtein: DayGoalProtein
                
//               );
// print("before provider");
//               // Update the data in the notifier
//               Provider.of<NutritionalDataNotifier>(context, listen: false)
//                   .updateData(updatedData);
//     });
//     print("after provider");

//   }
//   }
//   }
// }
import 'package:flutter/material.dart';
import 'package:frontend1/templates/MealsTracker/ChartsMeals.dart';
import 'package:frontend1/templates/MealsTracker/MealModel.dart';
import 'package:frontend1/templates/MealsTracker/NeutrientsProvoder.dart';
import 'package:frontend1/templates/sideBar.dart';
import 'package:provider/provider.dart';
import 'fetchMeals.dart';
import 'RecipieDetails.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeScreen extends StatefulWidget {
 final  String? id;
   final String? mealTime;
    final String token;
  final String templateId;
final String MealsArrayID;
final VoidCallback onAdd;
   const RecipeScreen({
    Key? key,
    required this.id,
    required this.mealTime,
        required this.token,
    required this.templateId,
    required this.MealsArrayID,
   required this.onAdd,
  }) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final RecipeService _recipeService = RecipeService();
  List<dynamic> _recipes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final recipes = await _recipeService.fetchRecipes(_searchQuery);
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      // print('Error fetching recipes: $e');
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onSearchSubmitted() {
    fetchRecipes();
  }

  // Nutritional and day-related fields
  int DayGoalCal = 0;
  int DayGoalFat = 0;
  int DayGoalCarb = 0;
  int DayGoalProtein = 0;
  int totalCalories = 0;
  int totalCarbohydrates = 0;
  int totalFats = 0;
  int totalProtein = 0;
  int cholesterol = 0;
  int Sugar = 0;
  int Fiber = 0;

  Future<void> getTodayy() async {
    if (widget.MealsArrayID.isNotEmpty) {
      today = await getOrCreateDay(selectedDate, widget.MealsArrayID, context);
      if (today != null) {
        setState(() {
          DayGoalCal = today!.goalCalories.toInt();
          DayGoalCarb = today!.goalCarbohydrates.toInt();
          DayGoalProtein = today!.goalProtein.toInt();
          DayGoalFat = today!.goalFats.toInt();

          totalCalories = today!.totalCalories.toInt();
          totalCarbohydrates = today!.totalCarbohydrates.toInt();
          totalProtein = today!.totalProtein.toInt();
          totalFats = today!.totalFats.toInt();

          Fiber = today!.Fiber;
          Sugar = today!.Sugar;
          cholesterol = today!.Cholesterol;

          NutritionalData updatedData = NutritionalData(
            protein: totalProtein,
            carb: totalCarbohydrates,
            fat: totalFats,
            kcal: totalCalories,
            cholesterol: cholesterol,
            fiber: Fiber,
            Sugar: Sugar,
            goalCarb: DayGoalCarb,
            goalFat: DayGoalFat,
            goalKcal: DayGoalCal,
            goalProtein: DayGoalProtein,
          );

          Provider.of<NutritionalDataNotifier>(context, listen: false)
              .updateData(updatedData);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb=MediaQuery.of(context).size.width>1200?true:false;
    return Scaffold(
      backgroundColor: Colors.white, // Align background with your program style
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            getTodayy();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MealsMain(
                  token: widget.token,
                  templateId: widget.templateId,
                ),
              ),
            );
          },
        ),
        title: Row(
          children: [
            Text(
              'Recipes',
              style: GoogleFonts.montserrat(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: 
      Row(children: [
        if(isWeb) WebSidebar(),
Expanded(child: 

      Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: GoogleFonts.montserrat(
                color: Colors.black87,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                labelText: 'Enter meal name',
                labelStyle: GoogleFonts.montserrat(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
                hintText: 'e.g., chicken',
                hintStyle: GoogleFonts.montserrat(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.grey),
                  onPressed: _onSearchSubmitted,
                ),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (_) => _onSearchSubmitted(),
            ),
          ),

          // Recipes List
          Expanded(
            child: _recipes.isEmpty
                ? const Center(child: Text(''))
                : ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index]['recipe'];

                      return ListTile(
                        leading: Image.network(
                          recipe['image'],
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        ),
                        title: Text(
                          recipe['label'],
                          style: GoogleFonts.montserrat(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Calories: ${recipe['calories'].toStringAsFixed(0)} kcal',
                          style: GoogleFonts.montserrat(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                recipe: recipe,
                                mealTime: widget.mealTime,
                                id: widget.id,
                                token: widget.token,
                                templateId: widget.templateId,
                                MealsArrayID: widget.MealsArrayID,
                                onAdd: widget.onAdd,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
),
if(isWeb)SizedBox(width:100)
      ]
      )
    );
  }
}
