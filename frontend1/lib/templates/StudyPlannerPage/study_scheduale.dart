// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class StudyScheduleApp extends StatefulWidget {
//   @override
//   _StudyScheduleAppState createState() => _StudyScheduleAppState();
// }

// class _StudyScheduleAppState extends State<StudyScheduleApp> {
//   List<List<String>> scheduleData = List.generate(
//     6,
//     (_) => List.filled(7, ""), // 6 rows, 7 columns filled with empty strings
//   );

//   final List<String> timeSlots = [
//     "8:00-9:00 am",
//     "10:00-11:00 am",
//     "11:00-12:00 pm",
//     "2:00-4:00 pm",
//     "5:00-6:00 pm",
//     "7:00-8:00 pm",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
      
//       scrollDirection: Axis.horizontal, // Horizontal scrolling for the table
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical, // Vertical scrolling for the table
//         child: Table(
//           defaultColumnWidth: FixedColumnWidth(120.0), // Adjusted column width
//           border: TableBorder.all(color: const Color.fromARGB(255, 240, 238, 238), width: 1.5), // Light gray border color
//           children: [
//             // Header row with styled background applied to each cell
//             TableRow(
//               children: [
//                 TableCell(
//                   child: Container(

//                     color: const Color.fromARGB(255, 229, 227, 227),
//                     padding: const EdgeInsets.all(12.0),
//                     child: Center(
//                       child: Text(
//                         'Times',
//                         style: TextStyle(
//                           fontFamily: 'Georgia',
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 for (String day in ['Mon', 'Tues', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
//                   TableCell(
//                     child: Container(
//                       color: const Color.fromARGB(255, 229, 227, 227),
//                       padding: const EdgeInsets.all(12.0),
//                       child: Center(
//                         child: Text(
//                           day,
//                           style: TextStyle(
//                             fontFamily: 'Georgia',
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: const Color.fromARGB(255, 46, 97, 138),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             // Populate the table with time slots and editable cells
//             for (int i = 0; i < timeSlots.length; i++)
//               TableRow(
//                 children: [
//                   TableCell(
//                     child: Container(
//                       color: const Color.fromARGB(255, 229, 227, 227),
//                       padding: const EdgeInsets.all(12.0),
//                       child: Center(
//                         child: Text(
//                           timeSlots[i],
//                           style: TextStyle(
//                             fontFamily: 'Georgia',
//                             fontSize: 16,
//                             color: Colors.black87,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   for (int j = 0; j < 7; j++)
//                     TableCell(
//                       child: Container(
//                         // Make the entire cell editable
//                         height: 60.0, // Set a fixed height for cells to avoid overflow issues
//                         padding: EdgeInsets.zero, // Remove any padding for full cell coverage
//                         child: TextField(
//                           onChanged: (value) {
//                             scheduleData[i][j] = value;
//                           },
//                           decoration: InputDecoration(
//                             border: InputBorder.none, // No border to blend with the table
//                             contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
//                           ),
//                           style: TextStyle(
//                             fontFamily: 'Georgia',
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class StudyScheduleApp extends StatefulWidget {
  final String token;
  final String templateId;

  const StudyScheduleApp({super.key, required this.token, required this.templateId});

  @override
  _StudyScheduleAppState createState() => _StudyScheduleAppState();
}

class _StudyScheduleAppState extends State<StudyScheduleApp> {
  List<List<TextEditingController>> scheduleControllers = [];
  List<List<String>> scheduleData = List.generate(
    6,
    (_) => List.filled(7, ""), // 6 rows, 7 columns filled with empty strings
  );

  final List<String> timeSlots = [
    "8:00-9:00 am",
    "10:00-11:00 am",
    "11:00-12:00 pm",
    "2:00-4:00 pm",
    "5:00-6:00 pm",
    "7:00-8:00 pm",
  ];

  @override
void initState() {
  super.initState();
  initializeControllers();
  fetchStudySchedule(); // Fetch schedule after initializing controllers
}

void initializeControllers() {
  setState(() {
    scheduleControllers = List.generate(
      timeSlots.length, // 6 rows for the time slots
      (i) => List.generate(7, (j) => TextEditingController()), // 7 columns for the days
    );
  });
}


  Future<void> fetchStudySchedule() async {
    try {
      final response = await http.get(
        Uri.parse('http://$localhost/api/studentplanner/study-schedule/${widget.templateId}'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> studySchedule = data['studySchedule'];

        setState(() {
          for (var entry in studySchedule) {
            int rowIndex = timeSlots.indexOf(entry['timeSlot']);
            int colIndex = getColumnIndex(entry['day']);
            if (rowIndex != -1 && colIndex != -1) {
              scheduleData[rowIndex][colIndex] = entry['task'];
              scheduleControllers[rowIndex][colIndex].text = entry['task'];
            }
          }
        });
      } else {
        print('Failed to load schedule data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> updateScheduleEntry(String day, String timeSlot, String task) async {
    try {
      final response = await http.post(
        Uri.parse('http://$localhost/api/studentplanner/study-schedule'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'templateId': widget.templateId,
          'entry': {
            'day': day,
            'timeSlot': timeSlot,
            'task': task,
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Schedule entry updated successfully');
      } else {
        print('Failed to update schedule entry');
      }
    } catch (error) {
      print('Error updating schedule entry: $error');
    }
  }

  int getColumnIndex(String day) {
    const daysOfWeek = ['Mon', 'Tues', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return daysOfWeek.indexOf(day);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          defaultColumnWidth: FixedColumnWidth(120.0),
          border: TableBorder.all(
              color: const Color.fromARGB(255, 240, 238, 238), width: 1.5),
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    color: const Color.fromARGB(255, 229, 227, 227),
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        'Times',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                for (String day in ['Mon', 'Tues', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
                  TableCell(
                    child: Container(
                      color: const Color.fromARGB(255, 229, 227, 227),
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 46, 97, 138),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            for (int i = 0; i < timeSlots.length; i++)
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      color: const Color.fromARGB(255, 229, 227, 227),
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          timeSlots[i],
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  for (int j = 0; j < 7; j++)
                    TableCell(
                      child: Container(
                        height: 60.0,
                        padding: EdgeInsets.zero,
                        child: TextField(
                          controller: scheduleControllers[i][j],
                          onChanged: (value) {
                            scheduleData[i][j] = value;
                            updateScheduleEntry(
                              ['Mon', 'Tues', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][j],
                              timeSlots[i],
                              value,
                            );
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
