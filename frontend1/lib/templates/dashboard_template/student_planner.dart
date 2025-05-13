// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:frontend1/config.dart';
// // import 'package:frontend1/templates/dashboard_template/Calender.dart';
// // import 'package:frontend1/templates/dashboard_template/mood_tracker.dart';
// // import 'package:frontend1/templates/dashboard_template/to_do_table.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// // import 'package:http/http.dart' as http;

// // class StudentPlanner extends StatefulWidget {
// //   final String token;
// //   final String templateId;

// //   StudentPlanner({required this.token, required this.templateId});

// //   @override
// //   _StudentPlannerState createState() => _StudentPlannerState();
// // }

// // class _StudentPlannerState extends State<StudentPlanner> {
// //   late final WebViewController controller;

// //   final String baseUrl = "http://$localhost/api";
// //     List<Map<String, dynamic>> classes = [
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchTemplateData();
// //   }

// //   Future<void> _fetchTemplateData() async {
// //     // Fetch the student planner template from the backend
// //     final url = Uri.parse('$baseUrl/studentPlanner2/${widget.templateId}');
// //     final response = await http.get(
// //       url,
// //       headers: {
// //         'Authorization': 'Bearer ${widget.token}',
// //       },
// //     );

// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);

// //       // Data structure assumed from previous backend example:
// //       // {
// //       //   "userId": "...",
// //       //   "classes": [ { "name": "...", "color": "#DAD5C5", "icon": "calculate" }, ... ],
// //       //   "tasks": [...],
// //       //   "moodTracker": [...],
// //       //   "events": [...]
// //       // }
// //       // Convert color hex and icon strings to actual Flutter values.

// //       List<dynamic> fetchedClasses = data['classes'] ?? [];
// //       setState(() {
// //         classes = fetchedClasses.map<Map<String, dynamic>>((c) {
// //           return {
// //             'name': c['name'],
// //             'color': _colorFromHex(c['color'] ?? '#DAD5C5'),
// //             'icon': _iconFromString(c['icon'] ?? 'calculate'),
// //           };
// //         }).toList();
// //       });
// //     } else {
// //       print('Failed to fetch template data: ${response.statusCode}');
// //     }
// //   }

// //   Color _colorFromHex(String hexColor) {
// //     hexColor = hexColor.replaceAll('#', '');
// //     if (hexColor.length == 6) {
// //       hexColor = 'FF' + hexColor; // add alpha value if not present
// //     }
// //     return Color(int.parse(hexColor, radix: 16));
// //   }

// //   IconData _iconFromString(String iconName) {
// //     // Map backend icon strings to Flutter icons
// //     switch (iconName) {
// //       case 'calculate':
// //         return Icons.calculate;
// //       case 'eco':
// //         return Icons.eco;
// //       case 'book':
// //         return Icons.book;
// //       case 'science':
// //         return Icons.science;
// //       case 'history':
// //         return Icons.history;
// //       case 'biotech':
// //         return Icons.biotech;
// //       case 'edit':
// //         return Icons.edit;
// //       case 'school':
// //         return Icons.school;
// //       default:
// //         return Icons.school; // default icon
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         title: Row(
// //           children: [
// //             const CircleAvatar(
// //               backgroundColor: Colors.white,
// //               radius: 16,
// //               child: Icon(Icons.local_florist, color: Colors.green),
// //             ),
// //             const SizedBox(width: 8),
// //             Text(
// //               'Student Planner',
// //               style: GoogleFonts.notoSans(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ],
// //         ),
// //         actions: const [
// //           Icon(Icons.share, color: Colors.black),
// //           SizedBox(width: 16),
// //           Icon(Icons.comment, color: Colors.black),
// //           SizedBox(width: 16),
// //         ],
// //       ),
// //       body: ListView(
// //         padding: const EdgeInsets.all(16.0),
// //         children: [
// //           ClipRRect(
// //             borderRadius: BorderRadius.circular(12),
// //             child: Image.network(
// //               'https://i.pinimg.com/originals/c0/4d/08/c04d08a2308024e7574cb400cd8a89d1.gif',
// //               fit: BoxFit.cover,
// //               height: 200,
// //               width: double.infinity,
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Divider(color: Colors.grey[300], thickness: 1),
// //           Text(
// //             'Pomodoro Timer:',
// //             style: GoogleFonts.notoSans(
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           Container(
// //             height: 350,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(12),
// //               color: Colors.black12,
// //             ),
// //             child: ClipRRect(
// //               borderRadius: BorderRadius.circular(12),
// //               child: SingleChildScrollView(
// //                 child: SizedBox(
// //                   height: 500,
// //                   child: ReusableWebView(
// //                     url: 'https://studywithme.io/aesthetic-pomodoro-timer/',
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               ClipRRect(
// //                 borderRadius: BorderRadius.circular(12),
// //                 child: Image.network(
// //                   'https://i.pinimg.com/736x/22/8b/4b/228b4bc3789beb3396ee7f26d3c2d66b.jpg',
// //                   fit: BoxFit.cover,
// //                   height: 180,
// //                   width: 180,
// //                 ),
// //               ),
// //               const SizedBox(width: 16),
// //               Expanded(
// //                 child: Text(
// //                   '“Failure is only the opportunity to begin again.” - Uncle Iroh',
// //                   style: GoogleFonts.handlee(
// //                     fontSize: 28,
// //                     color: Colors.black87,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 16),
// //           Divider(color: Colors.grey[300], thickness: 1),
// //           Text(
// //             'Classes',
// //             style: GoogleFonts.notoSans(
// //               fontSize: 24,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           // Using Stack to position the button within the class section
// //           Stack(
// //             children: [
// //               GridView.count(
// //                 crossAxisCount: 3,
// //                 shrinkWrap: true,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 crossAxisSpacing: 12,
// //                 mainAxisSpacing: 12,
// //                 children: classes.map((classInfo) {
// //                   return buildClassCard(
// //                     classInfo['name'],
// //                     classInfo['color'],
// //                     classInfo['icon'],
// //                   );
// //                 }).toList(),
// //               ),
// //               Positioned(
// //                 bottom: 8,
// //                 right: 8,
// //                 child: FloatingActionButton(
// //                   onPressed: () => _addNewClass(context),
// //                   mini: true,
// //                   child: const Icon(Icons.add, color: Colors.white),
// //                   backgroundColor: Colors.blue[300],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           Divider(color: Colors.grey[300], thickness: 1),
// //           // The TodoPlannerPage, MoodTracker, and CalendarWidget remain visually the same.
// //           // In a full integration, you'd fetch tasks, moodTracker, and events from the backend similarly.
// //           // For now, they remain as is, but you can integrate similarly by passing in data or updating them.
// //           ClipRRect(
// //             borderRadius: BorderRadius.circular(12),
// //             child: Image.network(
// //               'https://i.pinimg.com/enabled/564x/af/20/f8/af20f82c957ab15ec4bf8df3ac2b138b.jpg',
// //               fit: BoxFit.cover,
// //               height: 180,
// //               width: double.infinity,
// //             ),
// //           ),
// //           Divider(color: Colors.grey[300], thickness: 1),
// //          MoodTracker(
// //   baseUrl: '${baseUrl}',
// //   token: '${widget.token}',
// //   templateId: '${widget.templateId}',
// // ),

// //           Divider(color: Colors.grey[300], thickness: 1),
// //           const SizedBox(width: 16),
// //           Expanded(
// //             child: Text(
// //               '“When we hit our lowest point, we are open to the greatest change.” - Aang',
// //               style: GoogleFonts.handlee(
// //                 fontSize: 28,
// //                 color: Colors.black87,
// //               ),
// //             ),
// //           ),
// //           ClipRRect(
// //             borderRadius: BorderRadius.circular(12),
// //             child: Image.network(
// //               'https://i.pinimg.com/736x/08/3a/5d/083a5db6ca33836e0e70576917703a54.jpg',
// //               fit: BoxFit.cover,
// //               height: 180,
// //               width: double.infinity,
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Divider(color: Colors.grey[300], thickness: 1),
// //           Text(
// //             'Upcoming Dates',
// //             style: GoogleFonts.notoSans(
// //               fontSize: 24,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           CalendarWidget(  baseUrl: '${baseUrl}',
// //   token: '${widget.token}',
// //   templateId: '${widget.templateId}',), // To integrate: fetch events and call backend on changes
// //           const SizedBox(height: 12),
// //           Container(
// //             height: 200,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(12),
// //               color: Colors.black12,
// //             ),
// //             child: ClipRRect(
// //               borderRadius: BorderRadius.circular(12),
// //               child: SingleChildScrollView(
// //                 child: SizedBox(
// //                   height: 500,
// //                   child: ReusableWebView(
// //                     url: "https://open.spotify.com/embed/playlist/37i9dQZF1DX8Uebhn9wzrS?utm_source=generator",
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget buildClassCard(String title, Color color, IconData icon) {
// //     return GestureDetector(
// //       onTap: () {
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => ClassPage(title: title),
// //           ),
// //         );
// //       },
// //       child: Container(
// //         height: 80,
// //         decoration: BoxDecoration(
// //           color: color,
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           children: [
// //             Icon(icon, size: 40, color: Colors.white),
// //             const SizedBox(height: 8),
// //             Text(
// //               title,
// //               style: GoogleFonts.notoSans(
// //                 fontSize: 16,
// //                 color: Colors.white,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _addNewClass(BuildContext context) {
// //     String className = '';
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: const Text('Add New Class'),
// //           content: TextField(
// //             onChanged: (value) => className = value,
// //             decoration: const InputDecoration(hintText: 'Enter class name'),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () async {
// //                 if (className.isNotEmpty) {
// //                   // Call backend to add new class
// //                   final addClassUrl = Uri.parse('$baseUrl/studentPlanner2/addClass');
// //                   final response = await http.put(
// //                     addClassUrl,
// //                     headers: {
// //                       'Authorization': 'Bearer ${widget.token}',
// //                       'Content-Type': 'application/json',
// //                     },
// //                     body: jsonEncode({
// //                       'templateId': '${widget.templateId}',
// //                       'classData': {
// //                         'name': className,
// //                         'color': '#CCCCCC',  // default color
// //                         'icon': 'school',    // default icon
// //                       }
// //                     }),
// //                   );

// //                   if (response.statusCode == 200) {
// //                     // Successfully added class, now refetch data
// //                     await _fetchTemplateData();
// //                     Navigator.pop(context);
// //                   } else {
// //                     print('Failed to add class: ${response.statusCode}');
// //                   }
// //                 }
// //               },
// //               child: const Text('Add'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }

// // class ClassPage extends StatelessWidget {
// //   final String title;

// //   const ClassPage({required this.title});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           title,
// //           style: GoogleFonts.notoSans(fontSize: 20),
// //         ),
// //       ),
// //       body: Center(
// //         child: Text(
// //           'Welcome to $title!',
// //           style: GoogleFonts.notoSans(fontSize: 24),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ReusableWebView extends StatelessWidget {
// //   final String url;

// //   ReusableWebView({required this.url});

// //   @override
// //   Widget build(BuildContext context) {
// //     final WebViewController controller = WebViewController()
// //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
// //       ..loadRequest(Uri.parse(url));

// //     return WebViewWidget(controller: controller);
// //   }
// // }


// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:frontend1/templates/dashboard_template/Calender.dart';
// import 'package:frontend1/templates/dashboard_template/mood_tracker.dart';
// import 'package:frontend1/templates/dashboard_template/to_do_table.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:http/http.dart' as http;

// class StudentPlanner extends StatefulWidget {
//   final String token;
//   final String templateId;

//   StudentPlanner({required this.token, required this.templateId});

//   @override
//   _StudentPlannerState createState() => _StudentPlannerState();
// }

// class _StudentPlannerState extends State<StudentPlanner> {
//   final String baseUrl = "http://$localhost/api";
//   List<Map<String, dynamic>> classes = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchTemplateData();
//   }

//   Future<void> _fetchTemplateData() async {
//     final url = Uri.parse('$baseUrl/studentPlanner2/${widget.templateId}');
//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       List<dynamic> fetchedClasses = data['classes'] ?? [];
//       setState(() {
//         classes = fetchedClasses.map<Map<String, dynamic>>((c) {
//           return {
//             'name': c['name'],
//             'color': _colorFromHex(c['color'] ?? '#DAD5C5'),
//             'icon': _iconFromString(c['icon'] ?? 'calculate'),
//           };
//         }).toList();
//       });
//     } else {
//       print('Failed to fetch template data: ${response.statusCode}');
//     }
//   }

//   Color _colorFromHex(String hexColor) {
//     hexColor = hexColor.replaceAll('#', '');
//     if (hexColor.length == 6) {
//       hexColor = 'FF' + hexColor; 
//     }
//     return Color(int.parse(hexColor, radix: 16));
//   }

//   IconData _iconFromString(String iconName) {
//     switch (iconName) {
//       case 'calculate':
//         return Icons.calculate;
//       case 'eco':
//         return Icons.eco;
//       case 'book':
//         return Icons.book;
//       case 'science':
//         return Icons.science;
//       case 'history':
//         return Icons.history;
//       case 'biotech':
//         return Icons.biotech;
//       case 'edit':
//         return Icons.edit;
//       case 'school':
//         return Icons.school;
//       default:
//         return Icons.school;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             const SizedBox(width: 8),
//             Text(
//               'Student Planner',
//               style: GoogleFonts.montserrat(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         actions: const [
//           Icon(Icons.share, color: Colors.black),
//           SizedBox(width: 16),
//           Icon(Icons.comment, color: Colors.black),
//           SizedBox(width: 16),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           // Header Image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               'https://i.pinimg.com/originals/c0/4d/08/c04d08a2308024e7574cb400cd8a89d1.gif',
//               fit: BoxFit.cover,
//               height: 200,
//               width: double.infinity,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Divider(color: Colors.grey[300], thickness: 1),
//           Text(
//             'Pomodoro Timer:',
//             style: GoogleFonts.montserrat(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Container(
//             height: 350,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.grey[200],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: SingleChildScrollView(
//                 child: SizedBox(
//                   height: 500,
//                   child: ReusableWebView(
//                     url: 'https://studywithme.io/aesthetic-pomodoro-timer/',
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   'https://i.pinimg.com/736x/22/8b/4b/228b4bc3789beb3396ee7f26d3c2d66b.jpg',
//                   fit: BoxFit.cover,
//                   height: 180,
//                   width: 180,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Text(
//                   '“Failure is only the opportunity to begin again.” - Uncle Iroh',
//                   style: GoogleFonts.handlee(
//                     fontSize: 28,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Divider(color: Colors.grey[300], thickness: 1),
//           Text(
//             'Classes',
//             style: GoogleFonts.montserrat(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Stack(
//             children: [
//               GridView.count(
//                 crossAxisCount: 3,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 children: classes.map((classInfo) {
//                   return buildClassCard(
//                     classInfo['name'],
//                     classInfo['color'],
//                     classInfo['icon'],
//                   );
//                 }).toList(),
//               ),
//               Positioned(
//                 bottom: 8,
//                 right: 8,
//                 child: FloatingActionButton(
//                   onPressed: () => _addNewClass(context),
//                   mini: true,
//                   backgroundColor: Colors.blue[300],
//                   child: const Icon(Icons.add, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           Divider(color: Colors.grey[300], thickness: 1),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               'https://i.pinimg.com/enabled/564x/af/20/f8/af20f82c957ab15ec4bf8df3ac2b138b.jpg',
//               fit: BoxFit.cover,
//               height: 180,
//               width: double.infinity,
//             ),
//           ),
//           Divider(color: Colors.grey[300], thickness: 1),
//           MoodTracker(
//             baseUrl: '$baseUrl',
//             token: widget.token,
//             templateId: widget.templateId,
//           ),
//           Divider(color: Colors.grey[300], thickness: 1),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               '“When we hit our lowest point, we are open to the greatest change.” - Aang',
//               style: GoogleFonts.handlee(
//                 fontSize: 28,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               'https://i.pinimg.com/736x/08/3a/5d/083a5db6ca33836e0e70576917703a54.jpg',
//               fit: BoxFit.cover,
//               height: 180,
//               width: double.infinity,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Divider(color: Colors.grey[300], thickness: 1),
          
//           TodoPlannerPage(
//             baseUrl: '$baseUrl',
//             token: widget.token,
//             templateId: widget.templateId,
//           ),
//           CalendarWidget(
//             baseUrl: '$baseUrl',
//             token: widget.token,
//             templateId: widget.templateId,
//           ),
//           const SizedBox(height: 12),
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.grey[200],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: SingleChildScrollView(
//                 child: SizedBox(
//                   height: 500,
//                   child: ReusableWebView(
//                     url: "https://open.spotify.com/embed/playlist/37i9dQZF1DX8Uebhn9wzrS?utm_source=generator",
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _footer(),
//     );
//   }

//   Widget buildClassCard(String title, Color color, IconData icon) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ClassPage(title: title),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Icon(icon, size: 40, color: Colors.white),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: GoogleFonts.montserrat(
//                 fontSize: 16,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }

//   void _addNewClass(BuildContext context) {
//     String className = '';
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             'Add New Class',
//             style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//           ),
//           content: TextField(
//             onChanged: (value) => className = value,
//             decoration: const InputDecoration(hintText: 'Enter class name'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 if (className.isNotEmpty) {
//                   final addClassUrl = Uri.parse('$baseUrl/studentPlanner2/addClass');
//                   final response = await http.put(
//                     addClassUrl,
//                     headers: {
//                       'Authorization': 'Bearer ${widget.token}',
//                       'Content-Type': 'application/json',
//                     },
//                     body: jsonEncode({
//                       'templateId': '${widget.templateId}',
//                       'classData': {
//                         'name': className,
//                         'color': '#CCCCCC',
//                         'icon': 'school',
//                       }
//                     }),
//                   );

//                   if (response.statusCode == 200) {
//                     await _fetchTemplateData();
//                     Navigator.pop(context);
//                   } else {
//                     print('Failed to add class: ${response.statusCode}');
//                   }
//                 }
//               },
//               child: Text(
//                 'Add',
//                 style: GoogleFonts.montserrat(color: Colors.blueAccent),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _footer() {
//     return Container(
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Icon(Icons.home, color: Colors.grey, size: 28),
//             Icon(Icons.search, color: Colors.grey, size: 28),
//             Icon(Icons.folder, color: Colors.grey, size: 28),
//             Icon(Icons.edit, color: Colors.grey, size: 28),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ClassPage extends StatelessWidget {
//   final String title;

//   const ClassPage({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           title,
//           style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
//         ),
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to $title!',
//           style: GoogleFonts.montserrat(fontSize: 24, color: Colors.black87),
//         ),
//       ),
//     );
//   }
// }

// class ReusableWebView extends StatelessWidget {
//   final String url;

//   ReusableWebView({required this.url});

//   @override
//   Widget build(BuildContext context) {
//     final WebViewController controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse(url));

//     return WebViewWidget(controller: controller);
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/dashboard_template/Calender.dart';
import 'package:frontend1/templates/dashboard_template/mood_tracker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class StudentPlanner extends StatefulWidget {
  final String token;
  final String templateId;

  const StudentPlanner({super.key, required this.token, required this.templateId});

  @override
  _StudentPlannerState createState() => _StudentPlannerState();
}

class _StudentPlannerState extends State<StudentPlanner> {
  final String baseUrl = "http://$localhost/api"; // Corrected baseUrl
  List<Map<String, dynamic>> classes = [];

  @override
  void initState() {
    super.initState();
    _fetchTemplateData();
  }

  Future<void> _fetchTemplateData() async {
    final url = Uri.parse('$baseUrl/studentPlanner2/${widget.templateId}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> fetchedClasses = data['classes'] ?? [];
      setState(() {
        classes = fetchedClasses.map<Map<String, dynamic>>((c) {
          return {
            'name': c['name'],
            'color': _colorFromHex(c['color'] ?? '#DAD5C5'),
            'icon': _iconFromString(c['icon'] ?? 'calculate'),
          };
        }).toList();
      });
    } else {
      print('Failed to fetch template data: ${response.statusCode}');
      // Optionally, show a SnackBar or other user feedback
    }
  }

  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add alpha if missing
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'calculate':
        return Icons.calculate;
      case 'eco':
        return Icons.eco;
      case 'book':
        return Icons.book;
      case 'science':
        return Icons.science;
      case 'history':
        return Icons.history;
      case 'biotech':
        return Icons.biotech;
      case 'edit':
        return Icons.edit;
      case 'school':
        return Icons.school;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              'Student Planner',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.share, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.comment, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://i.pinimg.com/originals/c0/4d/08/c04d08a2308024e7574cb400cd8a89d1.gif',
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[300], thickness: 1),
          Text(
            'Pomodoro Timer:',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ReusableWebView(
                url: 'https://studywithme.io/aesthetic-pomodoro-timer/',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://i.pinimg.com/736x/22/8b/4b/228b4bc3789beb3396ee7f26d3c2d66b.jpg',
                  fit: BoxFit.cover,
                  height: 180,
                  width: 180,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '“Failure is only the opportunity to begin again.” - Uncle Iroh',
                  style: GoogleFonts.handlee(
                    fontSize: 28,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[300], thickness: 1),
          Text(
            'Classes',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: classes.map((classInfo) {
                  return buildClassCard(
                    classInfo['name'],
                    classInfo['color'],
                    classInfo['icon'],
                  );
                }).toList(),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: FloatingActionButton(
                  onPressed: () => _addNewClass(context),
                  mini: true,
                  backgroundColor: Colors.blue[300],
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey[300], thickness: 1),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://i.pinimg.com/enabled/564x/af/20/f8/af20f82c957ab15ec4bf8df3ac2b138b.jpg',
              fit: BoxFit.cover,
              height: 180,
              width: double.infinity,
            ),
          ),
          Divider(color: Colors.grey[300], thickness: 1),
          MoodTracker(
            baseUrl: baseUrl,
            token: widget.token,
            templateId: widget.templateId,
          ),
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 16),
          Text(
            '“When we hit our lowest point, we are open to the greatest change.” - Aang',
            style: GoogleFonts.handlee(
              fontSize: 28,
              color: Colors.black87,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://i.pinimg.com/736x/08/3a/5d/083a5db6ca33836e0e70576917703a54.jpg',
              fit: BoxFit.cover,
              height: 180,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[300], thickness: 1),

          // // TodoPlannerPage without Scaffold
          // TodoPlannerPage(
          //   baseUrl: baseUrl,
          //   token: widget.token,
          //   templateId: widget.templateId,
          // ),

          Divider(color: Colors.grey[300], thickness: 1),

          // CalendarWidget without Scaffold
          CalendarWidget(
            baseUrl: baseUrl,
            token: widget.token,
            templateId: widget.templateId,
          ),

          const SizedBox(height: 12),

          // Spotify WebView
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ReusableWebView(
                url: "https://open.spotify.com/embed/playlist/37i9dQZF1DX8Uebhn9wzrS?utm_source=generator",
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _footer(),
    );
  }

  Widget buildClassCard(String title, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassPage(title: title),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _addNewClass(BuildContext context) {
    String className = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add New Class',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            onChanged: (value) => className = value,
            decoration: const InputDecoration(hintText: 'Enter class name'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (className.isNotEmpty) {
                  final addClassUrl = Uri.parse('$baseUrl/studentPlanner2/addClass');
                  final response = await http.put(
                    addClassUrl,
                    headers: {
                      'Authorization': 'Bearer ${widget.token}',
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({
                      'templateId': widget.templateId,
                      'classData': {
                        'name': className,
                        'color': '#DAD5C5',
                        'icon': 'school',
                      }
                    }),
                  );

                  if (response.statusCode == 200) {
                    await _fetchTemplateData();
                    Navigator.pop(context);
                  } else {
                    print('Failed to add class: ${response.statusCode}');
                    // Optionally, show a SnackBar or other user feedback
                  }
                }
              },
              child: Text(
                'Add',
                style: GoogleFonts.montserrat(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _footer() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: Colors.grey, size: 28),
            Icon(Icons.search, color: Colors.grey, size: 28),
            Icon(Icons.folder, color: Colors.grey, size: 28),
            Icon(Icons.edit, color: Colors.grey, size: 28),
          ],
        ),
      ),
    );
  }
}

class ClassPage extends StatelessWidget {
  final String title;

  const ClassPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.grey[50],
  
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text(
          'Welcome to $title!',
          style: GoogleFonts.montserrat(fontSize: 24, color: Colors.black87),
        ),
      ),
    );
  }
}

class ReusableWebView extends StatelessWidget {
  final String url;

  const ReusableWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    // Ensure WebView is properly initialized for Android and iOS
    // For Android, ensure WebView platform views are enabled
    // For iOS, ensure proper configuration in Info.plist
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return WebViewWidget(controller: controller);
  }
}
