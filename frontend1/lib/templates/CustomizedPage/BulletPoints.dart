import 'package:flutter/material.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/color.dart';
import 'package:frontend1/templates/CustomizedPage/Providers/services.dart';
import 'package:provider/provider.dart';
class Bulletpoints extends StatefulWidget {
  final List<String> tasks;
  final int index;
  final String pageId;
   final double fontSize;
    final int fontColor;
  const Bulletpoints({super.key, required this.tasks, required this.index,required this.pageId,required this.fontColor,required this.fontSize});

  @override
  _NotionStyleToDoPageState createState() => _NotionStyleToDoPageState();
}

class _NotionStyleToDoPageState extends State<Bulletpoints> {
  List<String> tasks = [];
     final double fontSize=24.0;
    final Color fontColor=Colors.black;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
 int _lostFocusCount = 0;

  @override
  void initState() {
    super.initState();
    tasks = List.from(widget.tasks); // Initialize tasks from widget.tasks
    final Color fontColor=Color(widget.fontColor); 
     final double fontSize=widget.fontSize;

print("inside bullet tasks ara $tasks");
    // Initialize _controllers and _focusNodes based on the number of tasks
   _controllers.addAll(List.generate(
      tasks.length,
      (index) {
        final controller = TextEditingController(text: tasks[index]); // Set initial text to task
        return controller;
      },
    ));
_focusNodes.addAll(
  List.generate(tasks.length, (index) {
    final focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        _lostFocusCount++;
        if (_lostFocusCount == _focusNodes.length) {
          _allFocusLost(); // Trigger when all focus nodes lose focus
        }
      }
    });
    return focusNode;
  }),
);


  }

  // This method will be called when all focus nodes lose focus
  void _allFocusLost() {
 dynamic newContent = {
    'tasks':tasks,
    'fontSize':fontSize,
    'fontColor':fontColor.value.toDouble()
  };
updateElementContent(pageId:widget.pageId,elementIndex:widget.index,newContent:newContent);
  }

  // This method is triggered when the user presses "Enter" or "Done" to add a new task
 void _handleKeyPress(String value, int index) {
    if (value.trim().isNotEmpty && index == tasks.length - 1) {
      setState(() {
        // Add a new task with an empty string
        tasks.add("");
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
      tasks[index] = value.trim();
    }
  });
}



  Widget _buildTaskItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet point for the task item
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "•", // Bullet point symbol
              style: TextStyle(fontSize: 20, color: Colors.black),
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

