import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage1 extends StatefulWidget {
  const CalendarPage1({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage1> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Map to store events based on date
  final Map<DateTime, List<String>> _events = {
    DateTime(2024, 10, 17): [
      'Statistics Quiz\nNeed to study\nHigh priority\nChapter 2, 3, and 4\nRoom 204'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 235, 244, 247),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            daysOfWeekVisible: true,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: true,
              outsideTextStyle: TextStyle(color: Colors.grey, fontFamily: 'Georgia'),
              weekendTextStyle: TextStyle(fontFamily: 'Georgia', color: const Color.fromARGB(255, 243, 198, 198)),
              defaultTextStyle: TextStyle(fontFamily: 'Georgia', color: Colors.black),
              selectedDecoration: BoxDecoration(
                color: Colors.blue[800],
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 228, 201),
                shape: BoxShape.circle,
              ),
              outsideDecoration: BoxDecoration(
                color: Colors.grey[200], // Light background for outside days
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${events.length} event(s)',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[900],
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
              singleMarkerBuilder: (context, date, event) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.toString().split('\n')[0], // Display event title only
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue[900],
                      fontFamily: 'Georgia',
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12.0),
              children: [
                ...(_events[_selectedDay] ?? []).map((event) => Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.split('\n')[0],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontFamily: 'Georgia',
                            ),
                          ),
                          SizedBox(height: 8),
                          for (var detail in event.split('\n').skip(1))
                            Container(
                              margin: EdgeInsets.only(bottom: 4),
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: detail.contains('High priority')
                                    ? const Color.fromARGB(255, 251, 204, 204).withOpacity(0.2)
                                    : Colors.blueAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                detail,
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 14,
                                  fontWeight: detail.contains('High priority') ? FontWeight.bold : FontWeight.normal,
                                  color: detail.contains('High priority') ? const Color.fromARGB(255, 230, 162, 157) : Colors.blue[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewEvent(context),
        backgroundColor: Color.fromARGB(255, 235, 244, 247),
        child: Icon(Icons.add),
      ),
    );
  }

  // Function to add a new event
  Future<void> _addNewEvent(BuildContext context) async {
    TextEditingController eventController = TextEditingController();
    DateTime selectedDate = _selectedDay;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Deadline',
          style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: eventController,
          decoration: InputDecoration(labelText: 'Event Description', labelStyle: TextStyle(fontFamily: 'Georgia')),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Georgia', color: Colors.grey[700]),
            ),
          ),
          TextButton(
            onPressed: () {
              if (eventController.text.isNotEmpty) {
                setState(() {
                  if (_events[selectedDate] != null) {
                    _events[selectedDate]!.add(eventController.text);
                  } else {
                    _events[selectedDate] = [eventController.text];
                  }
                });
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Add',
              style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold, color: Color.fromARGB(255, 235, 244, 247)),
            ),
          ),
        ],
      ),
    );
  }
}
