// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:frontend1/templates/Islam/routine1.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class TasbihCounterPage extends StatefulWidget {
//         final String arrayID;
//     final String token;


//   const TasbihCounterPage({
//     Key? key,
//     required this.arrayID,
//      required this.token,
//   }) : super(key: key);
//   @override
//   _TasbihCounterPageState createState() => _TasbihCounterPageState();
// }

// class _TasbihCounterPageState extends State<TasbihCounterPage> {
//      String RoutineID="";
//   int currentCount = 0;
//   int goalCount = 100; // Default goal count
//   final TextEditingController _goalController = TextEditingController();
  
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     updateTasbihCount();
//     super.dispose();
//   }
 

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//        fetchTodayRoutine();
//   }
//   Future<void> fetchTodayRoutine() async {

   
//     final routineService = RoutineService();
//     final result = await routineService.retrieveTodayRoutine(widget.arrayID);
//           if (result['success']) {
//               final routineData = result['routine'];
//             setState(() {
//               currentCount= routineData['tasbihCompleted'];
//               goalCount= routineData['tasbihGoal'];
//               print("tasbihCompleted is $currentCount tasbihGoal is $goalCount");
//             });
//         RoutineID=routineData['_id'];
//           }
//   }

//   double getProgress() {
//     if(goalCount==0)return 0;
//     else
//     return currentCount / goalCount;
//   }

//   void incrementCount() {
//     setState(() {
//       if (currentCount < goalCount) {
//         currentCount++;
//       }
//     });
//   }

//   void resetCount() {
//     setState(() {
//       currentCount = 0;
//     });
//   }
  
//   // Function to update the tasbih goal by making an API call
//   Future<void> updateTasbihCount() async {
//     try {
//       final response = await http.put(
//         Uri.parse('http://$localhost/api/updateTasbihCount/$RoutineID'), // Use the actual API URL
    
//         headers: {
//           'Content-Type': 'application/json',
//         //  'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Replace with actual token
//         },
//         body: json.encode({'tasbihCompleted': currentCount}),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         // Successfully updated tasbih goal 
//       }
//     }
//       catch(e)
//       {
// print("error occured $e");
//       }
//     }
  
//   // Function to update the tasbih goal by making an API call
//   Future<void> updateTasbihGoal() async {
//     final tasbihGoal = int.tryParse(_goalController.text);

//     if (tasbihGoal == null || tasbihGoal <= 0) {
//       // Show error if input is invalid
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Please enter a valid goal greater than 0.'),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }

//     try {
//       final response = await http.put(
//         Uri.parse('http://$localhost/api/updateTasbihGoal/$RoutineID'), // Use the actual API URL
//         headers: {
//           'Content-Type': 'application/json',
//         //  'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Replace with actual token
//         },
//         body: json.encode({'tasbihGoal': tasbihGoal}),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         // Successfully updated tasbih goal
//         setState(() {
//           goalCount = tasbihGoal; // Update the goalCount
//         });

//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Tasbih goal updated successfully!'),
//           backgroundColor: Colors.green,
//         ));
//       } else {
//         // Handle API error response
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Failed to update goal. Please try again.'),
//           backgroundColor: Colors.red,
//         ));
//       }
//     } catch (e) {
//       // Handle error if the request fails
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('An error occurred. Please try again.'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Row(
//           children: [
//             Text(
//               'Tasbih Counter',
//               style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
//             ),
//             IconButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text('Enter Tasbih Goal'),
//                       content: TextField(
//                         controller: _goalController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(hintText: 'Enter number'),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             // Assuming you have a routineId, you can pass it to the API function
//                             // Replace with actual routine ID
//                             updateTasbihGoal(); // Call the update function with the routineId
//                             Navigator.of(context).pop();
//                           },
//                           child: Text('OK'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               icon: Icon(Icons.add),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Color.fromARGB(255, 255, 255, 255),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               '\" فَاذْكُرُونِي أَذْكُرْكُمْ\"',
//               style: GoogleFonts.cairo(fontSize: 30.0, color: Color(0xffF49595)),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 30),
//             Container(
//               padding: EdgeInsets.all(16),
//               color: Color.fromARGB(255, 255, 255, 255),
//               child: Column(
//                 children: [
//                   Text(
//                     ' Goal: $goalCount',
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 81, 111, 139),
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                   CircularPercentIndicator(
//                     radius: 80.0,
//                     lineWidth: 8.0,
//                     percent: getProgress(),
//                     center: Text(
//                       "${(getProgress() * 100).toStringAsFixed(0)}%",
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Color.fromARGB(255, 0, 0, 0),
//                       ),
//                     ),
//                     progressColor: Color.fromARGB(255, 212, 199, 221),
//                     backgroundColor: Color(0xffE9E2EE),
//                     circularStrokeCap: CircularStrokeCap.round,
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//             SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 243, 210, 200),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextButton(
//                     onPressed: incrementCount,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                       child: Text(
//                         'Count',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xffFAE0D8),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextButton(
//                     onPressed: resetCount,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                       child: Text(
//                         'Reset',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
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
//   }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure Google Fonts is imported
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/Template.dart';
import 'package:frontend1/templates/Islam/MainIslam.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// RoutineService is assumed to be defined elsewhere in your project
// If not, ensure it's included similarly to RoutineApp

class TasbihCounterPage extends StatefulWidget {
  final String arrayID;
  final String token;

  const TasbihCounterPage({
    Key? key,
    required this.arrayID,
    required this.token,
  }) : super(key: key);

  @override
  _TasbihCounterPageState createState() => _TasbihCounterPageState();
}

class _TasbihCounterPageState extends State<TasbihCounterPage> {
  String RoutineID = "";
  int currentCount = 0;
  int goalCount = 100; // Default goal count
  final TextEditingController _goalController = TextEditingController();
  bool isLoading = true;

  @override
  void dispose() {
    updateTasbihCount();
    _goalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchTodayRoutine();
  }

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
        currentCount = routineData['tasbihCompleted'];
        goalCount = routineData['tasbihGoal'];
        RoutineID = routineData['_id'];
        print("tasbihCompleted is $currentCount tasbihGoal is $goalCount");
      } else {
        _showSnackBar(result['message']);
      }
    });
  }

  double getProgress() {
    if (goalCount == 0) return 0;
    return currentCount / goalCount;
  }

  void incrementCount() {
    setState(() {
      if (currentCount < goalCount) {
        currentCount++;
      }
    });
  }

  void resetCount() {
    setState(() {
      currentCount = 0;
    });
  }

  // Function to update the tasbih count by making an API call
  Future<void> updateTasbihCount() async {
    try {
      final response = await http.put(
        Uri.parse('http://$localhost/api/updateTasbihCount/$RoutineID'), // Use the actual API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}', // Replace with actual token
        },
        body: json.encode({'tasbihCompleted': currentCount}),
      );

      if (response.statusCode == 200) {
        print('Tasbih count updated successfully.');
      } else {
        print('Failed to update tasbih count: ${response.body}');
        _showSnackBar('Failed to update tasbih count: ${response.body}');
      }
    } catch (e) {
      print("Error occurred: $e");
      _showSnackBar('Error updating tasbih count: $e');
    }
  }

  // Function to update the tasbih goal by making an API call
  Future<void> updateTasbihGoal() async {
    final tasbihGoal = int.tryParse(_goalController.text);

    if (tasbihGoal == null || tasbihGoal <= 0) {
      // Show error if input is invalid
      _showSnackBar('Please enter a valid goal greater than 0.');
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://$localhost/api/updateTasbihGoal/$RoutineID'), // Use the actual API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}', // Replace with actual token
        },
        body: json.encode({'tasbihGoal': tasbihGoal}),
      );

      if (response.statusCode == 200) {
        setState(() {
          goalCount = tasbihGoal; // Update the goalCount
        });

        _showSnackBar('Tasbih goal updated successfully!');
      } else {
        // Handle API error response
        _showSnackBar('Failed to update goal. Please try again.');
      }
    } catch (e) {
      // Handle error if the request fails
      _showSnackBar('An error occurred. Please try again.');
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

  @override
  Widget build(BuildContext context) {
    return Padding(
     
     // backgroundColor: Colors.grey[50],
   
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Inspirational Quote
                /*  Align(
                    alignment: Alignment.centerRight,
                    child:
                  IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Enter Tasbih Goal',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: TextField(
                        controller: _goalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter number',
                          labelStyle: GoogleFonts.montserrat(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: GoogleFonts.montserrat(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            updateTasbihGoal(); // Call the update function with the routineId
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: GoogleFonts.montserrat(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.edit),
              tooltip: 'Set Tasbih Goal',
              color: Theme.of(context).primaryColor,
            ),
            ),
            */
      
                  Text(
                    '\"فَاذْكُرُونِي أَذْكُرْكُمْ\"',
                    style: GoogleFonts.montserrat(
                      fontSize: 24.0,
                      color: Theme.of(context).primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          children: [
  Text(
                          'Goal: $goalCount ',
                          style: GoogleFonts.montserrat(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      //  SizedBox(width: 20,),
                          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Enter Tasbih Goal',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: TextField(
                        controller: _goalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter number',
                          labelStyle: GoogleFonts.montserrat(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: GoogleFonts.montserrat(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            updateTasbihGoal(); // Call the update function with the routineId
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: GoogleFonts.montserrat(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.edit),
              tooltip: 'Set Tasbih Goal',
              color: Theme.of(context).primaryColor,
            ),
            
                        ],),
                      
                  // Tasbih Goal and Progress
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                     /*   Row(children: [
  Text(
                          'Goal: $goalCount ',
                          style: GoogleFonts.montserrat(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      //  SizedBox(width: 20,),
                          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Enter Tasbih Goal',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: TextField(
                        controller: _goalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter number',
                          labelStyle: GoogleFonts.montserrat(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: GoogleFonts.montserrat(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            updateTasbihGoal(); // Call the update function with the routineId
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: GoogleFonts.montserrat(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.edit),
              tooltip: 'Set Tasbih Goal',
              color: Theme.of(context).primaryColor,
            ),
            
                        ],),
                      */
                        SizedBox(height: 15),
                        CircularPercentIndicator(
                          radius: 100.0,
                          lineWidth: 12.0,
                          percent: getProgress(),
                          center: Text(
                            "${(getProgress() * 100).toStringAsFixed(0)}%",
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          progressColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey[300]!,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  // Count and Reset Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Count Button
                      ElevatedButton(
                        onPressed: incrementCount,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12),
                          child: Text(
                            'Count',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      // Reset Button
                      ElevatedButton(
                        onPressed: resetCount,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12),
                          child: Text(
                            'Reset',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Replace with actual token
        },
      );
      print("response is $response");
      print("response status code is ${response.statusCode}");
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
        print("error is $error");
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

  // Function to update the tasbih count by making an API call
  Future<Map<String, dynamic>> updateTasbihCount(
      String routineId, int tasbihCompleted) async {
    final url = Uri.parse('$baseUrl/api/updateTasbihCount/$routineId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Replace with actual token
        },
        body: json.encode({'tasbihCompleted': tasbihCompleted}),
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
          'message': error['message'] ?? 'Failed to update tasbih count',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Function to update the tasbih goal by making an API call
  Future<Map<String, dynamic>> updateTasbihGoal(
      String routineId, int tasbihGoal) async {
    final url = Uri.parse('$baseUrl/api/updateTasbihGoal/$routineId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Replace with actual token
        },
        body: json.encode({'tasbihGoal': tasbihGoal}),
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
          'message': error['message'] ?? 'Failed to update tasbih goal',
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
