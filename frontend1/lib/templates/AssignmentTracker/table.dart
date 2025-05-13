// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:frontend1/templates/AssignmentTracker/CoursesModel.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// class CourseTable extends StatefulWidget {
//   final List<Course> courses;
// final String token;
// final String templateId;
// final String? AllCoursesArrayId;
//   CourseTable({required this.courses,required this.token,required this.AllCoursesArrayId ,required this.templateId});

//   @override
//   _CourseTableState createState() => _CourseTableState();
// }

// class _CourseTableState extends State<CourseTable> {

//   Future<void> _addAssignment(Course course) async {
    
//     // Prepare the data to be sent to the API
//     final assignmentData = {
//       'allCoursesId': widget.AllCoursesArrayId, // Assuming 'id' is the identifier for the course
//       'courseName': course.name,
//       'assignmentName': 'New Assignment',
//       'values': [DateTime.now().toIso8601String(), 'Incomplete', '0', '0', 'Description here'],
//     };

//     // Convert the data to JSON
//     final body = json.encode(assignmentData);

//     try {
//       // Make the POST request to your API
//       final response = await http.post(
//         Uri.parse('http://$localhost/api/newAssignment'), // Replace with your actual API endpoint
//         headers: {
//           'Content-Type': 'application/json',
//            'Authorization': 'Bearer ${widget.token}',
//         },
//         body: body,
//       );

//       // Check the response status
//       if (response.statusCode == 201) {
//           final responseData = json.decode(response.body);
//           print("assignemt created successfully");
//         // If the assignment was created successfully, update the local state
//         setState(() {
//           print("before adding");
//           course.assignments.add(
//             Assignment(
//               id: responseData['assignment'], // This can be updated to reflect the actual ID returned from the API if needed
//               assignmentName: 'New Assignment',
//               values: [DateTime.now().toIso8601String(), 'Incomplete', '0', '0', 'Description here'],
//             ),
//           );
//           print("inside set state");
//         });
//       } else {
//         // Handle error response
//         final errorResponse = json.decode(response.body);
//         throw Exception(errorResponse['message']);
//       }
//     } catch (error) {
//       // Handle network errors or other exceptions
//       print('Failed to add assignment: $error');
//       // You can show a message to the user if needed
//     }
  
// }


// // Function to update the assignment name
// Future<void> updateAssignmentName(String assignmentId, String newAssignmentName) async {
//   final String url = 'http://$localhost/api/EditAssignmentName/$assignmentId'; // Replace with your actual API endpoint

//   // Prepare the data to be sent to the API
//   final Map<String, dynamic> requestData = {
//     'assignmentName': newAssignmentName,
//   };

//   try {
//     // Make the PATCH request to your API
//     final response = await http.put(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${widget.token}', // Add your token if needed
//       },
//       body: json.encode(requestData),
//     );

//     // Check the response status
//     if (response.statusCode == 200) {
//       // Successfully updated the assignment name
//       final updatedAssignment = json.decode(response.body);
//       print('Assignment name updated: $updatedAssignment');
//       // You can also update the local state or notify the user if needed
//     } else {
//       // Handle error response
//       final errorResponse = json.decode(response.body);
//       throw Exception(errorResponse['message']);
//     }
//   } catch (error) {
//     // Handle network errors or other exceptions
//     print('Failed to update assignment name: $error');
//   }
// }

// Future<void> updateAssignment(String assignmentId, List<dynamic> newValues) async {
//   print("inside updateAssignment assignmentid is $assignmentId");
//   final String url = 'http://$localhost/api/Assignment/$assignmentId'; // Replace with your actual API endpoint
//   // Prepare the data to be sent to the API
//   final Map<String, dynamic> requestData = {
//     'values': newValues,
//   };
//   try {
//     // Make the PATCH request to your API
//     final response = await http.put(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${widget.token}', // Add your token if needed
//       },
//       body: json.encode(requestData),
//     );

//     // Check the response status
//     if (response.statusCode == 200) {
//       // Successfully updated the assignment
//       final updatedAssignment = json.decode(response.body);
//       print('Assignment updated: $updatedAssignment');
//         await  Provider.of<CourseProvider>(context, listen: false).fetchCourses(widget.templateId,widget.token,);
//       // You can also update the local state or notify the user if needed
//     } else {
//       // Handle error response
//       final errorResponse = json.decode(response.body);
//       throw Exception(errorResponse['message']);
//     }
//   } catch (error) {
//     // Handle network errors or other exceptions
//     print('Failed to update assignment: $error');
//   }
// }
//   void _showDatePicker(int courseIndex, int assignmentIndex) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.parse(widget.courses[courseIndex].assignments[assignmentIndex].values![0]),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     setState(() {
//       widget.courses[courseIndex].assignments[assignmentIndex].values![0] = selectedDate?.toIso8601String();
//     });
//     }

//   Widget _buildEditableCell(String initialValue, void Function(String) onSubmit) {
//     TextEditingController controller = TextEditingController(text: initialValue);
//     FocusNode focusNode = FocusNode();

//     focusNode.addListener(() {
//       if (!focusNode.hasFocus) {
//         onSubmit(controller.text);
//       }
//     });

//     return TextField(
//       controller: controller,
//       focusNode: focusNode,
//       onSubmitted: onSubmit,
//       decoration: InputDecoration(border: InputBorder.none),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(  // Wrapping in SingleChildScrollView for overflow handling
    
//       child: Column(
        
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: widget.courses.map((course) {
//           int courseIndex = widget.courses.indexOf(course);  // Get the index of the course
//           return Padding(
            
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   course.name,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
                    
//                     columns: [
//                       DataColumn(label: Text('Assignment Name')),
//                       DataColumn(label: Text('Due Date')),
//                       DataColumn(label: Text('Status')),
//                       DataColumn(label: Text('Mark')),
//                       DataColumn(label: Text('Weight')),
//                       DataColumn(label: Text('Description')),
//                     ],
//                     rows: course.assignments.map((assignment) {
//                       int assignmentIndex = course.assignments.indexOf(assignment);
//                       return DataRow(cells: [
//                         DataCell(_buildEditableCell(assignment.assignmentName, (value) {
//                           setState(() {
//                             assignment.assignmentName = value;
//                          updateAssignmentName(assignment.id!,value);
//                           });
//                         })),
//                         DataCell(TextButton(
//                           child: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(assignment.values![0]))),
//                           onPressed: () => _showDatePicker(courseIndex, assignmentIndex),
//                         )),
//                         DataCell(_buildEditableCell(assignment.values![1].toString(), (value) {
//                           setState(() {
//                             assignment.values![1] = value;
//                               updateAssignment(assignment.id!,assignment.values!);
                           
//                           });
//                         })),
//                         DataCell(_buildEditableCell(assignment.values?[2]?.toString() ?? '0', (value) {
//                           setState(() {
//                             assignment.values![2] = int.tryParse(value) ?? 0;
//                               updateAssignment(assignment.id!,assignment.values!);
//                           });
//                         })),
//                         DataCell(_buildEditableCell(assignment.values?[3]?.toString() ?? '0', (value) {
//                           setState(() {
//                             assignment.values![3] = int.tryParse(value) ?? 0;
//                             updateAssignment(assignment.id!,assignment.values!);
//                           });
//                         })),
//                         DataCell(_buildEditableCell(assignment.values?[4]?.toString() ?? 'Description here', (value) {
//                           setState(() {
//                             assignment.values![4] = value;
//                               updateAssignment(assignment.id!,assignment.values!);
//                           });
//                         })),
//                       ]);
//                     }).toList(),
//                   ),
//                 ),
//                 TextButton(
//   onPressed: () {
//     // Action on press
//     _addAssignment(course);
//   },
//   child: Text(
//     "+New",
//     style: TextStyle(fontSize: 15,color: const Color.fromARGB(255, 184, 178, 178)),
//   ),
// ),

//                 /*
//                 ElevatedButton(
//                   onPressed: () => _addAssignment(course),
//                   child: Text('Add New Assignment'),
//                 ),
//                 */
//                 Divider(),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/AssignmentTracker/CoursesModel.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseTable extends StatefulWidget {
  final List<Course> courses;
  final String token;
  final String templateId;
  final String? AllCoursesArrayId;

  const CourseTable({super.key, required this.courses, required this.token, required this.AllCoursesArrayId, required this.templateId});

  @override
  _CourseTableState createState() => _CourseTableState();
}

class _CourseTableState extends State<CourseTable> {
  Future<void> _addAssignment(Course course) async {
    final assignmentData = {
      'allCoursesId': widget.AllCoursesArrayId,
      'courseName': course.name,
      'assignmentName': 'New Assignment',
      'values': [DateTime.now().toIso8601String(), 'Incomplete', '0', '0', 'Description here'],
    };

    final body = json.encode(assignmentData);

    try {
      final response = await http.post(
        Uri.parse('http://$localhost/api/newAssignment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        setState(() {
          course.assignments.add(
            Assignment(
              id: responseData['assignment'],
              assignmentName: 'New Assignment',
              values: [DateTime.now().toIso8601String(), 'Incomplete', '0', '0', 'Description here'],
            ),
          );
        });
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message']);
      }
    } catch (error) {
      print('Failed to add assignment: $error');
    }
  }

  Future<void> updateAssignmentName(String assignmentId, String newAssignmentName) async {
    final String url = 'http://$localhost/api/EditAssignmentName/$assignmentId';

    final Map<String, dynamic> requestData = {
      'assignmentName': newAssignmentName,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final updatedAssignment = json.decode(response.body);
        print('Assignment name updated: $updatedAssignment');
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message']);
      }
    } catch (error) {
      print('Failed to update assignment name: $error');
    }
  }

  Future<void> updateAssignment(String assignmentId, List<dynamic> newValues) async {
    final String url = 'http://$localhost/api/Assignment/$assignmentId';

    final Map<String, dynamic> requestData = {
      'values': newValues,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final updatedAssignment = json.decode(response.body);
        print('Assignment updated: $updatedAssignment');
        await Provider.of<CourseProvider>(context, listen: false).fetchCourses(widget.templateId, widget.token);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message']);
      }
    } catch (error) {
      print('Failed to update assignment: $error');
    }
  }

  void _showDatePicker(int courseIndex, int assignmentIndex) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.courses[courseIndex].assignments[assignmentIndex].values![0]),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    setState(() {
      widget.courses[courseIndex].assignments[assignmentIndex].values![0] = selectedDate?.toIso8601String();
    });
  }

  Widget _buildEditableCell(String initialValue, void Function(String) onSubmit) {
    TextEditingController controller = TextEditingController(text: initialValue);
    FocusNode focusNode = FocusNode();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        onSubmit(controller.text);
      }
    });

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onSubmitted: onSubmit,
      style: GoogleFonts.montserrat(fontSize: 14),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintStyle: GoogleFonts.montserrat(color: Colors.grey[400]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.courses.map((course) {
          int courseIndex = widget.courses.indexOf(course);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                    columns: [
                      DataColumn(
                          label: Text(
                        'Assignment Name',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      )),
                      DataColumn(
                          label: Text(
                        'Due Date',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      )),
                      DataColumn(
                          label: Text(
                        'Status',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      )),
                      DataColumn(
                          label: Text(
                        'Mark',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      )),
                      DataColumn(
                          label: Text(
                        'Weight',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      )),
                      DataColumn(
                          label: Text(
                        'Description',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      )),
                    ],
                    rows: course.assignments.map((assignment) {
                      int assignmentIndex = course.assignments.indexOf(assignment);
                      return DataRow(cells: [
                        DataCell(_buildEditableCell(assignment.assignmentName, (value) {
                          setState(() {
                            assignment.assignmentName = value;
                            updateAssignmentName(assignment.id!, value);
                          });
                        })),
                        DataCell(TextButton(
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(DateTime.parse(assignment.values![0])),
                            style: GoogleFonts.montserrat(),
                          ),
                          onPressed: () => _showDatePicker(courseIndex, assignmentIndex),
                        )),
                        DataCell(_buildEditableCell(assignment.values![1].toString(), (value) {
                          setState(() {
                            assignment.values![1] = value;
                            updateAssignment(assignment.id!, assignment.values!);
                          });
                        })),
                        DataCell(_buildEditableCell(assignment.values?[2]?.toString() ?? '0', (value) {
                          setState(() {
                            assignment.values![2] = int.tryParse(value) ?? 0;
                            updateAssignment(assignment.id!, assignment.values!);
                          });
                        })),
                        DataCell(_buildEditableCell(assignment.values?[3]?.toString() ?? '0', (value) {
                          setState(() {
                            assignment.values![3] = int.tryParse(value) ?? 0;
                            updateAssignment(assignment.id!, assignment.values!);
                          });
                        })),
                        DataCell(_buildEditableCell(assignment.values?[4]?.toString() ?? 'Description here', (value) {
                          setState(() {
                            assignment.values![4] = value;
                            updateAssignment(assignment.id!, assignment.values!);
                          });
                        })),
                      ]);
                    }).toList(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => _addAssignment(course),
                    child: Text(
                      '+ New',
                      style: GoogleFonts.montserrat(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                ),
                Divider(color: Colors.grey[300]),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}


