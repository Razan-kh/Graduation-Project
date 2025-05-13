import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/collaboration_template/TaskModel.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class KanbanBoard extends StatefulWidget {
  final String token;
  final String templateId;

  KanbanBoard({required this.token, required this.templateId, required ValueKey<String> key});

  @override
  _KanbanBoardState createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  late Future<List<Task>> futureTasks;

  Map<String, List<Task>> columns = {
    'pending': [],
    'in-progress': [],
    'completed': [],
  };

  Future<List<Task>> fetchTaskscharts(String templateID) async {
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
    futureTasks = fetchTaskscharts(widget.templateId);
    futureTasks.then((tasks) {
      setState(() {
        for (var task in tasks) {
          columns[task.status]!.add(task);
        }
      });
    });
  }

Future<void> updateTaskStatus(String id, String uiStatus) async {
  final serverVal = uiStatusToServer(uiStatus);
  final response = await http.put(
    Uri.parse('http://$localhost/api/project-templates/${widget.templateId}/tasks/$id'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${widget.token}'
    },
    body: jsonEncode({'status': serverVal}),
  );

  print("Status update response: ${response.statusCode}, ${response.body}");

  if (response.statusCode != 200) {
    // If not successful, handle this by showing an error or reverting UI.
    throw Exception('Failed to update task');
  }
}


  String uiStatusToServer(String uiStatus) {
    // Convert UI-friendly names (if any) to backend statuses
    // Adjusting logic to handle the given column keys directly:
    // Columns keys are 'pending', 'in-progress', 'completed'
    // If you plan to show different labels, you'd map them here.
    switch (uiStatus) {
      case 'in-progress':
        return 'in-progress';
      case 'completed':
        return 'completed';
      case 'pending':
      default:
        return 'pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
          automaticallyImplyLeading: false, 
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Kanban Board",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Error
            return Center(
              child: Text('Failed to load tasks', style: GoogleFonts.montserrat()),
            );
          } else {
            // Data Loaded
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columns.keys.map((status) => buildColumn(status)).toList(),
              ),
            );
          }
        },
      ),
    );
  }


  Widget buildColumn(String status) {
  // Assign a pastel background to each column for visual clarity
  Color columnColor;
  if (status == 'pending') {
    columnColor = Colors.grey[100]!;
  } else if (status == 'in-progress') {
    columnColor = Colors.blue[50]!;
  } else {
    columnColor = Colors.green[50]!;
  }

  return Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: columnColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _statusLabel(status).toUpperCase(),
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: DragTarget<Task>(
              onWillAcceptWithDetails: (task) => true,
              onAcceptWithDetails: (details) async {
                final task = details.data;
                final oldStatus = task.status;

                setState(() {
                  // Remove task from the old column
                  columns[oldStatus]?.remove(task);

                  // Update task status and add to new column
                  task.status = status;
                  columns[status]?.add(task);
                });

                // Update task status on the server
                await updateTaskStatus(task.id, task.status);
              },
              builder: (context, candidateData, rejectedData) {
                return SingleChildScrollView(
                  child: Column(
                    children: columns[status]!.isNotEmpty
                        ? columns[status]!.map((task) {
                            return Draggable<Task>(
                              data: task,
                              feedback: buildTaskCardFeedback(task),
                              childWhenDragging: Container(),
                              child: buildTaskCard(task),
                            );
                          }).toList()
                        : [
                            // Add a placeholder for empty columns
                            Container(
                              height: 100,
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "No tasks here",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}


  String _statusLabel(String status) {
    // If you want to display a user-friendly label on top
    // or just keep it as is. For now, we just capitalize the keys.
    if (status == 'pending') return 'Pending';
    if (status == 'in-progress') return 'In Progress';
    if (status == 'completed') return 'Completed';
    return status;
  }

  Widget buildTaskCardFeedback(Task task) {
    return Material(
      elevation: 4,
      child: Container(
        width: 200,
        padding: EdgeInsets.all(8),
        color: Colors.blueAccent,
        child: Text(
          task.title,
          style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildTaskCard(Task task) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(
          task.title,
          style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          task.description,
          style: GoogleFonts.montserrat(fontSize: 14),
        ),
      ),
    );
  }
}
