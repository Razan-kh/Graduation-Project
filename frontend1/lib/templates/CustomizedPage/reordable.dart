/*
import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<CustomPage> {
  List<Map<String, dynamic>> toDoLists = []; // Stores all to-do lists

  void addNewToDoList() {
    setState(() {
      toDoLists.add({
        'title': 'New To-Do List',
        'tasks': <Map<String, dynamic>>[], // Each task has a name and completion status
      });
    });
  }

  void addTask(int listIndex) {
    setState(() {
      toDoLists[listIndex]['tasks'].add({
        'task': 'New Task',
        'completed': false,
      });
    });
  }

  void editTask(int listIndex, int taskIndex, String newTaskName) {
    setState(() {
      toDoLists[listIndex]['tasks'][taskIndex]['task'] = newTaskName;
    });
  }

  void toggleTaskCompletion(int listIndex, int taskIndex) {
    setState(() {
      toDoLists[listIndex]['tasks'][taskIndex]['completed'] =
          !toDoLists[listIndex]['tasks'][taskIndex]['completed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do Lists'),
      ),
      body: toDoLists.isEmpty
          ? Center(
              child: Text(
                'No To-Do Lists Yet. Add a new list!',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: toDoLists.length,
              itemBuilder: (context, listIndex) {
                final toDoList = toDoLists[listIndex];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              toDoList['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => addTask(listIndex),
                              icon: Icon(Icons.add),
                              tooltip: 'Add Task',
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: toDoList['tasks'].length,
                          itemBuilder: (context, taskIndex) {
                            final task = toDoList['tasks'][taskIndex];
                            return ListTile(
                              leading: Checkbox(
                                value: task['completed'],
                                onChanged: (value) {
                                  toggleTaskCompletion(listIndex, taskIndex);
                                },
                              ),
                              title: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      TextEditingController controller =
                                          TextEditingController(
                                              text: task['task']);
                                      return AlertDialog(
                                        title: Text('Edit Task'),
                                        content: TextField(
                                          controller: controller,
                                          decoration: InputDecoration(
                                            labelText: 'Task Name',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              editTask(
                                                  listIndex,
                                                  taskIndex,
                                                  controller.text);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  task['task'],
                                  style: TextStyle(
                                    decoration: task['completed']
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewToDoList,
        child: Icon(Icons.add),
        tooltip: 'Add To-Do List',
      ),
    );
  }
}
*/