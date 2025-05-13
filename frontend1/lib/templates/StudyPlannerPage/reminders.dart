import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoList extends StatefulWidget {
  final String token;
  final String templateId;

  const TodoList({super.key, required this.token, required this.templateId});

  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoList> {
  List<Map<String, dynamic>> tasks = [];
  List<bool> isChecked = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchReminders();
  }

  Future<void> fetchReminders() async {
    final url = Uri.parse('http://$localhost/studentplanner/reminder/${widget.templateId}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      List reminders = json.decode(response.body)['reminders'];
      setState(() {
        tasks = reminders.map((reminder) {
          return {
            'id': reminder['_id'],
            'title': reminder['title'],
          };
        }).toList();
        isChecked = List.generate(tasks.length, (_) => false);
      });
    } else {
      // Handle error
      print('Failed to load reminders: ${response.body}');
    }
  }

  Future<void> addReminder(String task) async {
    final url = Uri.parse('http://$localhost/studentplanner/reminder');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: json.encode({
        'templateId': widget.templateId,
        'reminder': {
          'title': task,
          'date': DateTime.now().toIso8601String(), // Adjust as needed
        },
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        tasks.add({'id': json.decode(response.body)['template']['_id'], 'title': task});
        isChecked.add(false);
      });
    } else {
      // Handle error
      print('Failed to add reminder: ${response.body}');
    }
  }

  Future<void> deleteReminder(String id) async {
    final url = Uri.parse('http://$localhost/studentplanner/reminder');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: json.encode({
        'templateId': widget.templateId,
        'reminderId': id,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        tasks.removeWhere((task) => task['id'] == id);
      });
    } else {
      // Handle error
      print('Failed to delete reminder: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            "Quick Reminders",
            style: GoogleFonts.merriweather(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ...tasks.map((task) {
          int index = tasks.indexOf(task);
          return Dismissible(
            key: Key(task['id']),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              deleteReminder(task['id']);
            },
            background: Container(
              color: const Color.fromARGB(255, 207, 205, 205),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(
                task['title'],
                style: GoogleFonts.merriweather(
                  decoration: isChecked[index] ? TextDecoration.lineThrough : null,
                ),
              ),
              leading: Checkbox(
                value: isChecked[index],
                onChanged: (newValue) {
                  setState(() {
                    isChecked[index] = newValue!;
                  });
                },
              ),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: taskController,
                  decoration: InputDecoration(hintText: "Add a new to-do"),
                  onSubmitted: (value) {
                    if (taskController.text.isNotEmpty) {
                      addReminder(taskController.text);
                      taskController.clear();
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (taskController.text.isNotEmpty) {
                    addReminder(taskController.text);
                    taskController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
