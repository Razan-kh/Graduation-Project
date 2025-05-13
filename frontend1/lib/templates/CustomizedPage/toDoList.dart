import 'package:flutter/material.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/color.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/services.dart';
import 'package:provider/provider.dart';

class ToDoListPage extends StatefulWidget {
 final List<Map<String, dynamic>> tasks ;
  final int index;
  final String pageId;

  const ToDoListPage({super.key, required this.tasks, required this.index,required this.pageId});


  @override
  ToDoListPageState createState() => ToDoListPageState();
}

class ToDoListPageState extends State<ToDoListPage> {
    List<Map<String, dynamic>> tasks = [
    {"task": "", "checked": false}
  ];
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  int _lostFocusCount = 0;
  @override
  void initState()
  {
    super.initState();
    tasks=widget.tasks;
     _controllers.addAll(
      tasks.map((task) => TextEditingController(text: task["task"])).toList(),
    );
    _focusNodes.addAll(
      List.generate(tasks.length, (_) => FocusNode()),
    );
  for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          _lostFocusCount++;
          if (_lostFocusCount == _focusNodes.length) {
            _allFocusLost(); // Call the function when all focus nodes lose focus
          }
        }
      });
    }
  }

  // This method will be called when all focus nodes lose focus
  void _allFocusLost() {
dynamic newContent = {
        'tasks': tasks,

  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
  }

 void _handleKeyPress(String value, int index) {
    if (value.trim().isNotEmpty && index == tasks.length - 1) {
      setState(() {
        // Add a new task with an empty string
   tasks.add({"task": "", "checked": false});
        _controllers.add(TextEditingController());
        FocusNode newFocusNode = FocusNode();
        newFocusNode.addListener(() {
          if (!newFocusNode.hasFocus) {
            _lostFocusCount++;
            if (_lostFocusCount == _focusNodes.length) {
              _allFocusLost(); // Call the function when all focus nodes lose focus
            }
          }
        });
        _focusNodes.add(newFocusNode);
      });
    }
  }



  // This method is triggered whenever a task text is changed
void _handleTaskChange(String value, int index) {
  setState(() {
    if (value.trim().isEmpty) {
      // Dispose of the controller and focus node before removing them
      _controllers.removeAt(index).dispose();
      _focusNodes.removeAt(index).dispose();
      tasks.removeAt(index);

      // Recalculate the lost focus count
      _lostFocusCount = _focusNodes.where((focusNode) => !focusNode.hasFocus).length;

      // If all focus nodes have lost focus, call _allFocusLost
      if (_lostFocusCount == _focusNodes.length) {
        _allFocusLost();
      }
    } else {
      // Update the task text
    tasks[index]["task"] = value.trim();
    }
  });
}

  // This method is triggered when the checkbox state changes
  void _handleCheckboxChange(bool? value, int index) {
    setState(() {
      tasks[index]["checked"] = value ?? false; // Update the checkbox state
    });
  }

  Widget _buildTaskItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Square Checkbox
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Checkbox(
              value: tasks[index]["checked"], // Use the checkbox state
              onChanged: (bool? value) => _handleCheckboxChange(value, index),
            ),
          ),
          // Editable Text Field
          Expanded(
            child: TextField(
              autofocus: index == tasks.length - 1, // Focus on last text field
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              onChanged: (value) => _handleTaskChange(value, index),
              onSubmitted: (value) {
                // Call _handleKeyPress to add a new task
                _handleKeyPress(value, index);
              },
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                hintText: "Type a task...",
                border: InputBorder.none,
              ),
              maxLines: 1, // Prevent multiline input (only one line allowed)
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controllers and focus nodes to prevent memory leaks
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        final BackgroundColor = context.watch<BackgroundColorNotifier>().backgroundColor;
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => _buildTaskItem(index),
          ),
        ),
      ),
    );
  }
}
