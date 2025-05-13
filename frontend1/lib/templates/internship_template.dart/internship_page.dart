

// // // a custom comparator-based sorting. This means we define specific rules to determine the order of elements in a list. Let me break it down step-by-step:

// // // Sorting Goals
// // // Rejected Applications: Always appear at the bottom of the list, regardless of their priority.

// // // Priority:

// // // High priority applications appear at the top.
// // // Medium priority applications appear in the middle.
// // // Low priority applications appear at the bottom, just above rejected applications.
// // // Applications with the same priority and non-rejected statuses should maintain their order relative to other criteria (e.g., by other fields or insertion order).

// // // Algorithm Breakdown
// // // Weights for Priorities and Statuses:

// // // Assign numerical weights to statuses and priorities to allow comparison.
// // // Priority:
// // // High = 1 (highest priority)
// // // Medium = 2 (middle priority)
// // // Low = 3 (lowest priority)
// // // Status:
// // // Rejected = 2 (lowest importance)
// // // All others (Not started, In progress, Offered) = 0 (higher importance)
// // // Sorting Logic:

// // // First, sort by status:
// // // Rejected applications always go to the bottom because their weight is the highest (2 compared to 0).
// // // Then, sort by priority:
// // // Within each status group (not rejected), applications are sorted by priority weights, so High (1) comes first, Medium (2) second, and Low (3) last.
// // // Implementation: The algorithm uses a custom comparator in the sort method of the list.


// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';

// class InternshipApplicationsWidget extends StatefulWidget {
//   final String token;
//   final String templateId;

//   InternshipApplicationsWidget({required this.token, required this.templateId});

//   @override
//   _InternshipApplicationsWidgetState createState() =>
//       _InternshipApplicationsWidgetState();
// }

// class _InternshipApplicationsWidgetState
//     extends State<InternshipApplicationsWidget> {
//   List<Map<String, dynamic>> applications = [];
//   List<Map<String, dynamic>> offers = [];
//   String? editableApplicationId;
//   String? editableField;
//   String filterStatus = "All";
//   String filterPriority = "All";

//   final Map<String, Color> statusColors = {
//     'Not started': Colors.grey,
//     'In progress': Colors.blue,
//     'Offered': Colors.green,
//     'Rejected': Colors.red,
//   };

//   final Map<String, Color> priorityColors = {
//     'Low': Colors.green,
//     'Medium': Colors.orange,
//     'High': Colors.red,
//   };

//   @override
//   void initState() {
//     super.initState();
//     fetchApplications();
//   }

//   Future<void> fetchApplications() async {
//     final response = await http.get(
//       Uri.parse(
//           'http://$localhost/api/internship/applications/${widget.templateId}'),
//       headers: {'Authorization': 'Bearer ${widget.token}'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         if (data['applications'] != null && data['applications'] is List) {
//           applications = List<Map<String, dynamic>>.from(data['applications']);
//           _sortApplications();
//         } else {
//           applications = [];
//         }
//       });
//     } else {
//       print("Failed to fetch applications: ${response.body}");
//     }
//   }

//   void _sortApplications() {
//     applications.sort((a, b) {
//       final priorityWeight = {'High': 1, 'Medium': 2, 'Low': 3};
//       final statusWeight = {'Rejected': 2, 'Offered': 0, 'In progress': 0, 'Not started': 0};

//       int statusCompare = (statusWeight[a['status']] ?? 0)
//           .compareTo(statusWeight[b['status']] ?? 0);
//       if (statusCompare != 0) return statusCompare;

//       return (priorityWeight[a['priority']] ?? 3)
//           .compareTo(priorityWeight[b['priority']] ?? 3);
//     });

//     offers = applications.where((app) => app['status'] == 'Offered').toList();
//     applications = applications.where((app) => app['status'] != 'Offered').toList();
//   }

//   Future<void> updateApplicationField(
//       String applicationId, String field, dynamic value) async {
//     final application = applications.firstWhere((app) => app['_id'] == applicationId);

//     final updatedApplication = {
//       ...application,
//       field: value,
//     };

//     final response = await http.put(
//       Uri.parse('http://$localhost/api/internship/application'),
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//         'Content-Type': 'application/json'
//       },
//       body: json.encode({
//         'templateId': widget.templateId,
//         'applicationId': applicationId,
//         'updates': updatedApplication,
//       }),
//     );

//     if (response.statusCode == 200) {
//       fetchApplications();
//     } else {
//       print("Failed to update application: ${response.body}");
//     }
//   }

//   Future<void> deleteApplication(String applicationId) async {
//     final response = await http.delete(
//       Uri.parse('http://$localhost/api/internship/application'),
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//         'Content-Type': 'application/json'
//       },
//       body: json.encode({
//         'templateId': widget.templateId,
//         'applicationId': applicationId,
//       }),
//     );

//     if (response.statusCode == 200) {
//       fetchApplications();
//     } else {
//       print("Failed to delete application: ${response.body}");
//     }
//   }

//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   Future<void> addApplication() async {
//     final response = await http.post(
//       Uri.parse('http://$localhost/api/internship/application'),
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//         'Content-Type': 'application/json'
//       },
//       body: json.encode({
//         'templateId': widget.templateId,
//         'application': {
//           'company': 'New Company',
//           'role': 'New Role',
//           'status': 'Not started',
//           'priority': 'Low',
//           'source': '',
//           'link': '',
//           'deadline': null,
//           'materials': '',
//           'submittedOn': null,
//           'network': '',
//           'interviewDate': null,
//         },
//       }),
//     );

//     if (response.statusCode == 200) {
//       fetchApplications();
//     } else {
//       print("Failed to add application: ${response.body}");
//     }
//   }

//   List<Map<String, dynamic>> getFilteredApplications() {
//     return applications.where((app) {
//       final matchesStatus = filterStatus == "All" || app['status'] == filterStatus;
//       final matchesPriority = filterPriority == "All" || app['priority'] == filterPriority;
//       return matchesStatus && matchesPriority;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           iconTheme: IconThemeData(color: Colors.black),
//           title: Text(
//             '🖥️ Internship Applications',
//             style: TextStyle(color: Colors.black),
//           ),
//           bottom: TabBar(
//             indicatorColor: Colors.blue,
//             labelColor: Colors.blue,
//             unselectedLabelColor: Colors.grey,
//             tabs: [
//               Tab(text: 'Applications'),
//               Tab(text: 'Offers'),
//             ],
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               _buildFilterRow(),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height,
//                 child: TabBarView(
//                   children: [
//                     _buildApplicationsTable(getFilteredApplications()),
//                     _buildApplicationsTable(offers),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: addApplication,
//           backgroundColor: Colors.blue, // Consistent styling
//           child: Icon(Icons.add),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterRow() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _filterDropdown('Filter by Status', filterStatus, statusColors.keys.toList(), (value) {
//             setState(() {
//               filterStatus = value;
//             });
//           }),
//           _filterDropdown('Filter by Priority', filterPriority, priorityColors.keys.toList(), (value) {
//             setState(() {
//               filterPriority = value;
//             });
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _filterDropdown(String label, String currentValue, List<String> options, ValueChanged<String> onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
//         ),
//         DropdownButton<String>(
//           value: currentValue,
//           items: ['All', ...options]
//               .map((option) => DropdownMenuItem(value: option, child: Text(option)))
//               .toList(),
//           onChanged: (value) => onChanged(value!),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Image.network(
//             'https://i.pinimg.com/736x/60/05/0a/60050a7ece0ec3a65cee8d03b9622d40.jpg',
//             fit: BoxFit.cover,
//             height: 200,
//             width: double.infinity,
//           ),
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildApplicationsTable(List<Map<String, dynamic>> data) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         columnSpacing: 20,
//         columns: [
//           DataColumn(label: Text('Company')),
//           DataColumn(label: Text('Role')),
//           DataColumn(label: Text('Status')),
//           DataColumn(label: Text('Priority')),
//           DataColumn(label: Text('Source')),
//           DataColumn(label: Text('Link')),
//           DataColumn(label: Text('Deadline')),
//           DataColumn(label: Text('Materials')),
//           DataColumn(label: Text('Submitted On')),
//           DataColumn(label: Text('Network')),
//           DataColumn(label: Text('Interview Date')),
//           DataColumn(label: Text('Actions')),
//         ],
//         rows: data.map((application) {
//           return DataRow(
//             cells: [
//               _buildEditableTextCell(application, 'company'),
//               _buildEditableTextCell(application, 'role'),
//               _buildStatusCell(application, 'status'),
//               _buildPriorityCell(application, 'priority'),
//               _buildEditableTextCell(application, 'source'),
//               _buildClickableLinkCell(application, 'link'),
//               _buildEditableDateCell(application, 'deadline'),
//               _buildEditableTextCell(application, 'materials'),
//               _buildEditableDateCell(application, 'submittedOn'),
//               _buildEditableTextCell(application, 'network'),
//               _buildEditableDateCell(application, 'interviewDate'),
//               DataCell(
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () =>
//                       deleteApplication(application['_id']),
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }

//   DataCell _buildEditableTextCell(
//       Map<String, dynamic> application, String field) {
//     return DataCell(
//       editableApplicationId == application['_id'] && editableField == field
//           ? TextField(
//               autofocus: true,
//               decoration: InputDecoration(border: InputBorder.none),
//               onSubmitted: (newValue) {
//                 updateApplicationField(application['_id'], field, newValue);
//                 setState(() {
//                   editableApplicationId = null;
//                   editableField = null;
//                 });
//               },
//             )
//           : GestureDetector(
//               onTap: () {
//                 setState(() {
//                   editableApplicationId = application['_id'];
//                   editableField = field;
//                 });
//               },
//               child: Text(application[field] ?? ''),
//             ),
//     );
//   }

//   DataCell _buildEditableDateCell(
//       Map<String, dynamic> application, String field) {
//     return DataCell(
//       GestureDetector(
//         onTap: () async {
//           final pickedDate = await showDatePicker(
//             context: context,
//             initialDate:
//                 DateTime.tryParse(application[field] ?? '') ?? DateTime.now(),
//             firstDate: DateTime(2000),
//             lastDate: DateTime(2101),
//           );
//           if (pickedDate != null) {
//             updateApplicationField(
//                 application['_id'], field, pickedDate.toIso8601String());
//           }
//         },
//         child: Text(application[field]?.split('T')[0] ?? 'Select Date'),
//       ),
//     );
//   }

//   DataCell _buildClickableLinkCell(
//       Map<String, dynamic> application, String field) {
//     return DataCell(
//       GestureDetector(
//         onTap: () => _launchURL(application[field] ?? ''),
//         child: Text(
//           application[field] ?? '',
//           style: TextStyle(
//             color: Colors.blue,
//           ),
//         ),
//       ),
//     );
//   }

//   DataCell _buildStatusCell(Map<String, dynamic> application, String field) {
//     return DataCell(
//       DropdownButton<String>(
//         value: application[field],
//         items: statusColors.keys
//             .map((status) => DropdownMenuItem(
//                   value: status,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: statusColors[status]?.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: statusColors[status]!),
//                     ),
//                     child: Text(
//                       status,
//                       style: TextStyle(color: statusColors[status]),
//                     ),
//                   ),
//                 ))
//             .toList(),
//         onChanged: (newValue) {
//           if (newValue != null) {
//             updateApplicationField(application['_id'], field, newValue);
//           }
//         },
//       ),
//     );
//   }

//   DataCell _buildPriorityCell(Map<String, dynamic> application, String field) {
//     return DataCell(
//       DropdownButton<String>(
//         value: application[field],
//         items: priorityColors.keys
//             .map((priority) => DropdownMenuItem(
//                   value: priority,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: priorityColors[priority]?.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: priorityColors[priority]!),
//                     ),
//                     child: Text(
//                       priority,
//                       style: TextStyle(color: priorityColors[priority]),
//                     ),
//                   ),
//                 ))
//             .toList(),
//         onChanged: (newValue) {
//           if (newValue != null) {
//             updateApplicationField(application['_id'], field, newValue);
//           }
//         },
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';

// class InternshipApplicationsWidget extends StatefulWidget {
//   final String token;
//   final String templateId;

//   InternshipApplicationsWidget({required this.token, required this.templateId});

//   @override
//   _InternshipApplicationsWidgetState createState() =>
//       _InternshipApplicationsWidgetState();
// }

// class _InternshipApplicationsWidgetState
//     extends State<InternshipApplicationsWidget> {
//   List<Map<String, dynamic>> applications = [];
//   List<Map<String, dynamic>> offers = [];
//   String? editableApplicationId;
//   String? editableField;
//   String filterStatus = "All";
//   String filterPriority = "All";

//   final Map<String, Color> statusColors = {
//     'Not started': Colors.grey,
//     'In progress': Colors.blue,
//     'Offered': Colors.green,
//     'Rejected': Colors.red,
//   };

//   final Map<String, Color> priorityColors = {
//     'Low': Colors.green,
//     'Medium': Colors.orange,
//     'High': Colors.red,
//   };

//   @override
//   void initState() {
//     super.initState();
//     fetchApplications();
//   }

//   Future<void> fetchApplications() async {
//     final response = await http.get(
//       Uri.parse(
//           'http://$localhost/api/internship/applications/${widget.templateId}'),
//       headers: {'Authorization': 'Bearer ${widget.token}'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         if (data['applications'] != null && data['applications'] is List) {
//           applications = List<Map<String, dynamic>>.from(data['applications']);
//           _sortApplications();
//         } else {
//           applications = [];
//         }
//       });
//     } else {
//       print("Failed to fetch applications: ${response.body}");
//     }
//   }

//   void _sortApplications() {
//     applications.sort((a, b) {
//       final priorityWeight = {'High': 1, 'Medium': 2, 'Low': 3};
//       final statusWeight = {'Rejected': 2, 'Offered': 0, 'In progress': 0, 'Not started': 0};

//       int statusCompare = (statusWeight[a['status']] ?? 0)
//           .compareTo(statusWeight[b['status']] ?? 0);
//       if (statusCompare != 0) return statusCompare;

//       return (priorityWeight[a['priority']] ?? 3)
//           .compareTo(priorityWeight[b['priority']] ?? 3);
//     });

//     offers = applications.where((app) => app['status'] == 'Offered').toList();
//     applications = applications.where((app) => app['status'] != 'Offered').toList();
//   }

//   Future<void> updateApplicationField(
//       String applicationId, String field, dynamic value) async {
//     final application = applications.firstWhere((app) => app['_id'] == applicationId);

//     final updatedApplication = {
//       ...application,
//       field: value,
//     };

//     final response = await http.put(
//       Uri.parse('http://$localhost/api/internship/application'),
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//         'Content-Type': 'application/json'
//       },
//       body: json.encode({
//         'templateId': widget.templateId,
//         'applicationId': applicationId,
//         'updates': updatedApplication,
//       }),
//     );

//     if (response.statusCode == 200) {
//       fetchApplications();
//     } else {
//       print("Failed to update application: ${response.body}");
//     }
//   }

//   Future<void> deleteApplication(String applicationId) async {
//     final response = await http.delete(
//       Uri.parse('http://$localhost/api/internship/application'),
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//         'Content-Type': 'application/json'
//       },
//       body: json.encode({
//         'templateId': widget.templateId,
//         'applicationId': applicationId,
//       }),
//     );

//     if (response.statusCode == 200) {
//       fetchApplications();
//     } else {
//       print("Failed to delete application: ${response.body}");
//     }
//   }

//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   Future<void> addApplication() async {
//     final response = await http.post(
//       Uri.parse('http://$localhost/api/internship/application'),
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//         'Content-Type': 'application/json'
//       },
//       body: json.encode({
//         'templateId': widget.templateId,
//         'application': {
//           'company': 'New Company',
//           'role': 'New Role',
//           'status': 'Not started',
//           'priority': 'Low',
//           'source': '',
//           'link': '',
//           'deadline': null,
//           'materials': '',
//           'submittedOn': null,
//           'network': '',
//           'interviewDate': null,
//         },
//       }),
//     );

//     if (response.statusCode == 200) {
//       fetchApplications();
//     } else {
//       print("Failed to add application: ${response.body}");
//     }
//   }

//   List<Map<String, dynamic>> getFilteredApplications() {
//     return applications.where((app) {
//       final matchesStatus = filterStatus == "All" || app['status'] == filterStatus;
//       final matchesPriority = filterPriority == "All" || app['priority'] == filterPriority;
//       return matchesStatus && matchesPriority;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           iconTheme: IconThemeData(color: Colors.black),
//           title: Text(
//             '🖥️ Internship Applications',
//             style: GoogleFonts.montserrat(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           bottom: TabBar(
//             indicatorColor: Colors.blue,
//             labelColor: Colors.blue,
//             unselectedLabelColor: Colors.grey,
//             tabs: [
//               Tab(text: 'Applications'),
//               Tab(text: 'Offers'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: _buildFilterRow(),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: _buildApplicationsTable(getFilteredApplications()),
//                   ),
//                 ),
//               ],
//             ),
//             SingleChildScrollView(
//               child: _buildApplicationsTable(offers),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: addApplication,
//           backgroundColor: Colors.blue,
//           child: Icon(Icons.add, color: Colors.white),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _filterDropdown('Filter by Status', filterStatus, statusColors.keys.toList(), (value) {
//           setState(() {
//             filterStatus = value;
//           });
//         }),
//         _filterDropdown('Filter by Priority', filterPriority, priorityColors.keys.toList(), (value) {
//           setState(() {
//             filterPriority = value;
//           });
//         }),
//       ],
//     );
//   }

//   Widget _filterDropdown(String label, String currentValue, List<String> options, ValueChanged<String> onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         DropdownButton<String>(
//           value: currentValue,
//           items: ['All', ...options]
//               .map((option) => DropdownMenuItem(value: option, child: Text(option)))
//               .toList(),
//           onChanged: (value) => onChanged(value!),
//         ),
//       ],
//     );
//   }

//   Widget _buildApplicationsTable(List<Map<String, dynamic>> data) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         columnSpacing: 20,
//         columns: [
//           DataColumn(label: Text('Company', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Role', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Status', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Priority', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Source', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Link', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Deadline', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Materials', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Submitted On', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Network', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Interview Date', style: _tableHeaderStyle())),
//           DataColumn(label: Text('Actions', style: _tableHeaderStyle())),
//         ],
//         rows: data.map((application) {
//           return DataRow(
//             cells: [
//               _buildEditableTextCell(application, 'company'),
//               _buildEditableTextCell(application, 'role'),
//               _buildStatusCell(application, 'status'),
//               _buildPriorityCell(application, 'priority'),
//               _buildEditableTextCell(application, 'source'),
//               _buildClickableLinkCell(application, 'link'),
//               _buildEditableDateCell(application, 'deadline'),
//               _buildEditableTextCell(application, 'materials'),
//               _buildEditableDateCell(application, 'submittedOn'),
//               _buildEditableTextCell(application, 'network'),
//               _buildEditableDateCell(application, 'interviewDate'),
//               DataCell(
//                 IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => deleteApplication(application['_id']),
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }

//   TextStyle _tableHeaderStyle() {
//     return GoogleFonts.montserrat(
//       fontWeight: FontWeight.bold,
//       color: Colors.black87,
//       fontSize: 14,
//     );
//   }

//   DataCell _buildEditableTextCell(Map<String, dynamic> application, String field) {
//     return DataCell(
//       editableApplicationId == application['_id'] && editableField == field
//           ? TextField(
//               autofocus: true,
//               decoration: InputDecoration(border: InputBorder.none),
//               onSubmitted: (newValue) {
//                 updateApplicationField(application['_id'], field, newValue);
//                 setState(() {
//                   editableApplicationId = null;
//                   editableField = null;
//                 });
//               },
//             )
//           : GestureDetector(
//               onTap: () {
//                 setState(() {
//                   editableApplicationId = application['_id'];
//                   editableField = field;
//                 });
//               },
//               child: Text(application[field] ?? '', style: GoogleFonts.montserrat()),
//             ),
//     );
//   }

//   DataCell _buildEditableDateCell(Map<String, dynamic> application, String field) {
//     return DataCell(
//       GestureDetector(
//         onTap: () async {
//           final pickedDate = await showDatePicker(
//             context: context,
//             initialDate:
//                 DateTime.tryParse(application[field] ?? '') ?? DateTime.now(),
//             firstDate: DateTime(2000),
//             lastDate: DateTime(2101),
//           );
//           if (pickedDate != null) {
//             updateApplicationField(
//                 application['_id'], field, pickedDate.toIso8601String());
//           }
//         },
//         child: Text(application[field]?.split('T')[0] ?? 'Select Date', style: GoogleFonts.montserrat()),
//       ),
//     );
//   }

//   DataCell _buildClickableLinkCell(Map<String, dynamic> application, String field) {
//     return DataCell(
//       GestureDetector(
//         onTap: () => _launchURL(application[field] ?? ''),
//         child: Text(
//           application[field] ?? '',
//           style: GoogleFonts.montserrat(
//             color: Colors.blue,
//             decoration: TextDecoration.underline,
//           ),
//         ),
//       ),
//     );
//   }

//   DataCell _buildStatusCell(Map<String, dynamic> application, String field) {
//     return DataCell(
//       DropdownButton<String>(
//         value: application[field],
//         items: statusColors.keys
//             .map((status) => DropdownMenuItem(
//                   value: status,
//                   child: Text(
//                     status,
//                     style: GoogleFonts.montserrat(color: statusColors[status]),
//                   ),
//                 ))
//             .toList(),
//         onChanged: (newValue) {
//           if (newValue != null) {
//             updateApplicationField(application['_id'], field, newValue);
//           }
//         },
//       ),
//     );
//   }

//   DataCell _buildPriorityCell(Map<String, dynamic> application, String field) {
//     return DataCell(
//       DropdownButton<String>(
//         value: application[field],
//         items: priorityColors.keys
//             .map((priority) => DropdownMenuItem(
//                   value: priority,
//                   child: Text(
//                     priority,
//                     style: GoogleFonts.montserrat(color: priorityColors[priority]),
//                   ),
//                 ))
//             .toList(),
//         onChanged: (newValue) {
//           if (newValue != null) {
//             updateApplicationField(application['_id'], field, newValue);
//           }
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/DashBoard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class InternshipApplicationsWidget extends StatefulWidget {
  final String token;
  final String templateId;

  const InternshipApplicationsWidget({super.key, required this.token, required this.templateId});

  @override
  _InternshipApplicationsWidgetState createState() =>
      _InternshipApplicationsWidgetState();
}

class _InternshipApplicationsWidgetState
    extends State<InternshipApplicationsWidget> {
  List<Map<String, dynamic>> applications = [];
  List<Map<String, dynamic>> offers = [];
  String? editableApplicationId;
  String? editableField;
  String filterStatus = "All";
  String filterPriority = "All";

  final Map<String, Color> statusColors = {
    'Not started': Colors.grey,
    'In progress': Colors.blue,
    'Offered': Colors.green,
    'Rejected': Colors.red,
  };

  final Map<String, Color> priorityColors = {
    'Low': Colors.green,
    'Medium': Colors.orange,
    'High': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    final response = await http.get(
      Uri.parse(
          'http://$localhost/api/internship/applications/${widget.templateId}'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        if (data['applications'] != null && data['applications'] is List) {
          applications = List<Map<String, dynamic>>.from(data['applications']);
          _sortApplications();
        } else {
          applications = [];
        }
      });
    } else {
      print("Failed to fetch applications: ${response.body}");
    }
  }

  void _sortApplications() {
    applications.sort((a, b) {
      final priorityWeight = {'High': 1, 'Medium': 2, 'Low': 3};
      final statusWeight = {'Rejected': 2, 'Offered': 0, 'In progress': 0, 'Not started': 0};

      int statusCompare = (statusWeight[a['status']] ?? 0)
          .compareTo(statusWeight[b['status']] ?? 0);
      if (statusCompare != 0) return statusCompare;

      return (priorityWeight[a['priority']] ?? 3)
          .compareTo(priorityWeight[b['priority']] ?? 3);
    });

    offers = applications.where((app) => app['status'] == 'Offered').toList();
    applications = applications.where((app) => app['status'] != 'Offered').toList();
  }

  Future<void> updateApplicationField(
      String applicationId, String field, dynamic value) async {
    final application = applications.firstWhere((app) => app['_id'] == applicationId);

    final updatedApplication = {
      ...application,
      field: value,
    };

    final response = await http.put(
      Uri.parse('http://$localhost/api/internship/application'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'templateId': widget.templateId,
        'applicationId': applicationId,
        'updates': updatedApplication,
      }),
    );

    if (response.statusCode == 200) {
      fetchApplications();
    } else {
      print("Failed to update application: ${response.body}");
    }
  }

  Future<void> deleteApplication(String applicationId) async {
    final response = await http.delete(
      Uri.parse('http://$localhost/api/internship/application'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'templateId': widget.templateId,
        'applicationId': applicationId,
      }),
    );

    if (response.statusCode == 200) {
      fetchApplications();
    } else {
      print("Failed to delete application: ${response.body}");
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> addApplication() async {
    final response = await http.post(
      Uri.parse('http://$localhost/api/internship/application'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'templateId': widget.templateId,
        'application': {
          'company': 'New Company',
          'role': 'New Role',
          'status': 'Not started',
          'priority': 'Low',
          'source': '',
          'link': '',
          'deadline': null,
          'materials': '',
          'submittedOn': null,
          'network': '',
          'interviewDate': null,
        },
      }),
    );

    if (response.statusCode == 200) {
      fetchApplications();
    } else {
      print("Failed to add application: ${response.body}");
    }
  }

  List<Map<String, dynamic>> getFilteredApplications() {
    return applications.where((app) {
      final matchesStatus = filterStatus == "All" || app['status'] == filterStatus;
      final matchesPriority = filterPriority == "All" || app['priority'] == filterPriority;
      return matchesStatus && matchesPriority;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            '🖥️ Internship Applications',
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Applications'),
              Tab(text: 'Offers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildFilterRow(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildApplicationsTable(getFilteredApplications()),
                  ),
                ),
                _buildAddButton(context),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildApplicationsTable(offers),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: _buildFooter(context),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://i.pinimg.com/736x/60/05/0a/60050a7ece0ec3a65cee8d03b9622d40.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _filterDropdown('Filter by Status', filterStatus, statusColors.keys.toList(), (value) {
          setState(() {
            filterStatus = value;
          });
        }),
        _filterDropdown('Filter by Priority', filterPriority, priorityColors.keys.toList(), (value) {
          setState(() {
            filterPriority = value;
          });
        }),
      ],
    );
  }

  Widget _filterDropdown(String label, String currentValue, List<String> options, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: currentValue,
          items: ['All', ...options]
              .map((option) => DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: (value) => onChanged(value!),
        ),
      ],
    );
  }

  Widget _buildApplicationsTable(List<Map<String, dynamic>> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: [
          DataColumn(label: Text('Company', style: _tableHeaderStyle())),
          DataColumn(label: Text('Role', style: _tableHeaderStyle())),
          DataColumn(label: Text('Status', style: _tableHeaderStyle())),
          DataColumn(label: Text('Priority', style: _tableHeaderStyle())),
          DataColumn(label: Text('Source', style: _tableHeaderStyle())),
          DataColumn(label: Text('Link', style: _tableHeaderStyle())),
          DataColumn(label: Text('Deadline', style: _tableHeaderStyle())),
          DataColumn(label: Text('Materials', style: _tableHeaderStyle())),
          DataColumn(label: Text('Submitted On', style: _tableHeaderStyle())),
          DataColumn(label: Text('Network', style: _tableHeaderStyle())),
          DataColumn(label: Text('Interview Date', style: _tableHeaderStyle())),
          DataColumn(label: Text('Actions', style: _tableHeaderStyle())),
        ],
        rows: data.map((application) {
          return DataRow(
            cells: [
              _buildEditableTextCell(application, 'company'),
              _buildEditableTextCell(application, 'role'),
              _buildStatusCell(application, 'status'),
              _buildPriorityCell(application, 'priority'),
              _buildEditableTextCell(application, 'source'),
              _buildClickableLinkCell(application, 'link'),
              _buildEditableDateCell(application, 'deadline'),
              _buildEditableTextCell(application, 'materials'),
              _buildEditableDateCell(application, 'submittedOn'),
              _buildEditableTextCell(application, 'network'),
              _buildEditableDateCell(application, 'interviewDate'),
              DataCell(
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteApplication(application['_id']),
                ),
              ),
            ],
          );
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

  DataCell _buildEditableTextCell(Map<String, dynamic> application, String field) {
    return DataCell(
      editableApplicationId == application['_id'] && editableField == field
          ? TextField(
              autofocus: true,
              decoration: InputDecoration(border: InputBorder.none),
              onSubmitted: (newValue) {
                updateApplicationField(application['_id'], field, newValue);
                setState(() {
                  editableApplicationId = null;
                  editableField = null;
                });
              },
            )
          : GestureDetector(
              onTap: () {
                setState(() {
                  editableApplicationId = application['_id'];
                  editableField = field;
                });
              },
              child: Text(application[field] ?? '', style: GoogleFonts.montserrat()),
            ),
    );
  }

  DataCell _buildEditableDateCell(Map<String, dynamic> application, String field) {
    return DataCell(
      GestureDetector(
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate:
                DateTime.tryParse(application[field] ?? '') ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            updateApplicationField(
                application['_id'], field, pickedDate.toIso8601String());
          }
        },
        child: Text(application[field]?.split('T')[0] ?? 'Select Date', style: GoogleFonts.montserrat()),
      ),
    );
  }

  DataCell _buildClickableLinkCell(Map<String, dynamic> application, String field) {
    return DataCell(
      GestureDetector(
        onTap: () => _launchURL(application[field] ?? ''),
        child: Text(
          application[field] ?? '',
          style: GoogleFonts.montserrat(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  DataCell _buildStatusCell(Map<String, dynamic> application, String field) {
    return DataCell(
      DropdownButton<String>(
        value: application[field],
        items: statusColors.keys
            .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(
                    status,
                    style: GoogleFonts.montserrat(color: statusColors[status]),
                  ),
                ))
            .toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            updateApplicationField(application['_id'], field, newValue);
          }
        },
      ),
    );
  }

  DataCell _buildPriorityCell(Map<String, dynamic> application, String field) {
    return DataCell(
      DropdownButton<String>(
        value: application[field],
        items: priorityColors.keys
            .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(
                    priority,
                    style: GoogleFonts.montserrat(color: priorityColors[priority]),
                  ),
                ))
            .toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            updateApplicationField(application['_id'], field, newValue);
          }
        },
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: InkWell(
        onTap: addApplication,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.grey, size: 24),
              SizedBox(width: 8),
              Text('Add Application', style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
Widget _buildFooter(BuildContext context) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()), // Replace `DashboardPage` with your actual dashboard widget
                (route) => false,
              );
            },
            child: Icon(Icons.home, color: Colors.grey, size: 28),
          ),
          Icon(Icons.search, color: Colors.grey, size: 28),
          Icon(Icons.folder, color: Colors.grey, size: 28),
          Icon(Icons.edit, color: Colors.grey, size: 28),
        ],
      ),
    ),
  );
}
    }
