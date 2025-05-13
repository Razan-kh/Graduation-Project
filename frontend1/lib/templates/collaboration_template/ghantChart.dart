// import 'dart:ui';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:frontend1/templates/collaboration_template/TaskModel.dart';
// import 'package:frontend1/templates/collaboration_template/settings.dart';
// import 'package:gantt_chart/gantt_chart.dart';
// import 'dart:convert';
// import 'package:frontend1/config.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';

// bool showDaysRow = true;
// double dayWidth = 30;
// bool showStickyArea = false;
// bool customStickyArea = false;
// bool customWeekHeader = false;
// bool customDayHeader = false;
// DateTime? selectedDate;
// final customHolidays = [
//   DateTime(2022, 7, 1),
//   DateTime(2022, 7, 4),
//   DateTime(2022, 12, 25),
// ];

// class MyCustomScrollBehavior extends MaterialScrollBehavior {
//   // Override behavior methods and getters like dragDevices
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//         PointerDeviceKind.touch,
//         PointerDeviceKind.mouse,
//         PointerDeviceKind.trackpad
//       };
// }

// class CustomGanttChart extends StatefulWidget {
//   final String token;
//   final String templateId;

//   CustomGanttChart({required this.token, required this.templateId});

//   @override
//   CustomGanttChartStatet createState() => CustomGanttChartStatet();
// }

// class CustomGanttChartStatet extends State<CustomGanttChart> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       scrollBehavior: MyCustomScrollBehavior(),
//       title: 'Gantt Chart',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: MyHomePage(token: widget.token, templateId: widget.templateId),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   final String token;
//   final String templateId;

//   MyHomePage({required this.token, required this.templateId});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final scrollController = ScrollController();
//   late Future<List<Task>> futureTasks;

//   Future<List<Task>> fetchTasksGantt(String templateID) async {
//     final response = await http.get(
//       Uri.parse('http://$localhost/api/project-templates/$templateID/tasks'),
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//       },
//     );
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((task) => Task.fromJson(task)).toList();
//     } else {
//       throw Exception('Failed to load tasks');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     futureTasks = fetchTasksGantt(widget.templateId);
//   }

//   void onZoomIn() {
//     setState(() {
//       dayWidth += 5;
//     });
//   }

//   void onZoomOut() {
//     if (dayWidth <= 10) return;
//     setState(() {
//       dayWidth -= 5;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ignore: deprecated_member_use
//     return RawKeyboardListener(
//       focusNode: FocusNode(),
//       autofocus: true,
//       onKey: (event) {
//         // ignore: deprecated_member_use
//         if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
//           if (scrollController.offset < scrollController.position.maxScrollExtent) {
//             scrollController.jumpTo(scrollController.offset + 50);
//           }
//         }
//         // ignore: deprecated_member_use
//         if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
//           if (scrollController.offset > scrollController.position.minScrollExtent) {
//             scrollController.jumpTo(scrollController.offset - 50);
//           }
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: Text(
//             'Gantt Chart',
//             style: GoogleFonts.montserrat(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Colors.black,
//             ),
//           ),
//           iconTheme: const IconThemeData(color: Colors.black),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SettingsPage(
//                       token: widget.token,
//                       templateId: widget.templateId,
//                     ),
//                   ),
//                 );
//               },
//               icon: const Icon(Icons.settings, color: Colors.black),
//               tooltip: "Settings",
//             ),
//             IconButton(
//               onPressed: onZoomIn,
//               icon: const Icon(Icons.zoom_in, color: Colors.black),
//               tooltip: "Zoom In",
//             ),
//             IconButton(
//               onPressed: onZoomOut,
//               icon: const Icon(Icons.zoom_out, color: Colors.black),
//               tooltip: "Zoom Out",
//             ),
//           ],
//         ),
//         body: FutureBuilder<List<Task>>(
//           future: futureTasks,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text(
//                   'Error: ${snapshot.error}',
//                   style: GoogleFonts.montserrat(
//                     fontSize: 14,
//                     color: Colors.black87,
//                   ),
//                 ),
//               );
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(
//                 child: Text(
//                   'No tasks available.',
//                   style: GoogleFonts.montserrat(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//               );
//             } else {
//               final tasks = snapshot.data!;
//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.2),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 16),
//                         GanttChartView(
//                           scrollPhysics: const BouncingScrollPhysics(),
//                           stickyAreaWeekBuilder: (context) {
//                             return Text(
//                               'Custom',
//                               style: GoogleFonts.montserrat(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             );
//                           },
//                           stickyAreaDayBuilder: (context) {
//                             return AnimatedBuilder(
//                               animation: scrollController,
//                               builder: (context, _) {
//                                 final pos = scrollController.positions.firstOrNull;
//                                 final currentOffset = pos?.pixels ?? 0;
//                                 final maxOffset = pos?.maxScrollExtent ?? double.infinity;
//                                 return Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     IconButton(
//                                       onPressed: currentOffset > 0
//                                           ? () {
//                                               scrollController.jumpTo(scrollController.offset - 50);
//                                             }
//                                           : null,
//                                       icon: const Icon(Icons.arrow_left, size: 28),
//                                       color: currentOffset > 0 ? Colors.black : Colors.grey,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     IconButton(
//                                       onPressed: currentOffset < maxOffset
//                                           ? () {
//                                               scrollController.jumpTo(scrollController.offset + 50);
//                                             }
//                                           : null,
//                                       icon: const Icon(Icons.arrow_right, size: 28),
//                                       color: currentOffset < maxOffset ? Colors.black : Colors.grey,
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                           scrollController: scrollController,
//                           maxDuration: const Duration(days: 30 * 2),
//                           startDate: selectedDate ?? DateTime(2022, 6, 7),
//                           dayWidth: dayWidth,
//                           eventHeight: 60,
//                           stickyAreaWidth: 100,
//                           showStickyArea: showStickyArea,
//                           stickyAreaEventBuilder: null,
//                           weekHeaderBuilder: customWeekHeader
//                               ? (context, weekDate) => GanttChartDefaultWeekHeader(
//                                     weekDate: weekDate,
//                                     color: Colors.black,
//                                     backgroundColor: Colors.yellow,
//                                     border: const BorderDirectional(
//                                       end: BorderSide(color: Colors.green),
//                                     ),
//                                   )
//                               : null,
//                           dayHeaderBuilder: customDayHeader
//                               ? (context, date, bool isHoliday) => GanttChartDefaultDayHeader(
//                                     date: date,
//                                     isHoliday: isHoliday,
//                                     color: isHoliday ? Colors.yellow : Colors.black,
//                                     backgroundColor: isHoliday ? Colors.purple : Colors.yellow,
//                                   )
//                               : null,
//                           showDays: showDaysRow,
//                           weekEnds: const {},
//                           isExtraHoliday: (context, day) {
//                             return customHolidays.any((holiday) => DateUtils.isSameDay(holiday, day));
//                           },
//                           startOfTheWeek: WeekDay.sunday,
//                           events: tasks.map((task) {
//   // Format start and end dates
//   String formattedStartDate =
//       "${task.startDate.day} ${_getMonthName(task.startDate.month)} ${task.startDate.year}";
//   String formattedEndDate =
//       "${task.dueDate.day} ${_getMonthName(task.dueDate.month)} ${task.dueDate.year}";

//   return GanttAbsoluteEvent(
//     displayName: "${task.title}\n$formattedStartDate - $formattedEndDate",
//     startDate: task.startDate,
//     endDate: task.dueDate,
//     suggestedColor: task.priority == "high"
//         ? Colors.red
//         : task.priority == "Medium"
//             ? Colors.amber
//             : Colors.lightGreen,
//   );
// }).toList(),



//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

// String _getMonthName(int month) {
//   const monthNames = [
//     "January", "February", "March", "April", "May", "June",
//     "July", "August", "September", "October", "November", "December"
//   ];
//   return monthNames[month - 1];
// }



// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend1/templates/collaboration_template/TaskModel.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'dart:convert';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

bool showDaysRow = true;
double dayWidth = 30;
bool showStickyArea = false;
DateTime? selectedDate;

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class CustomGanttChart extends StatefulWidget {
  final String token;
  final String templateId;

  const CustomGanttChart({super.key, required this.token, required this.templateId});

  @override
  CustomGanttChartState createState() => CustomGanttChartState();
}

class CustomGanttChartState extends State<CustomGanttChart> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Gantt Chart',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(token: widget.token, templateId: widget.templateId),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String token;
  final String templateId;

  const MyHomePage({super.key, required this.token, required this.templateId});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scrollController = ScrollController();
  late Future<List<Task>> futureTasks;

  Future<List<Task>> fetchTasksGantt(String templateID) async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/project-templates/$templateID/tasks'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  void initState() {
    super.initState();
    futureTasks = fetchTasksGantt(widget.templateId);
  }

  void onZoomIn() {
    setState(() {
      dayWidth += 5;
    });
  }

  void onZoomOut() {
    if (dayWidth <= 10) return;
    setState(() {
      dayWidth -= 5;
    });
  }

  String _getMonthName(int month) {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Gantt Chart',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: onZoomIn,
            icon: const Icon(Icons.zoom_in, color: Colors.black),
            tooltip: "Zoom In",
          ),
          IconButton(
            onPressed: onZoomOut,
            icon: const Icon(Icons.zoom_out, color: Colors.black),
            tooltip: "Zoom Out",
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No tasks available.',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            final tasks = snapshot.data!;
            return DefaultTextStyle(
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: GanttChartView(
                      scrollController: scrollController,
                      maxDuration: const Duration(days: 30 * 2),
                      startDate: selectedDate ?? DateTime.now(),
                      dayWidth: dayWidth,
                      eventHeight: 60,
                      stickyAreaWidth: 100,
                      showDays: showDaysRow,
                      weekEnds: const {},
                      startOfTheWeek: WeekDay.sunday,
                      events: tasks.map((task) {
                        String formattedStartDate =
                            "${task.startDate.day} ${_getMonthName(task.startDate.month)} ${task.startDate.year}";
                        String formattedEndDate =
                            "${task.dueDate.day} ${_getMonthName(task.dueDate.month)} ${task.dueDate.year}";

                        return GanttAbsoluteEvent(
                          displayName:
                              "${task.title}\n$formattedStartDate - $formattedEndDate",
                          startDate: task.startDate,
                          endDate: task.dueDate,
                    suggestedColor: task.priority.toLowerCase() == "high"
    ? Colors.red[100]
    : task.priority.toLowerCase() == "medium"
        ? Colors.blue[100]
        : Colors.green[100],

                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
