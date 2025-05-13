// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:frontend1/templates/AssignmentTracker/AssignmentTracker.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AssignmentTrackerPage extends StatefulWidget {
//   @override
//   _AssignmentTrackerPageState createState() => _AssignmentTrackerPageState();
// }

// class _AssignmentTrackerPageState extends State<AssignmentTrackerPage> {
//   String pageTitle = "New page"; // The editable text for the title
//   String icon = '😊'; // Placeholder for the icon
//   String cover = 'Add cover'; // Placeholder for the cover

//   List<Map<String, dynamic>> properties = [
//     {'name': 'Course', 'type': 'string', 'value': 'Empty'},
//     {'name': 'Due Date', 'type': 'date', 'value': 'Empty'},
//     {'name': 'Weight', 'type': 'number', 'value': 'Empty'},
//     {'name': 'Mark (Weight)', 'type': 'number', 'value': '0'},
//     {'name': 'Priority', 'type': 'string', 'value': 'Empty'},
//     {'name': 'Status', 'type': 'status', 'value': 'Not started'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchAssignmentProperties(); // Fetch properties when the page loads
//   }

//   // Method to fetch properties from the backend
//   Future<void> fetchAssignmentProperties() async {
//     String apiUrl = 'http://$localhost/getassignments'; // Replace with the actual endpoint

//     try {
//       var response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         // Parse the response body and replace the existing properties array
//         var data = json.decode(response.body);
//         setState(() {
//           properties = List<Map<String, dynamic>>.from(data['properties']);
//         });
//       } else {
//         print('Failed to fetch data: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error fetching data: $error');
//     }
//   }

//   // Method to handle icon change
//   void changeIcon() {
//     setState(() {
//       icon = '😀'; // Change to another emoji for simplicity
//     });
//   }

//   // Method to change cover
//   void changeCover() {
//     setState(() {
//       cover = 'Cover selected';
//     });
//   }

//   // Method to update a property
//   void updateProperty(int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Update ${properties[index]['name']}'),
//           content: _buildPropertyInput(properties[index]),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close dialog
//               },
//               child: Text('Close'),
//             )
//           ],
//         );
//       },
//     );
//   }

//   // Building input for properties based on their type
//   Widget _buildPropertyInput(Map<String, dynamic> property) {
//     if (property['type'] == 'string') {
//       return TextField(
//         onChanged: (value) {
//           setState(() {
//             property['value'] = value;
//           });
//         },
//         decoration: InputDecoration(
//           hintText: 'Enter value for ${property['name']}',
//         ),
//       );
//     } else if (property['type'] == 'date') {
//       return TextButton(
//         onPressed: () async {
//           DateTime? selectedDate = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(2000),
//             lastDate: DateTime(2100),
//           );
//           setState(() {
//             property['value'] = selectedDate.toString();
//           });
//                 },
//         child: Text('Pick a Date'),
//       );
//     } else if (property['type'] == 'status') {
//       return DropdownButton<String>(
//         value: property['value'],
//         items: ['Not started', 'In progress', 'Completed']
//             .map((status) => DropdownMenuItem(
//                   child: Text(status),
//                   value: status,
//                 ))
//             .toList(),
//         onChanged: (value) {
//           setState(() {
//             property['value'] = value;
//           });
//         },
//       );
//     }
//     return SizedBox.shrink();
//   }

//   // Navigation method to open the "Add Property" page
//   void _navigateToAddProperty() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddPropertyPage(
//           onAddProperty: (newProperty) {
//             setState(() {
//               properties.add(newProperty);
//             });
//           },
//         ),
//       ),
//     );
//   }

//   // Method to save data when the page is closed
//   void saveData() async {
//     String subjectName = pageTitle;
//     List<Map<String, dynamic>> columns = properties;

//     Map<String, dynamic> requestData = {
//       'assignmentName': subjectName,
//       'properties': columns,
//     };

//     String apiUrl = 'http://$localhost/assignments';

//     try {
//       var response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestData),
//       );

//       if (response.statusCode == 201) {
//         print('Data saved successfully: ${response.body}');
//       } else {
//         print('Failed to save data: ${response.statusCode}');
//         print('Error: ${response.body}');
//       }
//     } catch (error) {
//       print('Error while saving data: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('New Page'),
//         backgroundColor: Colors.white,
//         actions: [
//           TextButton(
//             onPressed: () {
//               saveData();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => DynamicTablePage()),
//               );
//             },
//             child: Text(
//               'Done',
//               style: TextStyle(color: Colors.blue, fontSize: 18),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: changeIcon,
//                   child: Row(
//                     children: [
//                       Text(icon),
//                       SizedBox(width: 8),
//                       Text('Add icon'),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 GestureDetector(
//                   onTap: changeCover,
//                   child: Row(
//                     children: [
//                       Icon(Icons.image),
//                       SizedBox(width: 8),
//                       Text(cover),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               onChanged: (value) {
//                 setState(() {
//                   pageTitle = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: pageTitle,
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           Divider(),
//           Expanded(
//             child: ListView.builder(
//               itemCount: properties.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(properties[index]['name']),
//                   subtitle: Text(properties[index]['value']),
//                   onTap: () => updateProperty(index),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(1.0),
//             child: ElevatedButton(
//               onPressed: _navigateToAddProperty,
//               child: Text('Add a property +'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Separate page for adding a new property
// class AddPropertyPage extends StatefulWidget {
//   final Function(Map<String, dynamic>) onAddProperty;

//   AddPropertyPage({required this.onAddProperty});

//   @override
//   _AddPropertyPageState createState() => _AddPropertyPageState();
// }

// class _AddPropertyPageState extends State<AddPropertyPage> {
//   String newPropertyName = '';
//   String newPropertyType = 'string';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add a Property'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(labelText: 'Property Name'),
//               onChanged: (value) {
//                 setState(() {
//                   newPropertyName = value;
//                 });
//               },
//             ),
//             DropdownButton<String>(
//               value: newPropertyType,
//               items: ['string', 'date', 'number', 'status']
//                   .map((type) => DropdownMenuItem(
//                         child: Text(type),
//                         value: type,
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   newPropertyType = value!;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 if (newPropertyName.isNotEmpty) {
//                   widget.onAddProperty({
//                     'name': newPropertyName,
//                     'type': newPropertyType,
//                     'value': newPropertyType == 'string'
//                         ? 'Empty'
//                         : (newPropertyType == 'number' ? '0' : 'Empty'),
//                   });
//                   Navigator.pop(context); // Close the page
//                 }
//               },
//               child: Text('Add Property'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/AssignmentTracker/AssignmentTracker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class AssignmentTrackerPage extends StatefulWidget {
  const AssignmentTrackerPage({super.key});

  @override
  _AssignmentTrackerPageState createState() => _AssignmentTrackerPageState();
}

class _AssignmentTrackerPageState extends State<AssignmentTrackerPage> {
  String pageTitle = "New page"; // The editable text for the title
  String icon = '😊'; // Placeholder for the icon
  String cover = 'Add cover'; // Placeholder for the cover

  List<Map<String, dynamic>> properties = [
    {'name': 'Course', 'type': 'string', 'value': 'Empty'},
    {'name': 'Due Date', 'type': 'date', 'value': 'Empty'},
    {'name': 'Weight', 'type': 'number', 'value': 'Empty'},
    {'name': 'Mark (Weight)', 'type': 'number', 'value': '0'},
    {'name': 'Priority', 'type': 'string', 'value': 'Empty'},
    {'name': 'Status', 'type': 'status', 'value': 'Not started'},
  ];

  @override
  void initState() {
    super.initState();
    fetchAssignmentProperties(); // Fetch properties when the page loads
  }

  Future<void> fetchAssignmentProperties() async {
    String apiUrl = 'http://$localhost/getassignments';
    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          properties = List<Map<String, dynamic>>.from(data['properties']);
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void changeIcon() {
    setState(() {
      icon = '😀';
    });
  }

  void changeCover() {
    setState(() {
      cover = 'Cover selected';
    });
  }

  void updateProperty(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Update ${properties[index]['name']}',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: _buildPropertyInput(properties[index]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: GoogleFonts.montserrat(color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildPropertyInput(Map<String, dynamic> property) {
    if (property['type'] == 'string') {
      return TextField(
        onChanged: (value) {
          setState(() {
            property['value'] = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Enter value for ${property['name']}',
          hintStyle: GoogleFonts.montserrat(),
        ),
      );
    } else if (property['type'] == 'date') {
      return TextButton(
        onPressed: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          setState(() {
            property['value'] = selectedDate.toString();
          });
        },
        child: Text(
          'Pick a Date',
          style: GoogleFonts.montserrat(color: Colors.blue),
        ),
      );
    } else if (property['type'] == 'status') {
      return DropdownButton<String>(
        value: property['value'],
        items: ['Not started', 'In progress', 'Completed']
            .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status, style: GoogleFonts.montserrat()),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            property['value'] = value;
          });
        },
      );
    }
    return SizedBox.shrink();
  }

  void _navigateToAddProperty() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPropertyPage(
          onAddProperty: (newProperty) {
            setState(() {
              properties.add(newProperty);
            });
          },
        ),
      ),
    );
  }

  void saveData() async {
    String subjectName = pageTitle;
    List<Map<String, dynamic>> columns = properties;

    Map<String, dynamic> requestData = {
      'assignmentName': subjectName,
      'properties': columns,
    };

    String apiUrl = 'http://$localhost/assignments';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        print('Data saved successfully: ${response.body}');
      } else {
        print('Failed to save data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error while saving data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'New Page',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              saveData();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DynamicTablePage()),
              );
            },
            child: Text(
              'Done',
              style: GoogleFonts.montserrat(color: Colors.blue, fontSize: 18),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: changeIcon,
                  child: Row(
                    children: [
                      Text(icon, style: TextStyle(fontSize: 24)),
                      SizedBox(width: 8),
                      Text(
                        'Add icon',
                        style: GoogleFonts.montserrat(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: changeCover,
                  child: Row(
                    children: [
                      Icon(Icons.image, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        cover,
                        style: GoogleFonts.montserrat(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold),
              onChanged: (value) {
                setState(() {
                  pageTitle = value;
                });
              },
              decoration: InputDecoration(
                hintText: pageTitle,
                border: InputBorder.none,
                hintStyle: GoogleFonts.montserrat(color: Colors.grey[600]),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    properties[index]['name'],
                    style: GoogleFonts.montserrat(),
                  ),
                  subtitle: Text(
                    properties[index]['value'],
                    style: GoogleFonts.montserrat(color: Colors.grey[700]),
                  ),
                  onTap: () => updateProperty(index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              onPressed: _navigateToAddProperty,
              child: Text(
                'Add a property +',
                style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddPropertyPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddProperty;

  const AddPropertyPage({super.key, required this.onAddProperty});

  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  String newPropertyName = '';
  String newPropertyType = 'string';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Add a Property',
          style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Property Name',
                labelStyle: GoogleFonts.montserrat(color: Colors.grey[700]),
              ),
              onChanged: (value) {
                setState(() {
                  newPropertyName = value;
                });
              },
            ),
            DropdownButton<String>(
              value: newPropertyType,
              items: ['string', 'date', 'number', 'status']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: GoogleFonts.montserrat(),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  newPropertyType = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (newPropertyName.isNotEmpty) {
                  widget.onAddProperty({
                    'name': newPropertyName,
                    'type': newPropertyType,
                    'value': newPropertyType == 'string'
                        ? 'Empty'
                        : (newPropertyType == 'number' ? '0' : 'Empty'),
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Add Property',
                style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
