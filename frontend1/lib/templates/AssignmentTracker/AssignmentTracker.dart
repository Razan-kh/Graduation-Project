

// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:intl/intl.dart'; // Import the intl package for date formatting
// import 'dart:convert'; // For JSON decoding
// import 'package:http/http.dart' as http; // For HTTP requests

// class DynamicTablePage extends StatefulWidget {
//   @override
//   _DynamicTablePageState createState() => _DynamicTablePageState();
// }

// class _DynamicTablePageState extends State<DynamicTablePage> {
//   List<List<Map<String, dynamic>>> rows = [];
//   List<List<TextEditingController>> controllers = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchDataFromDatabase(); // Fetch data when the page initializes
//   }

//   // Fetch data from the database
//   Future<void> _fetchDataFromDatabase() async {
//     String apiUrl = 'http://$localhost/getassignments'; // Replace with your actual API endpoint

//     try {
//       var response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body);
//         print('Fetched Data: $data'); // Log the fetched data

//         // Process the fetched data
//         List<List<Map<String, dynamic>>> fetchedRows = data.map<List<Map<String, dynamic>>>((row) {
//           return [
//             {
//               'name': row['assignmentName'],
//               'type': 'string',
//               'value': row['assignmentName'] ?? 'Empty'
//             }, // Assignment Name
//             ...row['properties'].map<Map<String, dynamic>>((property) {
//               return {
//                 'name': property['name'],
//                 'type': property['type'],
//                 'value': property['value'] ?? 'Empty',
//               };
//             }).toList(),
//           ];
//         }).toList();

//         setState(() {
//           rows = fetchedRows;
//           _initializeControllers();
//         });
//       } else {
//         print('Failed to fetch data: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error while fetching data: $error');
//     }
//   }

//   void _initializeControllers() {
//     controllers = rows.map((row) {
//       return row.map((property) => TextEditingController(text: property['value'].toString())).toList();
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dynamic Table'),
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Scrollable table area
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Container(
//               color: Colors.white,
//               child: DataTable(
//                 headingRowColor: MaterialStateProperty.all(Colors.white),
//                 columnSpacing: 20,
//                 headingRowHeight: 56,
//                 border: TableBorder.all(color: Colors.grey, width: 0.5),
//                 columns: rows.isNotEmpty
//                     ? [
//                         DataColumn(
//                           label: Text(
//                             'Assignment Name',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//                         ...rows[0].sublist(1).map((property) {
//                           return DataColumn(
//                             label: Text(
//                               property['name'],
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           );
//                         }).toList()
//                     ]
//                     : [], // Ensure columns are created only if there is data
//                 rows: rows.isNotEmpty
//                     ? List.generate(
//                         rows.length,
//                         (rowIndex) => DataRow(
//                           cells: List.generate(
//                             rows[rowIndex].length,
//                             (colIndex) {
//                               var property = rows[rowIndex][colIndex];
//                               if (colIndex == 0) {
//                                 // First column (Assignment Name)
//                                 return DataCell(
//                                   Text(property['value']),
//                                 );
//                               }
//                               switch (property['type']) {
//                                 case 'string': // Editable text
//                                 case 'number': // Editable number
//                                   return DataCell(
//                                     TextField(
//                                       controller: controllers[rowIndex][colIndex],
//                                       decoration: InputDecoration(
//                                         hintText: "Enter ${property['name']}",
//                                         border: InputBorder.none,
//                                       ),
//                                       onChanged: (value) {
//                                         setState(() {
//                                           rows[rowIndex][colIndex]['value'] = value;
//                                         });
//                                       },
//                                     ),
//                                   );
//                                 case 'date': // Calendar (formatted date)
//                                   return DataCell(
//                                     GestureDetector(
//                                       onTap: () => _showCalendarDialog(rowIndex, colIndex),
//                                       child: Text(
//                                         property['value'] is DateTime
//                                             ? DateFormat.yMd().format(property['value'])
//                                             : property['value'].toString(),
//                                       ),
//                                     ),
//                                   );
//                                 case 'status': // List with status
//                                   return DataCell(
//                                     GestureDetector(
//                                       onTap: () => _showListDialog(rowIndex, colIndex),
//                                       child: Text(property['value']),
//                                     ),
//                                   );
//                                 default:
//                                   return DataCell(Text(property['value'].toString())); // Default cell for other types
//                               }
//                             },
//                           ),
//                         ),
//                       )
//                     : [], // Return an empty list if there are no rows
//               ),
//             ),
//           ),

//           // "New +" button outside of the scrollable area
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: GestureDetector(
//               onTap: _addNewRow,
//               child: Text(
//                 'New +',
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 16,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Dialog to display a list of options
//   void _showListDialog(int rowIndex, int colIndex) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Choose Option"),
//           content: Container(
//             height: 150,
//             child: ListView(
//               children: [
//                 ListTile(
//                   title: Text("Option 1"),
//                   onTap: () {
//                     setState(() {
//                       rows[rowIndex][colIndex]['value'] = "Option 1";
//                     });
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   title: Text("Option 2"),
//                   onTap: () {
//                     setState(() {
//                       rows[rowIndex][colIndex]['value'] = "Option 2";
//                     });
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Function to open a calendar date picker dialog
//   Future<void> _showCalendarDialog(int rowIndex, int colIndex) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     setState(() {
//       rows[rowIndex][colIndex]['value'] = pickedDate;
//     });
//     }

//   // Function to add a new row to the table
//   void _addNewRow() {
//     setState(() {
//       rows.add([
//         {'name': 'New Assignment', 'type': 'string', 'value': 'New Assignment'},
//         {'name': 'Due Date', 'type': 'date', 'value': DateTime.now()},
//         {'name': 'Weight', 'type': 'number', 'value': 'Empty'},
//         {'name': 'Mark (Weight)', 'type': 'number', 'value': '0'},
//         {'name': 'Priority', 'type': 'string', 'value': 'Empty'},
//         {'name': 'Status', 'type': 'status', 'value': 'Not started'},
//       ]);
//       _initializeControllers();
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:google_fonts/google_fonts.dart';

class DynamicTablePage extends StatefulWidget {
  const DynamicTablePage({super.key});

  @override
  _DynamicTablePageState createState() => _DynamicTablePageState();
}

class _DynamicTablePageState extends State<DynamicTablePage> {
  List<List<Map<String, dynamic>>> rows = [];
  List<List<TextEditingController>> controllers = [];

  @override
  void initState() {
    super.initState();
    _fetchDataFromDatabase(); // Fetch data when the page initializes
  }

  // Fetch data from the database
  Future<void> _fetchDataFromDatabase() async {
    String apiUrl = 'http://$localhost/getassignments'; // Replace with your actual API endpoint

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print('Fetched Data: $data'); // Log the fetched data

        // Process the fetched data
        List<List<Map<String, dynamic>>> fetchedRows = data.map<List<Map<String, dynamic>>>((row) {
          return [
            {
              'name': row['assignmentName'],
              'type': 'string',
              'value': row['assignmentName'] ?? 'Empty'
            }, // Assignment Name
            ...row['properties'].map<Map<String, dynamic>>((property) {
              return {
                'name': property['name'],
                'type': property['type'],
                'value': property['value'] ?? 'Empty',
              };
            }).toList(),
          ];
        }).toList();

        setState(() {
          rows = fetchedRows;
          _initializeControllers();
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error while fetching data: $error');
    }
  }

  void _initializeControllers() {
    controllers = rows.map((row) {
      return row.map((property) => TextEditingController(text: property['value'].toString())).toList();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dynamic Table',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scrollable table area
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                color: Colors.white,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                  columnSpacing: 20,
                  headingRowHeight: 56,
                  border: TableBorder.all(color: Colors.grey[300]!, width: 0.5),
                  columns: rows.isNotEmpty
                      ? [
                          DataColumn(
                            label: Text(
                              'Assignment Name',
                              style: GoogleFonts.montserrat(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ...rows[0].sublist(1).map((property) {
                            return DataColumn(
                              label: Text(
                                property['name'],
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          })
                        ]
                      : [], // Ensure columns are created only if there is data
                  rows: rows.isNotEmpty
                      ? List.generate(
                          rows.length,
                          (rowIndex) => DataRow(
                            cells: List.generate(
                              rows[rowIndex].length,
                              (colIndex) {
                                var property = rows[rowIndex][colIndex];
                                if (colIndex == 0) {
                                  // First column (Assignment Name)
                                  return DataCell(
                                    Text(
                                      property['value'],
                                      style: GoogleFonts.montserrat(
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                  );
                                }
                                switch (property['type']) {
                                  case 'string': // Editable text
                                  case 'number': // Editable number
                                    return DataCell(
                                      TextField(
                                        controller: controllers[rowIndex][colIndex],
                                        style: GoogleFonts.montserrat(),
                                        decoration: InputDecoration(
                                          hintText: "Enter ${property['name']}",
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            rows[rowIndex][colIndex]['value'] = value;
                                          });
                                        },
                                      ),
                                    );
                                  case 'date': // Calendar (formatted date)
                                    return DataCell(
                                      GestureDetector(
                                        onTap: () => _showCalendarDialog(rowIndex, colIndex),
                                        child: Text(
                                          property['value'] is DateTime
                                              ? DateFormat.yMd().format(property['value'])
                                              : property['value'].toString(),
                                          style: GoogleFonts.montserrat(
                                            color: Colors.grey[900],
                                          ),
                                        ),
                                      ),
                                    );
                                  case 'status': // List with status
                                    return DataCell(
                                      GestureDetector(
                                        onTap: () => _showListDialog(rowIndex, colIndex),
                                        child: Text(
                                          property['value'],
                                          style: GoogleFonts.montserrat(
                                            color: Colors.grey[900],
                                          ),
                                        ),
                                      ),
                                    );
                                  default:
                                    return DataCell(
                                      Text(
                                        property['value'].toString(),
                                        style: GoogleFonts.montserrat(
                                          color: Colors.grey[900],
                                        ),
                                      ), // Default cell for other types
                                    );
                                }
                              },
                            ),
                          ),
                        )
                      : [], // Return an empty list if there are no rows
                ),
              ),
            ),
          ),

          // "New +" button outside of the scrollable area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: _addNewRow,
              child: Text(
                'New +',
                style: GoogleFonts.montserrat(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog to display a list of options
  void _showListDialog(int rowIndex, int colIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Choose Option",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            height: 150,
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    "Option 1",
                    style: GoogleFonts.montserrat(),
                  ),
                  onTap: () {
                    setState(() {
                      rows[rowIndex][colIndex]['value'] = "Option 1";
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    "Option 2",
                    style: GoogleFonts.montserrat(),
                  ),
                  onTap: () {
                    setState(() {
                      rows[rowIndex][colIndex]['value'] = "Option 2";
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to open a calendar date picker dialog
  Future<void> _showCalendarDialog(int rowIndex, int colIndex) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    setState(() {
      rows[rowIndex][colIndex]['value'] = pickedDate;
    });
  }

  // Function to add a new row to the table
  void _addNewRow() {
    setState(() {
      rows.add([
        {'name': 'New Assignment', 'type': 'string', 'value': 'New Assignment'},
        {'name': 'Due Date', 'type': 'date', 'value': DateTime.now()},
        {'name': 'Weight', 'type': 'number', 'value': 'Empty'},
        {'name': 'Mark (Weight)', 'type': 'number', 'value': '0'},
        {'name': 'Priority', 'type': 'string', 'value': 'Empty'},
        {'name': 'Status', 'type': 'status', 'value': 'Not started'},
      ]);
      _initializeControllers();
    });
  }
}
