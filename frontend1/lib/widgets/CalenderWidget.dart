import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  Event(this.title);

  @override
  String toString() => title; // To display the event title easily.
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final TextEditingController _eventController = TextEditingController();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Store the events
  Map<DateTime, List<Event>> events = {};

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight > 0 && constraints.maxWidth > 0) {
          return Column(
            children: [
              TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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

                  // Show dialog with events when a day is selected
                  _showEventsDialog(context, selectedDay);
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue[300],
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue[800],
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: const TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 16,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 14,
                  ),
                  weekendStyle: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 14,
                  ),
                ),
                eventLoader: _getEventsForDay, // Load events for the selected day
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        bottom: 1,
                        child: _buildEventsMarker(events.length),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align the button to the right
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            scrollable: true,
                            title: const Text(
                              "Add Event",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Georgia',
                              ),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                controller: _eventController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0), // Rounded corners for TextField
                                  ),
                                  hintText: "Enter event title", // Placeholder text
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0), // Rounded corners when focused
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_eventController.text.isNotEmpty) {
                                    setState(() {
                                      if (events[_selectedDay] != null) {
                                        events[_selectedDay]!.add(Event(_eventController.text));
                                      } else {
                                        events[_selectedDay] = [Event(_eventController.text)];
                                      }
                                    });
                                    _eventController.clear();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text("Save", style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    mini: true,
                    backgroundColor: Colors.blue[300],
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ],
          );
        } else {
          return const Center(child: Text("Invalid layout constraints"));
        }
      },
    );
  }

  // Function to show the dialog with the events
  void _showEventsDialog(BuildContext context, DateTime selectedDay) {
    final eventsForSelectedDay = _getEventsForDay(selectedDay);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Events for ${selectedDay.toLocal().toString().split(' ')[0]}",
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: eventsForSelectedDay.isNotEmpty
              ? SizedBox(
                  height: 200, // Adjust height as needed
                  width: 300, // Adjust width as needed
                  child: ListView.builder(
                    itemCount: eventsForSelectedDay.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          eventsForSelectedDay[index].title,
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Text(
                  "No events for this day.",
                  style: TextStyle(fontFamily: 'Georgia', fontSize: 16),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Close",
                style: TextStyle(fontFamily: 'Georgia', fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventsMarker(int eventCount) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '$eventCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
