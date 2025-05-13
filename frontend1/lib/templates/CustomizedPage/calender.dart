import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendarPage extends StatefulWidget {
  final Map<DateTime, String> events; 
    final String pageId;
  final int index;

  const MyCalendarPage({super.key,required this.pageId,required this.index,required this.events});
//required this.events

  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  // Declare the selected date
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now(); // The currently focused day

  // Initialize a range of available holidays, events, or data for custom markers
  final Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    // You can add events or holidays as needed in the map
    _events[DateTime.utc(2024, 12, 25)] = ['Christmas'];
    _events[DateTime.utc(2024, 12, 31)] = ['New Year Eve'];
  //  print("widget events are ${widget.events}");
  }

  // Function to handle when a day is selected
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay; // Update focused day
    });
  }

  @override
  Widget build(BuildContext context) {

     return LayoutBuilder(
    builder: (context, constraints) {
      final rowHeight = constraints.maxHeight / 10; // Example: Divide height by 6 rows
      return TableCalendar(
    rowHeight: rowHeight,
    firstDay: DateTime.utc(2020, 1, 1),
    lastDay: DateTime.utc(2030, 12, 31),
    focusedDay: _focusedDay,
    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
    onDaySelected: _onDaySelected,
    eventLoader: (day) => _events[day] ?? [],
    
    headerStyle: HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      leftChevronIcon: Icon(Icons.arrow_left),
      rightChevronIcon: Icon(Icons.arrow_right),
    ),
    
    calendarStyle: CalendarStyle(
      todayDecoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      weekendTextStyle: TextStyle(color: Colors.red),
      holidayTextStyle: TextStyle(color: Colors.purple),
    ),
  );

    }
    );
    
  }
}
