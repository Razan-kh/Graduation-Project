import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoPlannerPage extends StatefulWidget {
  final String baseUrl;
  final String token;
  final String templateId;

  const TodoPlannerPage({
    super.key,
    required this.baseUrl,
    required this.token,
    required this.templateId,
  });

  @override
  _TodoPlannerPageState createState() => _TodoPlannerPageState();
}

class _TodoPlannerPageState extends State<TodoPlannerPage> {
  List<Map<String, dynamic>> tasks = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final url = Uri.parse('${widget.baseUrl}/studentPlanner2/${widget.templateId}/tasks');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        tasks = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print('Failed to fetch tasks: ${response.statusCode}');
      // Optionally, show a SnackBar or other user feedback
    }
  }

  Future<void> addTask() async {
    final name = nameController.text;
    final deadline = deadlineController.text;
    final hours = int.tryParse(hoursController.text) ?? 0;
    final className = classController.text;

    if (name.isEmpty || deadline.isEmpty) {
      // Optionally, show a SnackBar or other user feedback
      return;
    }

    final url = Uri.parse('${widget.baseUrl}/studentPlanner2/addTask');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'templateId': widget.templateId,
        'taskData': {
          'name': name,
          'deadline': deadline,
          'hours': hours,
          'class': className,
        }
      }),
    );

    if (response.statusCode == 200) {
      await _fetchTasks();
      nameController.clear();
      deadlineController.clear();
      hoursController.clear();
      classController.clear();
    } else {
      print('Failed to add task: ${response.statusCode}');
      // Optionally, show a SnackBar or other user feedback
    }
  }

  Future<void> deleteTask(int index) async {
    final taskId = tasks[index]['_id'];

    final url = Uri.parse('${widget.baseUrl}/studentPlanner2/deleteTask');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'templateId': widget.templateId,
        'taskId': taskId,
      }),
    );

    if (response.statusCode == 200) {
      await _fetchTasks();
    } else {
      print('Failed to delete task: ${response.statusCode}');
      // Optionally, show a SnackBar or other user feedback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'To-Do',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // DataTable within a constrained Container
          SizedBox(
            height: 300, // Adjust as needed
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 600, // Adjust as needed
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Assignment Name')),
                    DataColumn(label: Text('Deadline')),
                    DataColumn(label: Text('Estimated Hours')),
                    DataColumn(label: Text('Class')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: tasks.map((task) {
                    final index = tasks.indexOf(task);
                    return DataRow(cells: [
                      DataCell(Text(task['name'].toString())),
                      DataCell(Text(task['deadline'].toString())),
                      DataCell(Text(task['hours'].toString())),
                      DataCell(Text(task['class'].toString())),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(index),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Add New Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Task Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: deadlineController,
                  decoration: const InputDecoration(
                    labelText: 'Deadline',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: hoursController,
                  decoration: const InputDecoration(
                    labelText: 'Estimated Hours',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: classController,
                  decoration: const InputDecoration(
                    labelText: 'Class',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: addTask,
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
