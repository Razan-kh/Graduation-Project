// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:frontend1/pages/Template.dart';
// import 'package:frontend1/templates/AssignmentTracker/CoursesModel.dart';
// import 'package:frontend1/templates/AssignmentTracker/table.dart';

// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart'; // For date formatting

// IconData getIconFromName(String iconName) {
//   switch (iconName) {
//     case 'calculate_outlined':
//       return Icons.calculate_outlined;
//     case 'school':
//       return Icons.school;
//     case 'computer_rounded':
//       return Icons.computer_rounded;
//     case 'science_outlined':
//       return Icons.science_outlined;
//     // Add more mappings as needed
//     default:
//       return Icons.edit_note; // Default icon if no match is found
//   }
// }

// class CourseScreen extends StatefulWidget {
//   final String templateId;
//   final String token;

//   const CourseScreen({
//     Key? key,
//     required this.token,
//     required this.templateId,
//   }) : super(key: key);

//   @override
//   _CourseScreenState createState() => _CourseScreenState();
// }

// class _CourseScreenState extends State<CourseScreen> {
//   List<Course> courses = [];
//   List<Assignment> allAssignments = []; // Store all assignments

//   Template? template;
  
//   @override
//   void initState() {
//     super.initState();
//      Provider.of<CourseProvider>(context, listen: false).fetchCourses(widget.templateId,widget.token,);
//   }
  

// // Function to update the assignment name
//   Future<void> AddCourse(String newCourseName) async {
//     template =
//         await Template.fetchTemplateData(widget.templateId, widget.token);

//     final String url =
//         'http://$localhost/api/Add_Course/${template?.data}'; // Replace with your actual API endpoint

//     // Prepare the data to be sent to the API

//     print("token is ${widget.token}");
//     print("template data is ${template?.data}");
//     try {
//       // Make the PATCH request to your API
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${widget.token}', // Add your token if needed
//         },
//         body: json.encode({"name": newCourseName}),
//       );

//       // Check the response status
//       if (response.statusCode == 201) {
//         // Successfully updated the assignment name
//         final data = json.decode(response.body);
//         final newCourse = data['data'];
//         print('Course created: $newCourse');
//         await Provider.of<CourseProvider>(context, listen: false)
//             .fetchCourses(widget.templateId, widget.token);
//         setState(() {
//           courses = Provider.of<CourseProvider>(context, listen: false).courses;
//         });
//         /*
//       setState(() {
//             courses.add(newCourse);
//       });
//   */
//         // You can also update the local state or notify the user if needed
//       } else {
//         // Handle error response
//         final errorResponse = json.decode(response.body);
//         throw Exception(errorResponse['message']);
//       }
//     } catch (error) {
//       // Handle network errors or other exceptions
//       print('Failed to create new Course: $error');
//     }
//   }

//   void _showAddCourseDialog() {
//     final TextEditingController nameController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add New Course'),
//           content: TextField(
//             controller: nameController,
//             decoration: InputDecoration(labelText: 'Course Name'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final String courseName = nameController.text;
//                 if (courseName.isNotEmpty) {
//                   //    Provider.of<CourseProvider>(context, listen: false).AddCourse(courseName,widget.token,widget.templateId);
//                   // AddCourse(courseName).then((_) =>   Provider.of<CourseProvider>(context, listen: false).fetchCourses(widget.templateId,widget.token,));
//                   await AddCourse(courseName);
//                   //  await   Provider.of<CourseProvider>(context, listen: false).fetchCourses(widget.templateId, widget.token);

//                   // courses =   await Provider.of<CourseProvider>(context, listen: false).courses;
//                   /*
//    setState(()async {
//       courses=courses0;
//    });
// */
//                   // Logic to save the new course can be added here

//                   Navigator.of(context).pop(); // Close the dialog
//                 }
//               },
//               child: Text('Add Course'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _addAssignment(int courseIndex) {
//     setState(() {
//       // Add a new assignment with placeholder values
//       courses[courseIndex].assignments.add(
//             Assignment(
//                 id: null, assignmentName: '', values: ['', '', '', '', '']),
//           );
//     });
//   }

//   void _showDatePicker(int courseIndex, int assignmentIndex) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     setState(() {
//       // Update the date value in the assignment
//       //  courses[courseIndex].assignments[assignmentIndex].values[0] = DateFormat('yyyy-MM-dd').format(selectedDate);
//     });
//     }

//   Widget _buildEditableCell(
//       String initialValue, void Function(String) onSubmit) {
//     TextEditingController controller =
//         TextEditingController(text: initialValue);
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
//     final data = context.watch<CourseProvider>();

//     courses = data.courses;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.menu_book,
//                   color: Color.fromARGB(255, 238, 187, 187)),
//               onPressed: () {
//                 // Navigate back or perform any action
//               },
//             ),
//             Text(
//               'Courses Tracker',
//               style: GoogleFonts.agdasima(color: Colors.black),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: ListView(
//         scrollDirection: Axis.vertical,
//         padding: EdgeInsets.all(16.0),
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.asset(
//               'lib/images/study.png',
//               height: 200,
//               width: double.infinity,
//               fit: BoxFit.fill,
//             ),
//           ),
//           SizedBox(height: 15.0),
//           Text(
//             'Work hard in silence\n Let success make the noise',
//             style: GoogleFonts.dancingScript(
//                 fontSize: 30.0, color: Color(0xffF49595)),
//             textAlign: TextAlign.center,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       child: SfCartesianChart(
//                         title: ChartTitle(
//                           text: 'Course Marks',
//                           textStyle: GoogleFonts.agdasima(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFFEAC7C7),
//                           ),
//                         ),
//                         primaryXAxis: CategoryAxis(
//                           // Adjust the minimum and maximum of the X-axis to add space
//                           minimum: 0, // Start from 0 (left padding)
//                           maximum: courses.length
//                               .toDouble(), // Set maximum based on the number of bars
//                           majorGridLines: MajorGridLines(width: 0),
//                           axisLine: AxisLine(width: 1),
//                           // Optional: Adds axis line
//                         ),
//                         primaryYAxis: NumericAxis(
//                           title: AxisTitle(text: 'Marks'),
//                         ),
//                         series: <ChartSeries>[
//                           ColumnSeries<Course, String>(
//                             dataSource: courses,
//                             xValueMapper: (Course course, _) => course.name,
//                             yValueMapper: (Course course, _) => course.mark,
//                             dataLabelSettings:
//                                 DataLabelSettings(isVisible: true),
//                             width: 0.3, // Fixed bar width
//                             spacing: 0.3, // Spacing between bars
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment:
//                 MainAxisAlignment.start, // Aligns the button to the left
//             children: [
//               TextButton(
//                 onPressed: () {
//                   // Action on press
//                   _showAddCourseDialog();
//                 },
//                 child: Text(
//                   "Add Course",
//                   style: TextStyle(
//                       fontSize: 15,
//                       color: const Color.fromARGB(255, 134, 169, 189)),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           ...courses.asMap().entries.map((entry) {
//             int index = entry.key; // Get the index
//             var course = entry.value; // Get the course object

//             return Card(
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Row(
//                       children: [
//                         Icon(getIconFromName(course.icon)),
//                         SizedBox(width: 10),
//                         Text(course.name),
//                       ],
//                     ),
//                     trailing: Text(course.mark.toString()),
//                     onLongPress: () {
//                       // Show the delete confirmation dialog
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text('Delete Course?'),
//                             content: Text(
//                                 'Are you sure you want to delete ${course.name}?'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context)
//                                       .pop(); // Close the dialog
//                                 },
//                                 child: Text('Cancel'),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   // Call deleteCourse with the course and index
//                                   deleteCourseByIndex(index, template?.data);
//                                   Navigator.of(context)
//                                       .pop(); // Close the dialog after deletion
//                                 },
//                                 child: Text('Yes'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           }),
//           CourseTable(
//             courses: courses,
//             token: widget.token,
//             AllCoursesArrayId: template?.data,
//             templateId: widget.templateId,
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> deleteCourseByIndex(int index, String? allCoursesId) async {
//     //print(allCoursesId);
//     //print(index);
//     template =
//         await Template.fetchTemplateData(widget.templateId, widget.token);
//     if (allCoursesId == null) allCoursesId = template?.data;
//     try {
//       final response = await http.delete(
//         Uri.parse(
//             'http://$localhost/api/allCourses/$allCoursesId/courses/$index'),
//         headers: {
//           'Authorization':
//               'Bearer ${widget.token}', // Add your token for authentication
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         // Successfully deleted the course
//         setState(() {
//           courses.removeAt(index); // Update the local courses list
//         });
//         print('Course at index $index deleted successfully.');
//       } else {
//         // Handle failure
//         print(
//             'Failed to delete the course. Status code: ${response.statusCode}');
//         print('Response: ${response.body}');
//       }
//     } catch (e) {
//       print('An error occurred while deleting the course: $e');
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/Template.dart';
import 'package:frontend1/templates/AssignmentTracker/CoursesModel.dart';
import 'package:frontend1/templates/AssignmentTracker/table.dart';
import 'package:frontend1/templates/sideBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
// For date formatting

IconData getIconFromName(String iconName) {
  switch (iconName) {
    case 'calculate_outlined':
      return Icons.calculate_outlined;
    case 'school':
      return Icons.school;
    case 'computer_rounded':
      return Icons.computer_rounded;
    case 'science_outlined':
      return Icons.science_outlined;
    default:
      return Icons.edit_note;
  }
}

class CourseScreen extends StatefulWidget {
  final String templateId;
  final String token;

  const CourseScreen({
    super.key,
    required this.token,
    required this.templateId,
  });

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List<Course> courses = [];
  List<Assignment> allAssignments = [];

  Template? template;
    final ScrollController _scrollController = ScrollController();
   List<GlobalKey> _tableKeys = [];
   
  @override
  void initState() {
    super.initState();
   
       WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<CourseProvider>(context, listen: false)
        .fetchCourses(widget.templateId, widget.token)
        .then((_) {
      setState(() {
        // Update _tableKeys to match the fetched courses
     courses = Provider.of<CourseProvider>(context, listen: false).courses;
        _tableKeys = List.generate(courses.length, (index) => GlobalKey());
          print("_tableKeys length ${_tableKeys.length}");
        print("courses length ${courses.length}");
      });
    });
  });

  // Initialize _tableKeys as an empty list initially
  _tableKeys = [];
}
 
void scrollToTable(int index) {
     
  print(index);
  if (index >= 0 && index < _tableKeys.length) {
    final targetContext = _tableKeys[index].currentContext;
    if (targetContext != null) {
      print("target content");
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  } else {
    print("Invalid index: $index");
  }
}



  Future<void> AddCourse(String newCourseName) async {
    template = await Template.fetchTemplateData(widget.templateId, widget.token);
    final String url = 'http://$localhost/api/Add_Course/${template?.data}';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({"name": newCourseName}),
      );

      if (response.statusCode == 201) {
        await Provider.of<CourseProvider>(context, listen: false).fetchCourses(widget.templateId, widget.token);
        setState(() {
          courses = Provider.of<CourseProvider>(context, listen: false).courses;
           _tableKeys = List.generate(courses.length, (_) => GlobalKey());
        });
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message']);
      }
    } catch (error) {
      print('Failed to create new Course: $error');
    }
  }

  void _showAddCourseDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Add New Course',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Course Name',
              labelStyle: GoogleFonts.montserrat(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                final String courseName = nameController.text;
                if (courseName.isNotEmpty) {
                  await AddCourse(courseName);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Add Course',
                style: GoogleFonts.montserrat(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCourseByIndex(int index, String? allCoursesId) async {
    template = await Template.fetchTemplateData(widget.templateId, widget.token);
    allCoursesId ??= template?.data;
    try {
      final response = await http.delete(
        Uri.parse('http://$localhost/api/allCourses/$allCoursesId/courses/$index'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          courses.removeAt(index);
           _tableKeys.removeAt(index);
        });
      } else {
        print('Failed to delete the course: ${response.body}');
      }
    } catch (e) {
      print('Error while deleting the course: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<CourseProvider>();
bool isWeb=MediaQuery.of(context).size.width>1200? true: false;

    courses = data.courses;
    return Scaffold(
      appBar: isWeb ? null : AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Courses Tracker',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: Row(
  children: [
      if (isWeb) WebSidebar(),
    if (isWeb) SizedBox(width: 100), // Spacer for web layout
   Expanded(
          flex: 5, // Adjust flex to allocate space proportionally
  
      child:   SingleChildScrollView(
         controller: _scrollController,
  child:Column(
      //  padding: EdgeInsets.all(16.0),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
           // Image.network('https://cors-anywhere.herokuapp.com/<image-url>');

            child: Image.asset(
              'lib/images/a.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 15.0),
         Text(
                    'Work hard in silence Let success make the noise',
                    style: GoogleFonts.handlee(
                      fontSize: 28,
                      color: Colors.black87,
                    ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          SfCartesianChart(
            title: ChartTitle(
              text: 'Course Marks',
              textStyle: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: 'Marks',
                textStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
                 series: <ChartSeries<Course, String>>[
              ColumnSeries<Course, String>(
                dataSource: courses,
                xValueMapper: (Course course, _) => course.name,
                yValueMapper: (Course course, _) => course.mark,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                width: 0.3,
                spacing: 0.3,
              ),
            ],
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _showAddCourseDialog,
              child: Text(
                "Add Course",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ...courses.asMap().entries.map((entry) {
            int index = entry.key;
            var course = entry.value;

            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(getIconFromName(course.icon), color: Colors.blue),
                title: Text(
                  course.name,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  course.mark.toString(),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                 onTap: () {
                      scrollToTable(index);
                    },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Course?'),
                        content: Text('Are you sure you want to delete ${course.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteCourseByIndex(index, template?.data);
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          }),
         ...courses.asMap().entries.map((entry) {
            int index = entry.key;
            var course = entry.value;
            print(index);
            return courses.isNotEmpty && index < _tableKeys.length
                ? Container(
                    key: _tableKeys[index],
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: CourseTable(
                      courses: [course],
                      token: widget.token,
                      AllCoursesArrayId: template?.data,
                      templateId: widget.templateId,
                    ),
                  )
                : SizedBox();
          }),
      
        ],
      ),
       )
      ),
      
      if (isWeb) SizedBox(width: 100), // Spacer for web layout
        //  if (isWeb) Expanded(flex: 1, child: SizedBox(width:100)), // Dynamic Spacer
  ]
      ),
 bottomNavigationBar:  isWeb?SizedBox.shrink():  _footer(),  
    );
  }
  
  Widget _footer() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: Colors.grey, size: 28),
            Icon(Icons.search, color: Colors.grey, size: 28),
            Icon(Icons.folder, color: Colors.grey, size: 28),
            Icon(Icons.edit, color: Colors.grey, size: 28),
          ],
        ),
      ),
    );
  }
}
