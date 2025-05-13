// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:frontend1/pages/Template.dart';
// import 'package:frontend1/templates/Islam/MainIslam.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;



// class RoutineApp extends StatefulWidget {
//     final String arrayID;
//   final String token;
//     final String templateId;

//   const RoutineApp({
//     Key? key,
//     required this.token,
//     required this.arrayID,
//     required this.templateId,
//   }) : super(key: key);
//   @override
//  RoutineAppState createState() => RoutineAppState();
// }
//  class RoutineAppState extends State<RoutineApp> {
//  Template? template;   


// //print("array is inside routine1 is $arrayID");
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Routine Tracker',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: 'Montserrat', // Customize font here
//         scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255), // Light background
//       ),
      
//       home: RoutineScreen(arrayID:widget.arrayID!,templateId: widget.templateId,token: widget.token,),
//     );
//   }
// }

// class RoutineScreen extends StatefulWidget {
//     final String arrayID;

//   final String token;
//     final String templateId;

//   const RoutineScreen({
//     Key? key,
//     required this.token,
//     required this.arrayID,
//     required this.templateId,
//   }) : super(key: key);

//   @override
//   _RoutineScreenState createState() => _RoutineScreenState();
// }

// class _RoutineScreenState extends State<RoutineScreen> {
//    bool isLoading = true;
//   List<RoutineItem> routines = [];
//   String message = '';
//    String RoutineID="";
//   /*
//   List<RoutineItem> routines = [
//     RoutineItem(name: 'Read Al Quran', completed: true),
//     RoutineItem(name: 'Morning Dhikr', completed: true),
//     RoutineItem(name: 'Morning Alms', completed: true),
//     RoutineItem(name: 'Asr Prayer', completed: false),
//     RoutineItem(name: 'Magrib Prayer', completed: false),
//     RoutineItem(name: 'Isha Prayer', completed: false),
//   ];
// */

// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//       fetchTodayRoutine();
//   }


//   Future<void> addTask(String title, String priority) async {
//     final url = Uri.parse('http://$localhost/api/routine/$RoutineID/task');
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'title': title, 'priority': priority}),
//       );

//       if (response.statusCode == 200) {
//         print('Task added successfully.');
//        final data=json.decode(response.body);
     
//         setState(() {
//         RoutineItem r= RoutineItem(name: title, completed: false, id: data['routine']['_id'], priority:priority);
//         routines.add(r);
//         });
//       } else {
//         print('Failed to add task: ${response.body}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
  
//  // Fetch today's routine and populate the routines list
//   Future<void> fetchTodayRoutine() async {
//     setState(() {
//       isLoading = true;
//     });

//     final routineService = RoutineService();
//     final result = await routineService.retrieveTodayRoutine(widget.arrayID);

//     setState(() {
//       isLoading = false;
//       if (result['success']) {
//         final routineData = result['routine'];

//         // Map tasks and prayers to RoutineItem
//         routines = [];
//         RoutineID=routineData['_id'];
//         if (routineData['tasks'] != null) {
//           routines.addAll((routineData['tasks'] as List).map((task) {
//             return RoutineItem(
//               name: task['title'],
//               completed: task['isCompleted'],
//               id:task['_id'],
//               priority:task['priority'],
//             );
//           }).toList());
//         }
// /*
//         if (routineData['prayers'] != null) {
//           routines.addAll((routineData['prayers'] as List).map((prayer) {
//             return RoutineItem(
//               name: prayer['name'],
//               completed: prayer['isCompleted'],
//             );
//           }).toList());
//         }
// */
//         message = result['message'];
//         print(result['message']);
//       } else {
//         routines = [];
//         message = result['message'];
//       }
//     });
//   }

//   int getCompletedCount() {
//     return routines.where((routine) => routine.completed).length;
//   }

//   double getCompletionPercentage() {
//     return routines.isEmpty ? 0.0 : getCompletedCount() / routines.length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 255, 255, 255), // Darker color for AppBar
//         title: Text(
//           'My Routine',
//           style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
//         ),
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Color(0xFFbb877a)),
//             onPressed: () {
//             // Navigator.pop(context, "refresh");// Navigate back
//             Navigator.push(context, MaterialPageRoute(builder: (context) =>IslamicAppHomePage(templateId:widget.templateId ,token: widget.token)));
//           },
//           ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Center(
//               child: Text(
//                 '${getCompletedCount()}/${routines.length}',
//                 style: TextStyle(fontSize: 18, ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15.0),
//             child: CircularPercentIndicator(
//               radius: 70.0,
//               lineWidth: 12.0,
//               percent: getCompletionPercentage(),
//               center: Text(
//                 "${(getCompletionPercentage() * 100).toStringAsFixed(0)}%",
//                 style: TextStyle(fontSize: 20, ),
//               ),
//               progressColor:Color.fromARGB(255, 212, 199, 221),
//               // Color(0xFFDEBCB2),

//               backgroundColor: Color((0xffE9E2EE),),
//               circularStrokeCap: CircularStrokeCap.round,
//             ),
//           ),
//           Row(
//             children:[
//             TextButton(
//               onPressed: () {
//     // Show the Add Task dialog using showDialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AddTaskDialog(
//           onSave: (String taskName, String priority) {
//             // Call the addTask function when Save is pressed
//             addTask(taskName, priority);
//           },
//         );
//       },
//     );
//   },
//               child: Text('Add Task')),
//             ]
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: routines.length,
//               itemBuilder: (context, index) {
//                   return GestureDetector(
//         onLongPress: () {
//           _showDeleteConfirmationDialog(context, RoutineID, index);
//         },
//                 child: RoutineTile(
//                   routine: routines[index],
//                   onChanged: (value) {
//                     setState(() {
//                       routines[index].completed = value;
//                     });
//                   },
//                   RoutineID: RoutineID,
//                 ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// void _showDeleteConfirmationDialog(BuildContext context, String routineId, int taskIndex) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Delete Task'),
//         content: Text('Are you sure you want to delete this task?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.of(context).pop(); // Close the dialog
//               setState(() {
//                 routines.removeAt(taskIndex);
//               });
              
//               await deleteTaskByIndex(routineId:routineId, taskIndex:taskIndex); // Call the delete function
//             },
//             child: Text('Delete'),
//           ),
//         ],
//       );
//     },
//   );
// }


// // Function to delete a task by index from a routine
// Future<void> deleteTaskByIndex({
//   required String routineId,
//   required int taskIndex,

// }) async {
//   final url = Uri.parse('http://$localhost/api/routines/$routineId/tasks/$taskIndex');

//   try {
//     final response = await http.delete(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       print('Task deleted successfully: ${data['message']}');
//       print('Updated Routine: ${data['updatedRoutine']}');
//     } else {
//       final errorData = jsonDecode(response.body);
//       print('Failed to delete task: ${errorData['error']}');
//     }
//   } catch (e) {
//     print('Error while deleting task: $e');
//   }
// }

// }

// class RoutineItem {
//   String name;
//   bool completed;
//   String id;
//   String priority;

//   RoutineItem({required this.name,required this.completed ,required this.id,required this.priority});
// }

// class RoutineTile extends StatelessWidget {
//   final RoutineItem routine;
//   final ValueChanged<bool> onChanged;
//   final RoutineID ;

//   RoutineTile({required this.routine, required this.onChanged,required this.RoutineID});

//  Future<void> updateTaskStatus(bool value) async {
//     final routineService = RoutineService();
//     final result = await routineService.markTaskCompleted(RoutineID, routine.id, value);
//     if (!result['success']) {
//       // Handle failure (e.g., show a Snackbar)
//       print(result['message']);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Color.fromARGB(255, 237, 197, 187), width: 1.5), // Add border
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: ListTile(
//         title: Text(
//           routine.name,
//           style: TextStyle(
//             fontSize: 18,
//             decoration: routine.completed ? TextDecoration.lineThrough : null,
//             color: routine.completed ? Color.fromARGB(255, 164, 193, 220) :  Color.fromARGB(255, 81, 111, 139),
//           ),
//         ),
//         trailing: Checkbox(
//           value: routine.completed,
//           activeColor: Color.fromARGB(255, 228, 206, 199), // Checkbox color
//           onChanged: (value) {
//                if (value != null) {
//               updateTaskStatus(value);
//               onChanged(value);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }


// class RoutineService {
//   final String baseUrl = 'http://$localhost'; // Replace with your API base URL

//   // Function to call the API and retrieve today's routine
//   Future<Map<String, dynamic>> retrieveTodayRoutine(String arrayId) async {
//     print ("inside retrieveTodayRoutine ");
//     final url = Uri.parse('$baseUrl/api/retrieveTodayRoutine/$arrayId');
//     try {
//       final response = await http.get(url);
// print("response is $response");
// print("response status code is${response.statusCode}");
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print("data is $data");
//         return {
//           'success': true,
//           'message': data['message'],
//           'routine': data['routine'],
//         };
//       } else {
//         final error = json.decode(response.body);
//            print("error  is $error");
//         return {
//           'success': false,
//           'message': error['message'] ?? 'Failed to retrieve routine',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   Future<Map<String, dynamic>> markTaskCompleted(String arrayId, String taskId, bool isCompleted) async {
//     print("inside markTaskCompleted");

//     final url = Uri.parse('$baseUrl/api/markTaskCompleted/$arrayId/$taskId');
//     try {
//       final response = await http.patch(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'isCompleted': isCompleted}),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return {
//           'success': true,
//           'message': data['message'],
//         };
//       } else {
//         final error = json.decode(response.body);
//         return {
//           'success': false,
//           'message': error['message'] ?? 'Failed to update task status',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }
// }
// class AddTaskDialog extends StatelessWidget {
//   final TextEditingController taskController = TextEditingController();
//   String selectedPriority = 'Medium';

//   final Function(String taskName, String priority) onSave;

//   AddTaskDialog({required this.onSave});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Add a Task'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           // Task name input
//           TextField(
//             controller: taskController,
//             decoration: InputDecoration(
//               labelText: 'Task Name',
//             ),
//           ),
//           SizedBox(height: 20),
//           // Task priority selection
//       /*    DropdownButton<String>(
//             value: selectedPriority,
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 selectedPriority = newValue;
//               }
//             },
//             items: <String>['High', 'Medium', 'Low']
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//           */
//         ],
//       ),
//       actions: <Widget>[
//         // Cancel button
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Cancel'),
//         ),
//         // Save button to add the task
//         TextButton(
//           onPressed: () {
//             String taskName = taskController.text;
//             // Call the onSave callback function to save the task
//             onSave(taskName, selectedPriority);
//             Navigator.of(context).pop(); // Close the dialog
//           },
//           child: Text('Save'),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure Google Fonts is imported
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/Template.dart';
import 'package:frontend1/templates/Islam/MainIslam.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Define your primary and secondary colors here or in a separate colors.dart file
const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.grey;
const Color accentColor = Color(0xFFbb877a); // Example accent color

class RoutineApp extends StatefulWidget {
  final String arrayID;
  final String token;
  final String templateId;
final VoidCallback onAdd;
  const RoutineApp({
    Key? key,
    required this.token,
    required this.arrayID,
    required this.templateId,
    required this.onAdd,
  }) : super(key: key);

  @override
  RoutineAppState createState() => RoutineAppState();
}

class RoutineAppState extends State<RoutineApp> {
  Template? template;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routine Tracker',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.grey[50], // Light background
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: primaryColor),
          titleTextStyle: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0, // Flat AppBar
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: RoutineScreen(
        arrayID: widget.arrayID,
        templateId: widget.templateId,
        token: widget.token,
        onAdd: widget.onAdd,
      ),
    );
  }
}

class RoutineScreen extends StatefulWidget {
  final String arrayID;
  final String token;
  final String templateId;
final VoidCallback onAdd;
  const RoutineScreen({
    Key? key,
    required this.token,
    required this.arrayID,
    required this.templateId,
    required this.onAdd,
  }) : super(key: key);

  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  bool isLoading = true;
  List<RoutineItem> routines = [];
  String message = '';
  String RoutineID = "";

  @override
  void initState() {
    super.initState();
    fetchTodayRoutine();
  }

  Future<void> addTask(String title, String priority) async {
    final url = Uri.parse('http://$localhost/api/routine/$RoutineID/task');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'priority': priority}),
      );

      if (response.statusCode == 200) {
        print('Task added successfully.');
        final data = json.decode(response.body);

        setState(() {
          RoutineItem r = RoutineItem(
            name: title,
            completed: false,
            id: data['routine']['_id'],
            priority: priority,
          );
          routines.add(r);
        });
      } else {
        print('Failed to add task: ${response.body}');
        _showSnackBar('Failed to add task: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      _showSnackBar('Error adding task: $e');
    }
  }

  // Fetch today's routine and populate the routines list
  Future<void> fetchTodayRoutine() async {
    setState(() {
      isLoading = true;
    });

    final routineService = RoutineService();
    final result = await routineService.retrieveTodayRoutine(widget.arrayID);

    setState(() {
      isLoading = false;
      if (result['success']) {
        final routineData = result['routine'];

        // Map tasks and prayers to RoutineItem
        routines = [];
        RoutineID = routineData['_id'];
        if (routineData['tasks'] != null) {
          routines.addAll((routineData['tasks'] as List).map((task) {
            return RoutineItem(
              name: task['title'],
              completed: task['isCompleted'],
              id: task['_id'],
              priority: task['priority'],
            );
          }).toList());
        }

        message = result['message'];
        print(result['message']);
      } else {
        routines = [];
        message = result['message'];
        _showSnackBar(message);
      }
    });
  }

  int getCompletedCount() {
    return routines.where((routine) => routine.completed).length;
  }

  double getCompletionPercentage() {
    return routines.isEmpty ? 0.0 : getCompletedCount() / routines.length;
  }
@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
    child: Column(
      children: [
        SizedBox(height: 15),
        CircularPercentIndicator(
          radius: 70.0,
          lineWidth: 12.0,
          percent: getCompletionPercentage(),
          center: Text(
            "${(getCompletionPercentage() * 100).toStringAsFixed(0)}%",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          progressColor: primaryColor,
          backgroundColor: Colors.grey[300]!,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Show the Add Task dialog using showDialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddTaskDialog(
                      onSave: (String taskName, String priority) {
                        // Call the addTask function when Save is pressed
                        addTask(taskName, priority);
                      },
                    );
                  },
                );
              },
              icon: Icon(Icons.add),
              label: Text('Add Task'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
    
        isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : routines.isEmpty
                  ? Center(
                      child: Text(
                        'No tasks available. Add some!',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: routines.asMap().entries.map((entry) {
                          final index = entry.key; // Index of the routine
                          final routine = entry.value; // The routine object

                          return GestureDetector(
                            onLongPress: () {
                              _showDeleteConfirmationDialog(
                                  context, RoutineID, index);
                            },
                            child: RoutineTile(
                              routine: routine,
                              onChanged: (value) {
                                setState(() {
                                  routine.completed = value;
                                  widget.onAdd();
                                });
                              },
                              RoutineID: RoutineID,
                              onAdd:widget.onAdd,
                            ),
                          );
                        }).toList(), // Convert Iterable to List
                      ),
                    ),
        
      ],
    ),
  );
}


  void _showDeleteConfirmationDialog(
      BuildContext context, String routineId, int taskIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Task',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this task?',
            style: GoogleFonts.montserrat(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  color: secondaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  routines.removeAt(taskIndex);
                });

                await deleteTaskByIndex(
                    routineId: routineId, taskIndex: taskIndex);
              },
              child: Text(
                'Delete',
                style: GoogleFonts.montserrat(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to delete a task by index from a routine
  Future<void> deleteTaskByIndex({
    required String routineId,
    required int taskIndex,
  }) async {
    final url = Uri.parse(
        'http://$localhost/api/routines/$routineId/tasks/${routines[taskIndex].id}');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Task deleted successfully: ${data['message']}');
        _showSnackBar('Task deleted successfully.');
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to delete task: ${errorData['error']}');
        _showSnackBar('Failed to delete task: ${errorData['error']}');
      }
    } catch (e) {
      print('Error while deleting task: $e');
      _showSnackBar('Error deleting task: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: Colors.black54,
      ),
    );
  }
}

class RoutineItem {
  String name;
  bool completed;
  String id;
  String priority;

  RoutineItem({
    required this.name,
    required this.completed,
    required this.id,
    required this.priority,
  });
}

class RoutineTile extends StatelessWidget {
  final RoutineItem routine;
  final ValueChanged<bool> onChanged;
  final String RoutineID;
  final VoidCallback onAdd;

  RoutineTile({
    required this.routine,
    required this.onChanged,
    required this.RoutineID,
required this.onAdd,
  });

  Future<void> updateTaskStatus(bool value) async {
    final routineService = RoutineService();
    final result =
        await routineService.markTaskCompleted(RoutineID, routine.id, value);
    if (!result['success']) {
     onAdd();
      // Handle failure (e.g., show a Snackbar)
      print(result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: Colors.grey.shade300, width: 1.5), // Consistent border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Lighter shadow for consistency
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          routine.name,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            decoration:
                routine.completed ? TextDecoration.lineThrough : null,
            color: routine.completed
                ? Colors.grey
                : Colors.black87, // Consistent text color
            fontWeight: routine.completed ? FontWeight.w400 : FontWeight.w600,
          ),
        ),
        trailing: Checkbox(
          value: routine.completed,
          activeColor: primaryColor,
          onChanged: (value) {
            if (value != null) {
              updateTaskStatus(value);
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}

class RoutineService {
  final String baseUrl = 'http://$localhost'; // Replace with your API base URL

  // Function to call the API and retrieve today's routine
  Future<Map<String, dynamic>> retrieveTodayRoutine(String arrayId) async {
    print("inside retrieveTodayRoutine ");
    final url = Uri.parse('$baseUrl/api/retrieveTodayRoutine/$arrayId');
    try {
      final response = await http.get(url);
      print("response is $response");
      print("response status code is${response.statusCode}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("data is $data");
        return {
          'success': true,
          'message': data['message'],
          'routine': data['routine'],
        };
      } else {
        final error = json.decode(response.body);
        print("error  is $error");
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to retrieve routine',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> markTaskCompleted(
      String arrayId, String taskId, bool isCompleted) async {
    print("inside markTaskCompleted");

    final url = Uri.parse('$baseUrl/api/markTaskCompleted/$arrayId/$taskId');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isCompleted': isCompleted}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to update task status',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(String taskName, String priority) onSave;

  AddTaskDialog({required this.onSave});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController taskController = TextEditingController();
  String selectedPriority = 'Medium';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add a Task',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Task name input
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                labelStyle: GoogleFonts.montserrat(),
              ),
              style: GoogleFonts.montserrat(),
            ),
            SizedBox(height: 20),
            // Task priority selection
            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
                labelStyle: GoogleFonts.montserrat(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: <String>['High', 'Medium', 'Low']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: GoogleFonts.montserrat()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedPriority = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.montserrat(
              color: secondaryColor,
            ),
          ),
        ),
        // Save button to add the task
        TextButton(
          onPressed: () {
            String taskName = taskController.text.trim();
            if (taskName.isNotEmpty) {
              // Call the onSave callback function to save the task
              widget.onSave(taskName, selectedPriority);
              Navigator.of(context).pop(); // Close the dialog
            } else {
              // Show error if task name is empty
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Task name cannot be empty.',
                    style: GoogleFonts.montserrat(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Text(
            'Save',
            style: GoogleFonts.montserrat(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
