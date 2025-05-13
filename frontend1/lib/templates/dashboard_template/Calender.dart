// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:http/http.dart' as http;

// class Event {
//   final String title;
//   Event(this.title);
//   @override
//   String toString() => title;
// }

// class CalendarWidget extends StatefulWidget {
//   final String baseUrl;     // e.g. "http://your-backend-url.com/api"
//   final String token;       // JWT token from login
//   final String templateId;  // templateId for this student planner

//   const CalendarWidget({
//     Key? key,
//     required this.baseUrl,
//     required this.token,
//     required this.templateId,
//   }) : super(key: key);

//   @override
//   _CalendarWidgetState createState() => _CalendarWidgetState();
// }

// class _CalendarWidgetState extends State<CalendarWidget> {
//   TextEditingController _eventController = TextEditingController();
//   DateTime _selectedDay = DateTime.now();
//   DateTime _focusedDay = DateTime.now();
//   Map<DateTime, List<Event>> events = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchEvents();
//   }

//   Future<void> _fetchEvents() async {
//     final url = Uri.parse('${widget.baseUrl}/studentPlanner2/${widget.templateId}');
//     final response = await http.get(url, headers: {
//       'Authorization': 'Bearer ${widget.token}',
//     });

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['events'] != null && data['events'] is List) {
//         Map<DateTime, List<Event>> fetchedEvents = {};
//         for (var e in data['events']) {
//           final date = DateTime.parse(e['date']);
//           if (!fetchedEvents.containsKey(date)) {
//             fetchedEvents[date] = [];
//           }
//           fetchedEvents[date]!.add(Event(e['title']));
//         }
//         setState(() {
//           events = fetchedEvents;
//         });
//       }
//     } else {
//       print('Failed to fetch events: ${response.statusCode}');
//     }
//   }

//   Future<void> _addEvent(String title) async {
//     final url = Uri.parse('${widget.baseUrl}/studentPlanner2/addEvent');
//     final response = await http.put(
//       url,
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//         'Content-Type': 'application/json'
//       },
//       body: jsonEncode({
//         'templateId': widget.templateId,
//         'eventData': {
//           'date': _selectedDay.toIso8601String(),
//           'title': title,
//         }
//       }),
//     );

//     if (response.statusCode == 200) {
//       _eventController.clear();
//       await _fetchEvents();
//     } else {
//       print('Failed to add event: ${response.statusCode}');
//     }
//   }

//   List<Event> _getEventsForDay(DateTime day) {
//     return events[day] ?? [];
//   }

//   void _showEventsDialog(BuildContext context, DateTime selectedDay) {
//     final eventsForSelectedDay = _getEventsForDay(selectedDay);
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             "Events for ${selectedDay.toLocal().toString().split(' ')[0]}",
//             style: const TextStyle(
//               fontFamily: 'NotoSans',
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: eventsForSelectedDay.isNotEmpty
//               ? SizedBox(
//                   height: 200,
//                   width: 300,
//                   child: ListView.builder(
//                     itemCount: eventsForSelectedDay.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(
//                           eventsForSelectedDay[index].title,
//                           style: const TextStyle(
//                             fontFamily: 'NotoSans',
//                             fontSize: 16,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               : const Text(
//                   "No events for this day.",
//                   style: TextStyle(fontFamily: 'NotoSans', fontSize: 16),
//                 ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text(
//                 "Close",
//                 style: TextStyle(fontFamily: 'NotoSans', fontSize: 16),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildEventsMarker(int eventCount) {
//     return Container(
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.blue,
//       ),
//       width: 16.0,
//       height: 16.0,
//       child: Center(
//         child: Text(
//           '$eventCount',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 12.0,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxHeight > 0 && constraints.maxWidth > 0) {
//           return Column(
//             children: [
//               TableCalendar(
//                 locale: "en_US",
//                 rowHeight: 43,
//                 headerStyle: const HeaderStyle(
//                   formatButtonVisible: false,
//                   titleCentered: true,
//                   titleTextStyle: TextStyle(
//                     fontFamily: 'NotoSans',
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 focusedDay: _focusedDay,
//                 firstDay: DateTime.utc(2010, 10, 16),
//                 lastDay: DateTime.utc(2040, 3, 14),
//                 selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                 onDaySelected: (selectedDay, focusedDay) {
//                   setState(() {
//                     _selectedDay = selectedDay;
//                     _focusedDay = focusedDay;
//                   });
//                   _showEventsDialog(context, selectedDay);
//                 },
//                 calendarStyle: CalendarStyle(
//                   todayDecoration: BoxDecoration(
//                     color: Colors.blue[300],
//                     shape: BoxShape.circle,
//                   ),
//                   selectedDecoration: BoxDecoration(
//                     color: Colors.blue[800],
//                     shape: BoxShape.circle,
//                   ),
//                   defaultTextStyle: const TextStyle(
//                     fontFamily: 'NotoSans',
//                     fontSize: 16,
//                   ),
//                 ),
//                 daysOfWeekStyle: const DaysOfWeekStyle(
//                   weekdayStyle: TextStyle(
//                     fontFamily: 'NotoSans',
//                     fontSize: 14,
//                   ),
//                   weekendStyle: TextStyle(
//                     fontFamily: 'NotoSans',
//                     fontSize: 14,
//                   ),
//                 ),
//                 eventLoader: _getEventsForDay,
//                 calendarBuilders: CalendarBuilders(
//                   markerBuilder: (context, date, eventsForDay) {
//                     if (eventsForDay.isNotEmpty) {
//                       return Positioned(
//                         bottom: 1,
//                         child: _buildEventsMarker(eventsForDay.length),
//                       );
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   FloatingActionButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16.0),
//                             ),
//                             scrollable: true,
//                             title: const Text(
//                               "Add Event",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'NotoSans',
//                               ),
//                             ),
//                             content: Padding(
//                               padding: const EdgeInsets.all(8),
//                               child: TextField(
//                                 controller: _eventController,
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12.0),
//                                   ),
//                                   hintText: "Enter event title",
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12.0),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             actions: [
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   if (_eventController.text.isNotEmpty) {
//                                     await _addEvent(_eventController.text);
//                                     Navigator.of(context).pop();
//                                   }
//                                 },
//                                 child: const Text("Save", style: TextStyle(color: Colors.black)),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     mini: true,
//                     backgroundColor: Colors.blue[300],
//                     child: const Icon(Icons.add, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         } else {
//           return const Center(child: Text("Invalid layout constraints"));
//         }
//       },
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class Event {
  final String title;
  Event(this.title);
  @override
  String toString() => title;
}

class CalendarWidget extends StatefulWidget {
  final String baseUrl;     // e.g. "http://your-backend-url.com/api"
  final String token;       // JWT token from login
  final String templateId;  // templateId for this student planner

  const CalendarWidget({
    super.key,
    required this.baseUrl,
    required this.token,
    required this.templateId,
  });

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final TextEditingController _eventController = TextEditingController();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Event>> events = {};

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final url = Uri.parse('${widget.baseUrl}/studentPlanner2/${widget.templateId}');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${widget.token}',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['events'] != null && data['events'] is List) {
        Map<DateTime, List<Event>> fetchedEvents = {};
        for (var e in data['events']) {
          final date = DateTime.parse(e['date']);
          if (!fetchedEvents.containsKey(date)) {
            fetchedEvents[date] = [];
          }
          fetchedEvents[date]!.add(Event(e['title']));
        }
        setState(() {
          events = fetchedEvents;
        });
      }
    } else {
      print('Failed to fetch events: ${response.statusCode}');
    }
  }

  Future<void> _addEvent(String title) async {
    final url = Uri.parse('${widget.baseUrl}/studentPlanner2/addEvent');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'templateId': widget.templateId,
        'eventData': {
          'date': _selectedDay.toIso8601String(),
          'title': title,
        }
      }),
    );

    if (response.statusCode == 200) {
      _eventController.clear();
      await _fetchEvents();
    } else {
      print('Failed to add event: ${response.statusCode}');
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _showEventsDialog(BuildContext context, DateTime selectedDay) {
    final eventsForSelectedDay = _getEventsForDay(selectedDay);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text(
            "Events for ${selectedDay.toLocal().toString().split(' ')[0]}",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: eventsForSelectedDay.isNotEmpty
              ? SizedBox(
                  height: 200,
                  width: 300,
                  child: ListView.builder(
                    itemCount: eventsForSelectedDay.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          eventsForSelectedDay[index].title,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Text(
                  "No events for this day.",
                  style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black87),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventsMarker(int eventCount) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[300],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '$eventCount',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text(
            "Add Event",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _eventController,
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Enter event title",
                hintStyle: GoogleFonts.montserrat(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_eventController.text.isNotEmpty) {
                  await _addEvent(_eventController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Save",
                style: GoogleFonts.montserrat(
                  color: Colors.blueAccent,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Container(
          width: double.infinity,
          color: const Color(0xFFDFE6F2),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            'Upcoming Dates',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Calendar
        TableCalendar(
          locale: "en_US",
          rowHeight: 43,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black87),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black87),
          ),
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2040, 3, 14),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _showEventsDialog(context, selectedDay);
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue[200],
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blue[600],
              shape: BoxShape.circle,
            ),
            defaultTextStyle: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
            weekendTextStyle: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
            weekendStyle: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
          ),
          eventLoader: _getEventsForDay,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, eventsForDay) {
              if (eventsForDay.isNotEmpty) {
                return Positioned(
                  bottom: 1,
                  child: _buildEventsMarker(eventsForDay.length),
                );
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),

        // Add Event Button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _showAddEventDialog,
              mini: true,
              backgroundColor: Colors.blue[300],
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(color: Colors.grey[300], thickness: 1),
        const SizedBox(height: 16),
      ],
    );
  }
}


