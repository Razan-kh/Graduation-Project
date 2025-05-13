

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  Event(this.title);

  @override
  String toString() => title;
}

class CalendarWidget1 extends StatefulWidget {
  final String token;
  final String templateId;

  const CalendarWidget1({super.key, required this.token, required this.templateId});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget1> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Event>> events = {}; // Map to hold events by date
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
    });

    final String apiUrl = "http://$localhost/api/project-templates/${widget.templateId}/tasks";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer ${widget.token}",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> tasks = json.decode(response.body);

        setState(() {
          events.clear(); // Clear existing events

          for (var task in tasks) {
            if (task["dueDate"] == null || task["dueDate"].isEmpty) {
              // If no dueDate is provided, skip or handle differently
              continue;
            }
            // Parse and normalize dueDate
            String dueDateString = task["dueDate"];
            DateTime dueDate = DateTime.parse(dueDateString);
            dueDate = DateTime.utc(dueDate.year, dueDate.month, dueDate.day);

            // Add to the events map
            String title = task["title"] ?? 'Untitled';
            if (!events.containsKey(dueDate)) {
              events[dueDate] = [];
            }
            events[dueDate]!.add(Event(title));
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Normalize the date to UTC midnight
    DateTime normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return events[normalizedDay] ?? [];
  }

  // Show a dialog with event titles when a day is selected
  void _showEventDialog(List<Event> eventsForDay) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            "Tasks for the day",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: eventsForDay
                .map((event) => ListTile(
                      title: Text(
                        event.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.blue[800],
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Calendar',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2040, 3, 14),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  // Show event dialog when day is selected
                  List<Event> eventsForSelectedDay = _getEventsForDay(selectedDay);
                  if (eventsForSelectedDay.isNotEmpty) {
                    _showEventDialog(eventsForSelectedDay);
                  }
                },
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  // Today and selected day styling
                  todayDecoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue[800],
                    shape: BoxShape.circle,
                  ),
                  // Use Montserrat for date text
                  defaultTextStyle: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  weekendTextStyle: GoogleFonts.montserrat(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
                ),
                calendarBuilders: CalendarBuilders(
                  todayBuilder: (context, day, focusedDay) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    );
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    // Normalize the day for comparison
                    DateTime normalizedDay = DateTime.utc(day.year, day.month, day.day);
                    bool hasEvent = events.containsKey(normalizedDay);
                    return Container(
                      decoration: BoxDecoration(
                        color: hasEvent ? Colors.blueAccent : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: GoogleFonts.montserrat(
                            color: hasEvent ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                  markerBuilder: (context, date, eventsForDay) {
                    if (eventsForDay.isNotEmpty) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 4),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 195, 194, 194),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              eventsForDay.length.toString(),
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
    );
  }
}
