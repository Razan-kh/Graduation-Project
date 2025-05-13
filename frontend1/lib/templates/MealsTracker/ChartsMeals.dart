import 'package:flutter/material.dart';
import 'package:frontend1/pages/DashBoard.dart';
import 'package:frontend1/pages/Template.dart';
import 'package:frontend1/templates/MealsTracker/MealCell.dart';
import 'package:frontend1/templates/MealsTracker/MealModel.dart';
import 'package:frontend1/templates/MealsTracker/NeutrientsProvoder.dart';
import 'package:frontend1/templates/MealsTracker/recipies.dart';
import 'package:frontend1/templates/sideBar.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

    DateTime selectedDate=DateTime.now();
  //late Future<Day> today;
  Day ?today;
class MealsMain extends StatefulWidget {
 final String token;
  final String templateId;
  
  const MealsMain({
    Key? key,
    required this.token,
    required this.templateId,
  }) : super(key: key);
  @override
  MealsMainState createState() => MealsMainState();
}
class MealsMainState extends  State<MealsMain>   {
Template? template;
String? MealsArrayID;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
       fetchTemplate(); // Fetch template asynchronously
  }

 
  // Fetch the template and update the state
  Future<void> fetchTemplate() async {
     try {
      template = await Template.fetchTemplateData(widget.templateId, widget.token);
      if (template != null) {
        setState(() {
          MealsArrayID = template?.data;
          print("Array ID is $MealsArrayID");
        });

        // Ensure we only call getTodayy after fetching the template
        if (MealsArrayID != null) {
         await getTodayy();
        }
      }
    } catch (e) {
      // Handle errors, such as network or parsing issues
      print("Error fetching template: $e");
    }
  }
    DateTime selectedDate=DateTime.now();
     Future<void> _selectDate(BuildContext context) async {
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
       builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.blue, // Change the header color
       //   accentColor: Colors.blue, // Change the accent color
          colorScheme: ColorScheme.light(primary: Colors.blue), // Change the selected date color
          dialogBackgroundColor: Colors.white, // Change the background color
        
        ),
        child: child ?? Container(),
      );
    },
  );
    
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked; // Update the selected date
      });
  }
  int DayGoalCal=0;
  int DayGoalFat=0;
  int DayGoalCarb=0;
  int DayGoalProtein=0;
int totalCalories=0;
int totalCarbohydrates=0;
int totalFats=0;
int totalProtein=0;

int cholesterol=0;
int Sugar=0;
int Fiber=0;

   Future<void> getTodayy() async {
  //final neutrientsProvider = Provider.of<NeutrientsProvider>(context, listen: false);
    // Fetch or create the Day instance for today's date
    print("inside getTodayy");
        if (MealsArrayID != null) {
  today= await getOrCreateDay(selectedDate,MealsArrayID!,context); 
      print("after getorcreate day to calc totals");
        if(today != null){
    setState(() {
    print("inside setState to calc goals");
       DayGoalCal=today!.goalCalories.toInt();
   DayGoalCarb=today!.goalCarbohydrates.toInt();
   DayGoalProtein=today!.goalProtein.toInt();
   DayGoalFat=today!.goalFats.toInt();


totalCalories=today!.totalCalories.toInt();
totalCarbohydrates=today!.totalCarbohydrates.toInt();
totalProtein=today!.totalProtein.toInt();
totalFats=today!.totalFats.toInt();
     /*
     neutrientsProvider.updateProtien(totalProtein);
     neutrientsProvider.updateCarbs(totalCarbohydrates);
     neutrientsProvider.updateFat(totalFats);
     neutrientsProvider.updateKcal(totalCalories);
     */
    Fiber=today!.Fiber;
    Sugar=today!.Sugar;
    cholesterol=today!.Cholesterol;
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

  

//print('$totalCalories + $totalCarbohydrates + $totalProtein + $totalFats');
//print('$DayGoalCal + $DayGoalCarb + $DayGoalProtein + $DayGoalFat');

  }
  }
  }

  @override
  Widget build(BuildContext context) {
    /// final neutrientsProvider = Provider.of<NeutrientsProvider>(context);
bool isWeb=MediaQuery.of(context).size.width >600 ?true:false;
    return Scaffold(
      appBar:isWeb?null: AppBar(   
              automaticallyImplyLeading: false, 
            leading: Padding(
  padding: EdgeInsets.all( 0),  // Adjust as needed to remove extra padding
  child: IconButton(
    icon: Icon(Icons.arrow_back),  
    onPressed: () {
           Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardPage(),
                        ),
                      );
                    },
  ),
),
          backgroundColor: Colors.white,
          title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
            //  Icon(Icons.food_bank_outlined,color:Colors.black),
            Image.asset(
'lib/images/Kcal.png',
width:30,
height:30,

            ),
               SizedBox(width:4),
            Text(
              'Nutritions',
              style: GoogleFonts.montserrat(
                color: Colors.black,
              ),
            ),
            SizedBox(width: 75),
            GestureDetector(onTap: ()=>{_selectDate(context)}
            , child:  Image.network('https://cdn-icons-png.flaticon.com/512/747/747310.png',
            width:25,
            height:25)
            ),

            // centerTitle: true,
          ])),
      backgroundColor: Colors.white,
      body: today == null
          ? Center(child: CircularProgressIndicator())
          : 
          Row(
          children: [
            if(isWeb)WebSidebar(),
                if(isWeb)SizedBox(width:100),
            Expanded(
              child: 
      SingleChildScrollView(
        child:
         Column(
          children: [
          
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'lib/images/6.jpg',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                )),
 
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Consumer<NutritionalDataNotifier>(
                builder: (context, data, child) {
                  return Container(
                    height: 250,
                    padding: const EdgeInsets.only(top: 25.0),
                    decoration: BoxDecoration(
                      // color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                     // color:const Color.fromARGB(255, 1, 113, 199),
                      // Color(0xffEBFFE5),
                         color: Color(0xffEBFFE5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                         
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NutrientChart(
                                label: 'Protein',
                                value: data.data.protein,
                                maxValue: data.data.goalProtein,
                                color: Colors.red,
                              ),
                              SizedBox(width: 16),
                              NutrientChart(
                                label: 'Carbs',
                                value: data.data.carb,
                                maxValue: data.data.goalCarb,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 16),
                              NutrientChart(
                                label: 'Fat',
                                value: data.data.fat,
                                maxValue: data.data.goalFat,
                                color: Colors.green,
                              ),
                              SizedBox(width: 16),
                              NutrientChart(
                                label: 'Kcal',
                                value: data.data.kcal,
                                maxValue: data.data.goalKcal,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NutrientDataTile(
                              label: 'cholesterol',
                              value: '${data.data.cholesterol} mg',
                            ),
                            NutrientDataTile(
                              label: 'Sugar',
                              value: '${data.data.Sugar} g',
                            ),
                            NutrientDataTile(
                              label: 'Fiber',
                              value: '${data.data.fiber} g',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            MealsArrayID != null ?
            BreakfastScreen(MealsArrayID:MealsArrayID!,token:widget.token,templateID:widget.templateId):Container(),
          ],
        ),
      ),
            ),
                     if(isWeb)SizedBox(width:60),
          ]
          )
    );
  }
}

class NutrientChart extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;

  NutrientChart({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    bool isWeb =MediaQuery.of(context).size.width>600?true:false;
    return Column(
      children: [
        SizedBox(
        width:isWeb?130: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value:maxValue==0?value/1: value / maxValue,
               // backgroundColor: const Color.fromARGB(255, 166, 223, 241),
               backgroundColor:const Color.fromARGB(255, 166, 223, 241),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth:isWeb?8.0: 6.0,
                
              ),
              Text(
                '$value',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          '$label',
          style: GoogleFonts.montserrat(textStyle: TextStyle(/*color: Colors.white*/ fontSize:isWeb?14: 14)),
        ),
      ],
    );
  }
}

class NutrientDataTile extends StatelessWidget {
  final String label;
  final String value;

  NutrientDataTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    bool isWeb =MediaQuery.of(context).size.width>600? true:false;
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(textStyle: TextStyle(/*color:Colors.white*/fontSize:isWeb?14: 14)),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.montserrat(textStyle: TextStyle(/*color:Colors.white*/fontSize: isWeb?14:14)),
        ),
      ],
    );
  }
}

class BreakfastScreen extends StatelessWidget {
 final String MealsArrayID;
 final String token;
  final String templateID;
  
  const BreakfastScreen({
    Key? key,
    required this.MealsArrayID,
    required this.token,
    required this.templateID,
  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
         MealWidget(
      MealsArrayID:MealsArrayID,
              mealTime: "breakfast",
              labels: ["Protein", "Carbs", "Fat", "Kcal"],
              labelColors: [Colors.red, Colors.blue, Colors.green, Colors.orange],
token:token,
templateID:templateID,
           //   values: [40, 35, 4, 400],
            ),
          SizedBox(height: 16),
        MealWidget(
                MealsArrayID:MealsArrayID,

              mealTime: "lunch",
              labels: ["Protein", "Carbs", "Fat", "Kcal"],
              labelColors: [Colors.red, Colors.blue, Colors.green, Colors.orange],
              token:token,
templateID:templateID,
           //   values: [40, 35, 4, 400],
            ),
          SizedBox(height: 16),
          MealWidget(
                  MealsArrayID:MealsArrayID,

              mealTime: "snacks",
              labels: ["Protein", "Carbs", "Fat", "Kcal"],
              labelColors: [Colors.red, Colors.blue, Colors.green, Colors.orange],
              token:token,
templateID:templateID,
             // values: [40, 35, 4, 400],
            ),
          SizedBox(height: 16),
          MealWidget(
                  MealsArrayID:MealsArrayID,

              mealTime: "dinner",
              labels: ["Protein", "Carbs", "Fat", "Kcal"],
              labelColors: [Colors.red, Colors.blue, Colors.green, Colors.orange],
              token:token,
templateID:templateID,
             // values: [40, 35, 4, 400],
            ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class MealWidget extends StatefulWidget {
  final String mealTime;
  final String MealsArrayID;
  final List<String> labels;
  final List<Color> labelColors;
   final String token;
  final String templateID;

   MealWidget({
    Key? key,
    required this.mealTime,
  required this.MealsArrayID,
    required this.labels,
    required this.labelColors,
        required this.token,
    required this.templateID,
   // required this.values,
  }) : super(key: key);

  @override
  _MealWidgetState createState() => _MealWidgetState();
}

class _MealWidgetState extends State<MealWidget> {
  bool isMealDone = false;
  late Future<List<Meal>>? items;
 List<int> values=[0,0,0,0];
  String dayId = '';
  int mealTimeFat = 0;
  int mealTimeCarb = 0;
  int mealTimeCal = 0;
  int mealTimeProtein = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the items based on the meal time
    items = setItemsBasedOnMealTime(widget.mealTime);
   // print("meal time is ${widget.mealTime}");
  //  print("items are $items");
  }


  Future<List<Meal>> setItemsBasedOnMealTime(String mealTime) async {
   // print("inside setItemsBasedOnMealTime");
    //Day day = await getOrCreateDay(selectedDate,MealsArrayID!);
     Day day;
  try {
  //  print("meals array id is $widget.MealsArrayID");
    day = await getOrCreateDay(selectedDate, widget.MealsArrayID!,context);
  } catch (e) {
  //  print("Error in getOrCreateDay: $e");
    rethrow; // To propagate the error if necessary
  }
    dayId = day.id.toString();
//print("day id is $dayId");
    // Set items based on meal time
    switch (mealTime.toLowerCase()) {
      case 'breakfast':
    //  print (" -----------breakfast is ${day.breakfast}---");
        return day.breakfast;
      case 'lunch':
        return day.lunch;
      case 'dinner':
        return day.dinner;
      case 'snacks':
        return day.snacks;
      default:
        throw Exception('Invalid meal time: $mealTime');
    }
  }

  Future<Day> getToday() async {
    // Fetch or create the Day instance for today's date
    return await getOrCreateDay(selectedDate,widget.MealsArrayID!,context); // Ensure getOrCreateDay is defined elsewhere
  }

  void calculateMealTotals(List<Meal> meals) {
    // Reset totals to prevent accumulating values on each rebuild
    mealTimeFat = 0;
    mealTimeCarb = 0;
    mealTimeCal = 0;
    mealTimeProtein = 0;

    // Calculate nutrient totals
    for (var meal in meals) {
      mealTimeFat += meal.fats.toInt();
      mealTimeCarb += meal.carbohydrates.toInt();
      mealTimeCal += meal.calories.toInt();
      mealTimeProtein += meal.protein.toInt();
    }
    values[0]=mealTimeProtein;
     values[1]=mealTimeCarb;
      values[2]=mealTimeFat;
          values[3]=mealTimeCal;
 //print('-----------------------');
 //print('$mealTimeFat  $mealTimeCarb  $mealTimeCal  $mealTimeProtein  ');

  }

@override
Widget build(BuildContext context) {
  return FutureBuilder<List<Meal>>(
    future: items,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
    //  } else if (snapshot.hasError) {
       // return Center(child: Text('Error  : ${snapshot.error}'));

      } else {
        // Safely access snapshot.data
        List<Meal> meals = snapshot.data!;
        calculateMealTotals(meals);

        double screenWidth = MediaQuery.of(context).size.width;
bool isWeb =MediaQuery.of(context).size.width>600?true:false;

        return Container(
          width: screenWidth,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
             // mainAxisAlignment :MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.mealTime,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: () async {
                      // Define the getToday function here
                      Future<Day> getToday() async {
                        Day day = await getOrCreateDay(selectedDate, widget.MealsArrayID!,context);
                        return day; // Return the day object to use it in the next step
                      }

                      // Get the day and navigate to the RecipeScreen with the retrieved day
                      Day day = await getToday(); // Await the result of the getToday function
                     // print("day id is ");
                     // print(day.id);

                      // Now navigate to the RecipeScreen with the mealTime and the day ID
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeScreen(
                    MealsArrayID: widget.MealsArrayID,
                            mealTime: widget.mealTime,
                            id: day.id,
                            token:widget.token,
                            templateId:widget.templateID,
                            onAdd:()=>getToday(),
                          ),
                        ),
                      );
                     
                      /*
                      final GlobalKey<MealsMainState> _chartsMealsKey = GlobalKey();
                      _chartsMealsKey.currentState!.getTodayy();
                      */
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 mainAxisAlignment:isWeb? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.labels.length,
                  (index) => Column(
                    children: [
                      Container(
                        /*
                    width:isWeb?
                    height: isWeb?80:80,
                    */
                        padding: const EdgeInsets.symmetric(
                          vertical: 3.0,
                          horizontal: 5.0,
                        ),
                        decoration: BoxDecoration(
                          color: widget.labelColors[index],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          widget.labels[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isWeb?13:10,
                            decoration: TextDecoration.none,
                          
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        values[index].toString(),
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
              SizedBox(height: 10),
              NutritionalList(mealTime: widget.mealTime,MealsArrayID: widget.MealsArrayID,),
            ],
          ),
        );
      }
    },
  );
}
}

class NutritionalList extends StatefulWidget {
  final String mealTime;
     final String MealsArrayID;

  const NutritionalList({
    Key? key,
    required this.mealTime,
       required this.MealsArrayID,
  }) : super(key: key);

  @override
  NutritionalListState createState() => NutritionalListState();
}

class NutritionalListState extends State<NutritionalList> {
  late Future<List<Meal>> items;

  int mealLength = 0;
 // Callback function to remove a meal
  void removeMeal(String mealId) {
  setState(() {
      // Get the current list of meals
      items = items.then((meals) {
        // Filter the meals to remove the meal with the given mealId
        meals.removeWhere((meal) => meal.id == mealId);
        return meals;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the items based on the meal time
    items = setItemsBasedOnMealTime(widget.mealTime);
  //  print("Items are $items");
  }
String Dayid='';
  Future<List<Meal>> setItemsBasedOnMealTime(String mealTime) async {
   Day  day = await getToday();
Dayid=day.id.toString();
    switch (mealTime.toLowerCase()) {
      case 'breakfast':
        return day.breakfast;
      case 'lunch':
        return day.lunch;
      case 'dinner':
        return day.dinner;
      case 'snacks':
        return day.snacks;
      default:
        throw Exception('Invalid meal time: $mealTime');
    }
  }

  Future<Day> getToday() async {
    // Fetch or create the Day instance for today's date
    return await getOrCreateDay(selectedDate,widget.MealsArrayID!,context); // Define this method as needed
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Meal>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error here: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //  print('Snapshot data: ${snapshot.data}');
          return Center(child: Text('No meals available'));
        }

        final meals = snapshot.data!;
        mealLength = meals.length;
       
        
//print("meal length is $mealLength");
       // print('Total meals: $mealLength');

        return Container(
          // Set height dynamically based on mealLength after the data is loaded
          height: mealLength != 0 ? mealLength.toDouble() * 150 : 500.0,  // You can adjust the multiplier as needed
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: meals.length,
            itemBuilder: (context, index) {
             // print("Item name: ${meals[index].name}");
              return NutritionalCell(itemName: meals[index].name,mealId: meals[index].id,Dayid:Dayid,isMealDone: meals[index].isEaten,MealsArrayID: widget.MealsArrayID,
              quantity: meals[index].quantity,dishType:meals[index].dishType,  onDelete: () => removeMeal(meals[index].id), );
            },
          ),
        );
      },
    );
  }
}

