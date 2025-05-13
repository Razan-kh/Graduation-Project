import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/NotificationService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart'; // Import for audio playback
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class ProjectTasksPage extends StatefulWidget {
  final String token;
  final String templateId;

  const ProjectTasksPage({super.key, required this.token, required this.templateId});

  @override
  _ProjectTasksPageState createState() => _ProjectTasksPageState();
}

class _ProjectTasksPageState extends State<ProjectTasksPage> {
  List<TaskRow> tasks = [];
  List<Map<String, dynamic>> members = [];
  String? selectedAssigneeId;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = "";



  @override
void initState() {
  super.initState();

  fetchTasks();
  fetchMembers(); 
  _speech = stt.SpeechToText();
} 

 Future<void> _requestMicrophonePermission() async {
  if (await Permission.microphone.request().isGranted) {
    print('Microphone permission granted');
  } else {
    print('Microphone permission denied');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Microphone permission is required')),
    );
  }
}

 Future<void> _playTaskSummary() async {
  try {
    final response = await http.get(
      Uri.parse('http://$localhost/api/project/summary-with-voice/${widget.templateId}'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String audioUrl = data['audioUrl'];

      // Play the audio
      final player = AudioPlayer();
      await player.setUrl(audioUrl);
      player.play();
    } else {
      print('Failed to fetch task summary: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch task summary')),
      );
    }
  } catch (e) {
    print('Error playing task summary: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error playing task summary')),
    );
  }
}

Future<void> _startListening() async {
  bool available = await _speech.initialize(
    onError: (error) => print("Speech recognition error: $error"),
    onStatus: (status) => print("Speech recognition status: $status"),
  );
  if (available) {
    setState(() {
      _isListening = true;
    });
    _speech.listen(
      onResult: (result) {
        setState(() {
          _command = result.recognizedWords;
        });
        print("Recognized: $_command");
        _processCommand(_command); // Process the recognized command
      },
    );
  } else {
    print("Speech recognition not available");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Speech recognition is not available")),
    );
  }
}

void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

 void _processCommand(String command) {
  command = command.toLowerCase();
  print("Processing command: $command");

  if (command.startsWith("add task")) {
    final taskTitle = command.replaceFirst("add task", "").trim();
    if (taskTitle.isNotEmpty) {
      _addTask(taskTitle); // Call addTask with the extracted title
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task title not specified")),
      );
    }
  } else if (command.contains("what are my tasks")) {
    _playTaskSummary(); // Play task summary
  } else {
    print("Command not recognized: $command");
  }
}


Future<void> fetchMembers() async {
  print("Fetching project members...");
  final url = Uri.parse("http://$localhost/api/projects/${widget.templateId}/members");

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}', // Send token for authentication
      },
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data is List) {
        // Safely map response to the 'members' list
        setState(() {
          members = data.map((user) {
            return user as Map<String, dynamic>;
          }).toList();
        });

        print("Fetched Members: $members");
        print("First Member Email: ${members[0]['user']['email']}");
      } else {
        print("Unexpected data format: $data");
        throw Exception("Invalid response format for members");
      }
    } else {
      throw Exception("Failed to load members: ${response.reasonPhrase}");
    }
  } catch (e) {
    print("Error fetching members: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching project members')),
    );
  }
}


 Future<void> fetchTasks() async {
    final url = Uri.parse('http://$localhost/api/project-templates/${widget.templateId}/tasks');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${widget.token}',
    });

    if (response.statusCode == 200) {
      final List taskData = json.decode(response.body);
      setState(() {
        tasks = taskData.map((data) => TaskRow.fromMap(data, )).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tasks')),
      );
    }
  }

  Future<void> addTask() async {
    final url = Uri.parse('http://$localhost/api/project-templates/tasks');
    final now = DateTime.now();
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "templateId": widget.templateId,
        "title": "New Task",
        "description": "Description of the new task",
        "startDate": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
        "dueDate": null,
        "status": "pending",
        "priority": "medium",
        "members": [],
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('task')) {
        final newTask = TaskRow.fromMap(responseData['task']);
        setState(() {
          tasks.add(newTask);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task: Invalid response format')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: ${response.reasonPhrase}')),
      );
    }
  }

  Future<void> updateTask(TaskRow task) async {
    final url = Uri.parse('http://$localhost/api/project-templates/${widget.templateId}/tasks/${task.taskId}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "title": task.taskName,
        "status": task.status,
        "assignee": task.assignee,
        "dueDate": (task.dueDate != null && task.dueDate!.isNotEmpty)
            ? _formatDateForBackend(task.dueDate!)
            : null,
        "priority": task.priority,
        // Even though we removed tags from UI, we still keep them in case future expansions require them.
        // For now, send an empty list or keep the original tags if needed.
        "tags": [], 
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: ${response.reasonPhrase}')),
      );
    }
  }


Future<void> updateTaskStatus(String taskId, String status) async {
  // Valid statuses
  const validStatuses = ["In-Progress", "Completed", "Pending"];
  
  // Check if the status is valid
  if (!validStatuses.contains(status)) {
    print("Invalid status value.");
    return;
  }

  final String url = "http://$localhost/api/project-templates/${widget.templateId}/tasks/$taskId"; // Replace with your API URL
//print("${status}");
  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: json.encode({
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      // Success: Task status updated
      final Map<String, dynamic> data = json.decode(response.body);
      print('Task status updated: ${data['task']}');
    } else if (response.statusCode == 404) {
      // Task not found
      print('Task not found.');
    } else {
      // Other error
      print('Error updating task status: ${response.body}');
    }
  } catch (error) {
    // Handle network or other errors
    print('Error: $error');
  }
}


  Future<void> deleteTask(String taskId) async {
    final url = Uri.parse('http://$localhost/api/project-templates/tasks');
    final response = await http.delete(url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "taskId": taskId,
          "templateId": widget.templateId,
        }));

    if (response.statusCode == 200) {
      setState(() {
        tasks.removeWhere((t) => t.taskId == taskId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task')),
      );
    }
  }

 Future<void> sendMention(String recipientId) async {
    print("inside sendMention");
 
NotificationService.sendMessage(context,"mention","A new task is assigned to you!",recipientId,"mention",widget.token,widget.templateId,

);

}
  Future<void> _addTask(String taskTitle, {String description = "No description provided"}) async {
  final url = Uri.parse('http://$localhost/api/project-templates/tasks');
  final now = DateTime.now();

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "templateId": widget.templateId,
        "title": taskTitle, // Dynamically provided title
        "description": description, // Optional description
        "startDate": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
        "dueDate": null,
        "status": "pending", // Default status
        "priority": "medium", // Default priority
        "members": [], // Default empty members
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('task')) {
        final newTask = TaskRow.fromMap(responseData['task']); // Assuming TaskRow is a defined class
        setState(() {
          tasks.add(newTask);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task "$taskTitle" added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task: Invalid response format')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: ${response.reasonPhrase}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error adding task: $e')),
    );
  }
}
Future<void> updateAssignee(String assigneeID, String taskId) async {
  print("Updating Assignee ID: $assigneeID for Task ID: $taskId");

  try {
    final response = await http.put(
      Uri.parse('http://$localhost/api/task/$taskId/assign'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: json.encode({'assigneeId': assigneeID}),
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final updatedTask = json.decode(response.body)['task'];
      setState(() {
        // Update the task in the local list
        tasks = tasks.map((task) {
          if (task.taskId == taskId) {
            task.assignee = updatedTask['assignee']['email'];
          }
          return task;
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assignee updated successfully!')),
      );
    } else {
      print('Failed to update assignee: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update assignee: ${response.body}')),
      );
    }
  } catch (error) {
    print("Error updating assignee: $error");
  }
}



 String? _formatDateForBackend(String displayDate) {
  // Display format: e.g. "12 March 2024"
  // Need to parse back to "2024-03-12" (ISO)
  final parts = displayDate.split(' ');
  if (parts.length == 3) {
    final day = parts[0].padLeft(2, '0');
    final monthName = parts[1];
    final year = parts[2];
    final month = _monthNumberFromName(monthName);
    return "$year-${month.toString().padLeft(2, '0')}-$day";
    }
  return null; // Safely return null if parsing fails
}

  int _monthNumberFromName(String name) {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return monthNames.indexOf(name) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
          automaticallyImplyLeading: false, 
  backgroundColor: Colors.white,
  elevation: 0,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Project Title
      Text(
        '📋 project Tasks',
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      // Icons Row
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.volume_up, color: Colors.blue),
            onPressed: _playTaskSummary, // Trigger the audio functionality
          ),
          IconButton(
            icon: Icon(Icons.mic, color: Colors.red),
            onPressed: _startListening, // Start listening for commands
          ),
        ],
      ),
    ],
  ),
  iconTheme: IconThemeData(color: Colors.black),
),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTable(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }


  Widget _buildTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: [
          DataColumn(label: Text('Task Name', style: _tableHeaderStyle())),
          DataColumn(label: Text('Status', style: _tableHeaderStyle())),
          DataColumn(label: Text('Assignee', style: _tableHeaderStyle())),
          DataColumn(label: Text('Due Date', style: _tableHeaderStyle())),
          DataColumn(label: Text('Priority', style: _tableHeaderStyle())),
          DataColumn(label: Text('Actions', style: _tableHeaderStyle())),
        ],
        rows: tasks.map((task) {
          return DataRow(cells: [
            _buildEditableTextCell(task, 'taskName'),
            _buildStatusCell(task),
            _buildEditableTextCell(task, 'assignee'),
            _buildDateCell(task),
            _buildPriorityCell(task),
            DataCell(
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteTask(task.taskId),
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  TextStyle _tableHeaderStyle() {
    return GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      fontSize: 14,
    );
  }

DataCell _buildEditableTextCell(TaskRow task, String field) {
  bool isEditing = task.editingField == field;
  String value = field == 'taskName' ? task.taskName : task.assignee;

  // Handle Assignee dropdown field
  if (field == 'assignee') {
    return DataCell(
      DropdownButton<String>(
        isExpanded: true,
        value: members.firstWhere(
  (member) => member['user']['email'] == task.assignee,
  orElse: () => {'user': {'_id': null}}
)['user']['_id'],
        hint: Text('Select Assignee'),
        items: members.map<DropdownMenuItem<String>>((member) {
          return DropdownMenuItem<String>(
            value: member['user']['_id'], // User's ID as value
            child: Text(member['user']['email'] ?? 'No Email'), // Display user's email
          );
        }).toList(),
        onChanged: (String? selectedUserId) {
          if (selectedUserId != null) {
            print("Selected Assignee ID: $selectedUserId");

            // Find the selected member's email
            final selectedMember = members.firstWhere(
              (member) => member['user']['_id'] == selectedUserId,
              orElse: () => {'user': {'email': null}},
            );

            if (selectedMember['user']['email'] != null) {
              setState(() {
                task.assignee = selectedMember['user']['email'] ?? 'No Email'; // Update task's assignee
              });

              updateAssignee(selectedUserId, task.taskId); // Send update to backend
              sendMention(selectedUserId); // Send notification
            } else {
              print("Error: Selected user not found in members list");
            }
          }
        },
      ),
    );
  }

  // Default TextField for other editable fields
  return DataCell(
    isEditing
        ? TextField(
            autofocus: true,
            controller: TextEditingController(text: value),
            style: GoogleFonts.montserrat(fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onSubmitted: (newValue) {
              setState(() {
                if (field == 'taskName') {
                  task.taskName = newValue; // Update task name
                }
                task.editingField = null;
                updateTask(task); // Update backend
              });
            },
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                task.editingField = field;
              });
            },
            child: Text(value,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.black,
                )),
          ),
  );
}


  DataCell _buildStatusCell(TaskRow task) {
    final statusOptions = {
      "Pending": "pending",
      "In Progress": "in-progress",
      "Completed": "completed"
    };

    String currentDisplayValue = statusOptions.entries
        .firstWhere((e) => e.value == task.status, orElse: () => statusOptions.entries.first)
        .key;

    return DataCell(
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentDisplayValue,
          isDense: true,
          style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          items: statusOptions.keys.map((displayValue) {
            return DropdownMenuItem(
              value: displayValue,
              child: Text(displayValue),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                task.status = statusOptions[newValue]!;
               // updateTask(task);
               updateTaskStatus(task.taskId, newValue);
              });
            }
          },
        ),
      ),
    );
  }

  DataCell _buildPriorityCell(TaskRow task) {
    final priorityOptions = {
      "Low": "low",
      "Medium": "medium",
      "High": "high"
    };

    String currentDisplayValue = priorityOptions.entries
        .firstWhere((e) => e.value == task.priority, orElse: () => priorityOptions.entries.first)
        .key;

    return DataCell(
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentDisplayValue,
          isDense: true,
          style: GoogleFonts.montserrat(color: _getPriorityTextColor(task.priority), fontWeight: FontWeight.bold, fontSize: 14),
          items: priorityOptions.keys.map((displayValue) {
            return DropdownMenuItem(
              value: displayValue,
              child: Text(displayValue),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                task.priority = priorityOptions[newValue]!;
                updateTask(task);
             
              });
            }
          },
        ),
      ),
    );
  }

  Color _getPriorityTextColor(String priority) {
    switch (priority) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange[800]!;
      case "low":
        return Colors.green[800]!;
      default:
        return Colors.black;
    }
  }

  DataCell _buildDateCell(TaskRow task) {
    return DataCell(
      GestureDetector(
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: (task.dueDate != null && task.dueDate!.isNotEmpty)
                ? _parseDisplayDate(task.dueDate!)
                : DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            setState(() {
              task.dueDate = "${pickedDate.day} ${_getMonthName(pickedDate.month)} ${pickedDate.year}";
              updateTask(task);
            });
          }
        },
        child: Text(
          task.dueDate ?? 'Select Date',
          style: GoogleFonts.montserrat(
            color: (task.dueDate == null) ? Colors.grey : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  DateTime _parseDisplayDate(String displayDate) {
    // displayDate format: "12 March 2024"
    final parts = displayDate.split(' ');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]) ?? DateTime.now().day;
      final month = _monthNumberFromName(parts[1]);
      final year = int.tryParse(parts[2]) ?? DateTime.now().year;
      return DateTime(year, month, day);
    }
    return DateTime.now();
  }

  String _getMonthName(int month) {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[month - 1];
  }
}

class TaskRow {
  final String taskId;
  String taskName;
  String status;
  String assignee;
  String? dueDate;
  String priority;
  String? editingField; // to track which field is being edited

  TaskRow({
    required this.taskId,
    required this.taskName,
    required this.status,
    required this.assignee,
    this.dueDate,
    required this.priority,
    this.editingField,
  });

  factory TaskRow.fromMap(Map<String, dynamic> map) {
  return TaskRow(
    taskId: map['_id'] ?? '',
    taskName: map['title'] ?? 'Untitled',
    status: map['status'] ?? 'pending',
    assignee: map['assignee'] is Map 
        ? map['assignee']['email'] ?? 'Unassigned' // Extract 'email' field
        : map['assignee'] ?? 'Unassigned', // Fallback if not a nested map
    dueDate: map['dueDate'],
    priority: map['priority'] ?? 'low',
  );
}

}

