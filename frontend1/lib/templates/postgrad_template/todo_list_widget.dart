import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoListWidget extends StatefulWidget {
  final String token;
  final String templateId;

  const TodoListWidget({super.key, required this.token, required this.templateId});

  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  List<Map<String, dynamic>> tasks = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/postgraduate/todo/${widget.templateId}'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      setState(() {
        tasks = List<Map<String, dynamic>>.from(json.decode(response.body)['todoList']);
      });
    } else {
      print("Failed to fetch tasks: ${response.body}");
    }
  }

  Future<void> addTask(String task) async {
    final response = await http.post(
      Uri.parse('http://$localhost/api/postgraduate/todo'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode({'templateId': widget.templateId, 'task': task}),
    );

    if (response.statusCode == 200) {
      fetchTasks();
      taskController.clear();
    } else {
      print("Failed to add task: ${response.body}");
    }
  }

  Future<void> deleteTask(String taskId) async {
    final response = await http.delete(
      Uri.parse('http://$localhost/api/postgraduate/todo'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'taskId': taskId}),
    );
    if (response.statusCode == 200) {
      fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.blue[50],
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            "📝 To-Do List",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 10),
        ...tasks.map((task) {
          return Dismissible(
            key: Key(task['_id']),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => deleteTask(task['_id']),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(
                task['task'],
                style: GoogleFonts.montserrat(
                  decoration: task['isChecked'] ? TextDecoration.lineThrough : null,
                ),
              ),
              leading: Checkbox(
                value: task['isChecked'],
                onChanged: (newValue) {
                  setState(() {
                    task['isChecked'] = newValue!;
                  });
                },
              ),
            ),
          );
        }),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: taskController,
                decoration: InputDecoration(
                  hintText: "Add a new to-do",
                  hintStyle: GoogleFonts.montserrat(),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.blue),
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  addTask(taskController.text);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
