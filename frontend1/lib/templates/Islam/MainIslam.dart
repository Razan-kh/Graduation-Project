// // import 'package:flutter/material.dart';
// // import 'package:frontend1/pages/Template.dart';
// // import 'package:frontend1/pages/DashBoard.dart';
// // import 'package:frontend1/templates/Islam/PrayerTimes.dart';
// // import 'package:frontend1/templates/Islam/Tasbih.dart';
// // import 'package:frontend1/templates/Islam/routine1.dart' as Routine;
// // import 'package:frontend1/templates/Islam/ReadingTrack.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class IslamicAppHomePage extends StatefulWidget {
// //   final String templateId;
// //   final String token;

// //   const IslamicAppHomePage({
// //     Key? key,
// //     required this.token,
// //     required this.templateId,
// //   }) : super(key: key);

// //   @override
// //   IslamicAppHomePageState createState() => IslamicAppHomePageState();
// // }

// // class IslamicAppHomePageState extends State<IslamicAppHomePage> {
// //   int completedPrayers = 0;
// //   int totalTasks = 1;
// //   int completedTasks = 0;
// //   Template? template;
// //   String? arrayID;
// //   String? routineID;
// //   List<dynamic> prayers = [];

// //   // Define color constants as instance variables
// //   final Color primaryColor = Color(0xFF0000FF); // Blue
// //   final Color secondaryColor = Color(0xFFFF4081); // Red Accent
// //   final Color cardBackgroundColor = Colors.white; // White
// //   final Color shadowColor = Color(0xFFBDBDBD); // Grey
// //   final Color scaffoldBackgroundColor = Color(0xFFF5F5F5); // Light Grey
// //   final Color dividerBackgroundColor = Color(0xFFBDBDBD); // Grey
// //   final Color primaryTextColor = Colors.black; // Black
// //   final Color secondaryTextColor = Color(0xFF424242); // Dark Grey
// //   final Color snackBarBackgroundColor = Color(0x80000000); // Semi-Transparent Black
// //   final Color buttonTextColor = Colors.white; // White
// //   final Color buttonBackgroundColor = Color(0xFF0000FF); // Blue

// //   // Define a custom TextTheme using Montserrat
// //   late TextTheme montserratTextTheme;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchData();
// //     // Initialize the TextTheme
// //     montserratTextTheme = GoogleFonts.montserratTextTheme();
// //   }

// //   Future<void> _fetchData() async {
// //     await fetchTemplate();
// //     await fetchTodayRoutine();
// //   }

// //   Future<void> fetchTodayRoutine() async {
// //     final routineService = Routine.RoutineService();
// //     if (arrayID == null) {
// //       // Handle null case if needed
// //       return;
// //     }

// //     final result = await routineService.retrieveTodayRoutine(arrayID!);

// //     setState(() {
// //       if (result['success']) {
// //         final routineData = result['routine'];

// //         prayers = routineData['prayers'];
// //         prayers = prayers.map((item) => Prayer.fromJson(item)).toList();
// //         routineID = routineData['_id'];
// //         print(result['message']);
// //         completedTasks = routineData['tasks']
// //             .where((task) => task['isCompleted'] == true)
// //             .length;
// //         totalTasks = routineData['tasks'].length;

// //         completedPrayers = routineData['prayers']
// //             .where((prayer) => prayer['isCompleted'] == true)
// //             .length;

// //         print(
// //             "CompletedTasks is $completedTasks  CompletedPrayers is $completedPrayers   total tasks$totalTasks");
// //       } else {
// //         // Handle failure case if needed
// //       }
// //     });
// //   }

// //   Future<void> fetchTemplate() async {
// //     template =
// //         await Template.fetchTemplateData(widget.templateId, widget.token);
// //     setState(() {
// //       arrayID = template?.data;
// //       print("Array id is $arrayID");
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // Update the TextTheme with Montserrat
// //     montserratTextTheme = GoogleFonts.montserratTextTheme(
// //       Theme.of(context).textTheme,
// //     ).copyWith(
// //       headlineSmall: GoogleFonts.montserrat(
// //         fontSize: 18,
// //         fontWeight: FontWeight.w500,
// //         color: primaryTextColor,
// //       ),
// //       titleMedium: GoogleFonts.montserrat(
// //         fontSize: 16,
// //         fontWeight: FontWeight.w600,
// //         color: primaryTextColor,
// //       ),
// //       bodyMedium: GoogleFonts.montserrat(
// //         fontSize: 14,
// //         color: primaryTextColor,
// //       ),
// //       headlineMedium: GoogleFonts.montserrat(
// //         fontSize: 28,
// //         fontWeight: FontWeight.bold,
// //         color: primaryTextColor,
// //       ),
// //       // Add more text styles as needed
// //     );

// //     return Theme(
// //       data: ThemeData(
// //         // Apply the custom TextTheme
// //         textTheme: montserratTextTheme,
// //         primaryColor: primaryColor,
// //         // Define AppBarTheme for consistent styling
// //         appBarTheme: AppBarTheme(
// //           backgroundColor: cardBackgroundColor, // White AppBar background
// //           iconTheme: IconThemeData(color: primaryColor), // Blue icons
// //           titleTextStyle: montserratTextTheme.headlineSmall,
// //           elevation: 0,
// //         ),
// //         // Define ElevatedButtonTheme for consistent button styling
// //         elevatedButtonTheme: ElevatedButtonThemeData(
// //           style: ElevatedButton.styleFrom(
// //             foregroundColor: buttonTextColor, backgroundColor: buttonBackgroundColor, // Button text color (White)
// //             textStyle: GoogleFonts.montserrat(
// //               fontSize: 14,
// //               fontWeight: FontWeight.w500,
// //             ),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //           ),
// //         ),
// //       ),
// //       child: Scaffold(
// //         appBar: AppBar(
// //           leading: IconButton(
// //             icon: Icon(Icons.arrow_back),
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => DashboardPage()),
// //               ); // Back button functionality
// //             },
// //           ),
// //           title: Text(
// //             'Praying Tracker',
// //             style: montserratTextTheme.headlineSmall,
// //           ),
// //         ),
// //         backgroundColor: scaffoldBackgroundColor, // Light Grey background
// //         body: SafeArea(
// //           child: SingleChildScrollView(
// //             child: Column(
// //               children: [
// //                 // Mosque Image
// //                 Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(12),
// //                     child: Image.network(
// //                       'https://i.pinimg.com/736x/eb/a1/03/eba10303b256fd02444f23e871fc992f.jpg',
// //                       height: 200,
// //                       width: double.infinity,
// //                       fit: BoxFit.cover,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 30),
// //                 // Prayer Information Section (Optional)
// //                 // _buildPrayerInfoSection(),
// //                 // Daily Goals Section
// //                 _buildDailyGoalsSection(),
// //                 SizedBox(height: 20),
// //                 // Quick Actions Section
// //                 _buildQuickActionsSection(),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // Prayer Information Section (Optional)
// //   Widget _buildPrayerInfoSection() {
// //     return Container(
// //       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: primaryColor, // Blue background
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: shadowColor, // Grey shadow
// //             spreadRadius: 2,
// //             blurRadius: 4,
// //             offset: Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           Text(
// //             'Duhr',
// //             style: montserratTextTheme.titleMedium?.copyWith(
// //                   color: cardBackgroundColor, // White text
// //                 ),
// //           ),
// //           SizedBox(height: 4),
// //           Text(
// //             'Next prayer is Duhr',
// //             style: montserratTextTheme.bodyMedium?.copyWith(
// //                   color: cardBackgroundColor.withOpacity(0.7), // White70
// //                 ),
// //           ),
// //           SizedBox(height: 8),
// //           Text(
// //             '11:55 AM',
// //             style: montserratTextTheme.headlineMedium?.copyWith(
// //                   color: cardBackgroundColor, // White text
// //                 ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Daily Goals Section
// //   Widget _buildDailyGoalsSection() {
// //     return Container(
// //       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: cardBackgroundColor, // White background
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: shadowColor.withOpacity(0.5), // Grey shadow
// //             spreadRadius: 3,
// //             blurRadius: 6,
// //             offset: Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'Daily Goals',
// //             style: montserratTextTheme.headlineSmall?.copyWith(
// //                   color: primaryTextColor,
// //                 ),
// //           ),
// //           SizedBox(height: 20),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceAround,
// //             children: [
// //               // Total Completion Progress Indicator
// //               _buildProgressIndicator(
// //                 label: 'Total Completion',
// //                 progress: (completedPrayers + completedTasks) / (totalTasks + 5),
// //               ),
// //               // Progress Texts
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _buildProgressText(
// //                     label: 'Praying',
// //                     progress: completedPrayers / 5,
// //                   ),
// //                   if (arrayID != null)
// //                     _buildProgressText(
// //                       label: 'Daily Tasks',
// //                       progress: totalTasks != 0 ? completedTasks / totalTasks : 0,
// //                     ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Circular Progress Indicator Widget
// //   Widget _buildProgressIndicator({
// //     required String label,
// //     required double progress,
// //   }) {
// //     return Column(
// //       children: [
// //         SizedBox(
// //           width: 80,
// //           height: 80,
// //           child: CircularProgressIndicator(
// //             value: progress,
// //             backgroundColor: dividerBackgroundColor, // Grey background
// //             color: primaryColor, // Blue indicator
// //             strokeWidth: 6,
// //           ),
// //         ),
// //         SizedBox(height: 8),
// //         Text(
// //           label,
// //           style: montserratTextTheme.titleMedium?.copyWith(
// //                 color: primaryTextColor,
// //               ),
// //         ),
// //       ],
// //     );
// //   }

// //   // Progress Text Widget
// //   Widget _buildProgressText({
// //     required String label,
// //     required double progress,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4.0),
// //       child: Text(
// //         '$label ${((progress) * 100).toInt()}%',
// //         style: montserratTextTheme.bodyMedium?.copyWith(
// //               color: primaryTextColor,
// //             ),
// //       ),
// //     );
// //   }

// //   // Quick Actions Section with Navigation
// //   Widget _buildQuickActionsSection() {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceAround,
// //         children: [
// //           // Prayers
// //           _buildQuickActionIcon(
// //             icon: Icons.book,
// //             label: 'Prayers',
// //             destination: routineID != null
// //                 ? PrayingTimes(prayers: prayers, RoutineID: routineID!)
// //                 : SizedBox(),
// //           ),
// //           // Routine
// //           _buildQuickActionIcon(
// //             icon: Icons.library_books,
// //             label: 'Routine',
// //             destination: arrayID != null
// //                 ? Routine.RoutineApp(
// //                     arrayID: arrayID!,
// //                     token: widget.token,
// //                     templateId: widget.templateId,
// //                   )
// //                 : SizedBox(),
// //           ),
// //           // Tasbih
// //           _buildQuickActionIcon(
// //             icon: Icons.fingerprint,
// //             label: 'Tasbih',
// //             destination: arrayID != null
// //                 ? TasbihCounterPage(arrayID: arrayID!, token: widget.token)
// //                 : SizedBox(),
// //           ),
// //           // Quran
// //           _buildQuickActionIcon(
// //             icon: Icons.explore,
// //             label: 'Quran',
// //             destination: QuranGoalsPage(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Individual Quick Action Icon Widget
// //   Widget _buildQuickActionIcon({
// //     required IconData icon,
// //     required String label,
// //     required Widget destination,
// //   }) {
// //     return GestureDetector(
// //       onTap: () async {
// //         if (destination is SizedBox) return; // Prevent navigation if destination is SizedBox
// //         final result = await Navigator.push(
// //           context,
// //           MaterialPageRoute(builder: (context) => destination),
// //         );
// //         print(result);
// //         if (result.toString() == "refresh") {
// //           print(result);
// //           await fetchTodayRoutine();
// //         }
// //       },
// //       child: Column(
// //         children: [
// //           CircleAvatar(
// //             backgroundColor: buttonBackgroundColor, // Blue background
// //             radius: 30,
// //             child: Icon(
// //               icon,
// //               color: buttonTextColor, // White icon
// //               size: 28,
// //             ),
// //           ),
// //           SizedBox(height: 8),
// //           Text(
// //             label,
// //             style: montserratTextTheme.bodyMedium?.copyWith(
// //                   color: buttonTextColor, // White text
// //                 ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class QiblaPage extends StatelessWidget {
// //   // Define color constants matching the main page
// //   final Color primaryColor = Color(0xFF0000FF); // Blue
// //   final Color cardBackgroundColor = Colors.white; // White
// //   final Color primaryTextColor = Colors.black; // Black

// //   @override
// //   Widget build(BuildContext context) {
// //     // Define a consistent TextTheme
// //     final TextTheme montserratTextTheme = GoogleFonts.montserratTextTheme(
// //       Theme.of(context).textTheme,
// //     ).copyWith(
// //       headlineSmall: GoogleFonts.montserrat(
// //         fontSize: 18,
// //         fontWeight: FontWeight.w500,
// //         color: primaryTextColor,
// //       ),
// //       bodyMedium: GoogleFonts.montserrat(
// //         fontSize: 14,
// //         color: primaryTextColor,
// //       ),
// //     );

// //     return Theme(
// //       data: ThemeData(
// //         textTheme: montserratTextTheme,
// //         appBarTheme: AppBarTheme(
// //           backgroundColor: primaryColor, // Blue AppBar background
// //           iconTheme: IconThemeData(color: Colors.white), // White icons
// //           titleTextStyle: montserratTextTheme.headlineSmall,
// //           elevation: 0,
// //         ),
// //       ),
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: Text(
// //             'Qibla',
// //             style: montserratTextTheme.headlineSmall,
// //           ),
// //         ),
// //         body: Center(
// //           child: Text(
// //             'Qibla Page',
// //             style: montserratTextTheme.bodyMedium,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:frontend1/pages/Template.dart';
// import 'package:frontend1/pages/DashBoard.dart';
// import 'package:frontend1/templates/Islam/PrayerTimes.dart';
// import 'package:frontend1/templates/Islam/Tasbih.dart';
// import 'package:frontend1/templates/Islam/routine1.dart' as Routine;
// import 'package:frontend1/templates/Islam/ReadingTrack.dart'; // Assuming this is your QuranGoalsPage
// import 'package:google_fonts/google_fonts.dart';

// class IslamicAppHomePage extends StatefulWidget {
//   final String templateId;
//   final String token;

//   const IslamicAppHomePage({
//     Key? key,
//     required this.token,
//     required this.templateId,
//   }) : super(key: key);

//   @override
//   IslamicAppHomePageState createState() => IslamicAppHomePageState();
// }

// class IslamicAppHomePageState extends State<IslamicAppHomePage> {
//   int completedPrayers = 0;
//   int totalTasks = 1;
//   int completedTasks = 0;
//   Template? template;
//   String? arrayID;
//   String? routineID;
//   List<dynamic> prayers = [];

//   // We will use this to decide which widget to show in the body
//   // 0 = Quran, 1 = Routine, 2 = Tasbih, 3 = Prayers
//   int _selectedBody = 0;

//   // Define color constants as instance variables
//   final Color primaryColor = Color(0xFF0000FF); // Blue
//   final Color secondaryColor = Color(0xFFFF4081); // Red Accent
//   final Color cardBackgroundColor = Colors.white; // White
//   final Color shadowColor = Color(0xFFBDBDBD); // Grey
//   final Color scaffoldBackgroundColor = Color(0xFFF5F5F5); // Light Grey
//   final Color dividerBackgroundColor = Color(0xFFBDBDBD); // Grey
//   final Color primaryTextColor = Colors.black; // Black
//   final Color secondaryTextColor = Color(0xFF424242); // Dark Grey
//   final Color snackBarBackgroundColor = Color(0x80000000); // Semi-Transparent Black
//   final Color buttonTextColor = Colors.white; // White
//   final Color buttonBackgroundColor = Color(0xFF0000FF); // Blue

//   // Define a custom TextTheme using Montserrat
//   late TextTheme montserratTextTheme;

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//     // Initialize the TextTheme
//     montserratTextTheme = GoogleFonts.montserratTextTheme();
//   }

//   Future<void> _fetchData() async {
//     await fetchTemplate();
//     await fetchTodayRoutine();
//   }

//   Future<void> fetchTodayRoutine() async {
//     final routineService = Routine.RoutineService();
//     if (arrayID == null) {
//       // Handle null case if needed
//       return;
//     }

//     final result = await routineService.retrieveTodayRoutine(arrayID!);

//     setState(() {
//       if (result['success']) {
//         final routineData = result['routine'];

//         prayers = routineData['prayers'];
//         prayers = prayers.map((item) => Prayer.fromJson(item)).toList();
//         routineID = routineData['_id'];
//         print(result['message']);
//         completedTasks = routineData['tasks']
//             .where((task) => task['isCompleted'] == true)
//             .length;
//         totalTasks = routineData['tasks'].length;

//         completedPrayers = routineData['prayers']
//             .where((prayer) => prayer['isCompleted'] == true)
//             .length;

//         print(
//             "CompletedTasks is $completedTasks  CompletedPrayers is $completedPrayers   total tasks $totalTasks");
//       } else {
//         // Handle failure case if needed
//       }
//     });
//   }

//   Future<void> fetchTemplate() async {
//     template =
//         await Template.fetchTemplateData(widget.templateId, widget.token);
//     setState(() {
//       arrayID = template?.data;
//       print("Array id is $arrayID");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Update the TextTheme with Montserrat
//     montserratTextTheme = GoogleFonts.montserratTextTheme(
//       Theme.of(context).textTheme,
//     ).copyWith(
//       headlineSmall: GoogleFonts.montserrat(
//         fontSize: 18,
//         fontWeight: FontWeight.w500,
//         color: primaryTextColor,
//       ),
//       titleMedium: GoogleFonts.montserrat(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         color: primaryTextColor,
//       ),
//       bodyMedium: GoogleFonts.montserrat(
//         fontSize: 14,
//         color: primaryTextColor,
//       ),
//       headlineMedium: GoogleFonts.montserrat(
//         fontSize: 28,
//         fontWeight: FontWeight.bold,
//         color: primaryTextColor,
//       ),
//       // Add more text styles as needed
//     );

//     return Theme(
//       data: ThemeData(
//         // Apply the custom TextTheme
//         textTheme: montserratTextTheme,
//         primaryColor: primaryColor,
//         // Define AppBarTheme for consistent styling
//         appBarTheme: AppBarTheme(
//           backgroundColor: cardBackgroundColor, // White AppBar background
//           iconTheme: IconThemeData(color: primaryColor), // Blue icons
//           titleTextStyle: montserratTextTheme.headlineSmall,
//           elevation: 0,
//         ),
//         // Define ElevatedButtonTheme for consistent button styling
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: buttonTextColor, 
//             backgroundColor: buttonBackgroundColor, // Button text color (White)
//             textStyle: GoogleFonts.montserrat(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => DashboardPage()),
//               ); // Back button functionality
//             },
//           ),
//           title: Text(
//             'Praying Tracker',
//             style: montserratTextTheme.headlineSmall,
//           ),
//         ),
//         backgroundColor: scaffoldBackgroundColor, // Light Grey background
//         body: SafeArea(
//           child: Column(
//             children: [
//               // Top Mosque Image
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     'https://i.pinimg.com/736x/eb/a1/03/eba10303b256fd02444f23e871fc992f.jpg',
//                     height: 200,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               // Daily Goals Section
//               _buildDailyGoalsSection(),
//               // Quick Actions Section (the row of icons)
//               _buildQuickActionsSection(),
//               // The dynamic body content
//               Expanded(
//                 child: _buildBody(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Daily Goals Section
//   Widget _buildDailyGoalsSection() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cardBackgroundColor, // White background
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: shadowColor.withOpacity(0.5), // Grey shadow
//             spreadRadius: 3,
//             blurRadius: 6,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Daily Goals',
//             style: montserratTextTheme.headlineSmall?.copyWith(
//                   color: primaryTextColor,
//                 ),
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               // Total Completion Progress Indicator
//               _buildProgressIndicator(
//                 label: 'Total Completion',
//                 progress: (completedPrayers + completedTasks) /
//                     (totalTasks + 5),
//               ),
//               // Progress Texts
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildProgressText(
//                     label: 'Praying',
//                     progress: completedPrayers / 5,
//                   ),
//                   if (arrayID != null)
//                     _buildProgressText(
//                       label: 'Daily Tasks',
//                       progress: totalTasks != 0
//                           ? completedTasks / totalTasks
//                           : 0,
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Circular Progress Indicator Widget
//   Widget _buildProgressIndicator({
//     required String label,
//     required double progress,
//   }) {
//     return Column(
//       children: [
//         SizedBox(
//           width: 80,
//           height: 80,
//           child: CircularProgressIndicator(
//             value: progress,
//             backgroundColor: dividerBackgroundColor, // Grey background
//             color: primaryColor, // Blue indicator
//             strokeWidth: 6,
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           label,
//           style: montserratTextTheme.titleMedium?.copyWith(
//                 color: primaryTextColor,
//               ),
//         ),
//       ],
//     );
//   }

//   // Progress Text Widget
//   Widget _buildProgressText({
//     required String label,
//     required double progress,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Text(
//         '$label ${((progress) * 100).toInt()}%',
//         style: montserratTextTheme.bodyMedium?.copyWith(
//               color: primaryTextColor,
//             ),
//       ),
//     );
//   }

//   // Quick Actions Section
//   Widget _buildQuickActionsSection() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           // Quran
//           _buildQuickActionIcon(
//             icon: Icons.book,
//             label: 'Quran',
//             onTap: () {
//               setState(() {
//                 _selectedBody = 0;
//               });
//             },
//           ),
//           // Routine
//           _buildQuickActionIcon(
//             icon: Icons.library_books,
//             label: 'Routine',
//             onTap: () {
//               setState(() {
//                 _selectedBody = 1;
//               });
//             },
//           ),
//           // Tasbih
//           _buildQuickActionIcon(
//             icon: Icons.fingerprint,
//             label: 'Tasbih',
//             onTap: () {
//               setState(() {
//                 _selectedBody = 2;
//               });
//             },
//           ),
//           // Prayers
//           _buildQuickActionIcon(
//             icon: Icons.explore,
//             label: 'Prayers',
//             onTap: () {
//               setState(() {
//                 _selectedBody = 3;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // Individual Quick Action Icon Widget
//   Widget _buildQuickActionIcon({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             backgroundColor: buttonBackgroundColor, // Blue background
//             radius: 30,
//             child: Icon(
//               icon,
//               color: buttonTextColor, // White icon
//               size: 28,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             label,
//             style: montserratTextTheme.bodyMedium?.copyWith(
//                   color: primaryColor, // Blue text to match theme
//                 ),
//           ),
//         ],
//       ),
//     );
//   }

//   // This method returns the Widget that should appear in the body
//   // depending on _selectedBody
//   Widget _buildBody() {
//     switch (_selectedBody) {
//       case 0:
//         // Quran page (initial/default)
//         return _buildQuranBody();
//       case 1:
//         // Routine
//         return _buildRoutineBody();
//       case 2:
//         // Tasbih
//         return _buildTasbihBody();
//       case 3:
//         // Prayers
//         return _buildPrayersBody();
//       default:
//         return _buildQuranBody();
//     }
//   }

//   // Example placeholders for each page:

//   Widget _buildQuranBody() {
//     // If you have an actual QuranGoalsPage class, you can directly return that
//     // or wrap it in a container if you need additional styling.
//     return QuranGoalsPage(); // Ensure QuranGoalsPage handles its own scrolling if needed
//   }

//   Widget _buildRoutineBody() {
//     // Example usage of your routine widget
//     if (arrayID == null) {
//       return Center(
//         child: Text('No routine data yet.'),
//       );
//     }
//     return Routine.RoutineApp(
//       arrayID: arrayID!,
//       token: widget.token,
//       templateId: widget.templateId,
//     );
//   }

//   Widget _buildTasbihBody() {
//     if (arrayID == null) {
//       return Center(
//         child: Text('No Tasbih data yet.'),
//       );
//     }
//     return TasbihCounterPage(
//       arrayID: arrayID!,
//       token: widget.token,
//     );
//   }

//   Widget _buildPrayersBody() {
//     if (routineID == null) {
//       return Center(
//         child: Text('No prayers data yet.'),
//       );
//     }
//     return PrayingTimes(
//       prayers: prayers,
//       RoutineID: routineID!,
//     );
//   }
// }

// class QiblaPage extends StatelessWidget {
//   // Define color constants matching the main page
//   final Color primaryColor = Color(0xFF0000FF); // Blue
//   final Color cardBackgroundColor = Colors.white; // White
//   final Color primaryTextColor = Colors.black; // Black

//   @override
//   Widget build(BuildContext context) {
//     // Define a consistent TextTheme
//     final TextTheme montserratTextTheme = GoogleFonts.montserratTextTheme(
//       Theme.of(context).textTheme,
//     ).copyWith(
//       headlineSmall: GoogleFonts.montserrat(
//         fontSize: 18,
//         fontWeight: FontWeight.w500,
//         color: primaryTextColor,
//       ),
//       bodyMedium: GoogleFonts.montserrat(
//         fontSize: 14,
//         color: primaryTextColor,
//       ),
//     );

//     return Theme(
//       data: ThemeData(
//         textTheme: montserratTextTheme,
//         appBarTheme: AppBarTheme(
//           backgroundColor: primaryColor, // Blue AppBar background
//           iconTheme: IconThemeData(color: Colors.white), // White icons
//           titleTextStyle: montserratTextTheme.headlineSmall,
//           elevation: 0,
//         ),
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Qibla',
//             style: montserratTextTheme.headlineSmall,
//           ),
//         ),
//         body: Center(
//           child: Text(
//             'Qibla Page',
//             style: montserratTextTheme.bodyMedium,
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:frontend1/pages/Template.dart';
import 'package:frontend1/pages/DashBoard.dart';
import 'package:frontend1/templates/Islam/PrayerTimes.dart';
import 'package:frontend1/templates/Islam/Tasbih.dart';
import 'package:frontend1/templates/Islam/routine1.dart' as Routine;
import 'package:frontend1/templates/Islam/ReadingTrack.dart'; // Assuming this is your QuranGoalsPage
import 'package:frontend1/templates/sideBar.dart';
import 'package:google_fonts/google_fonts.dart';

class IslamicAppHomePage extends StatefulWidget {
  final String templateId;
  final String token;

  const IslamicAppHomePage({
    Key? key,
    required this.token,
    required this.templateId,
  }) : super(key: key);

  @override
  IslamicAppHomePageState createState() => IslamicAppHomePageState();
}

class IslamicAppHomePageState extends State<IslamicAppHomePage> {
  int completedPrayers = 0;
  int totalTasks = 1;
  int completedTasks = 0;
  Template? template;
  String? arrayID;
  String? routineID;
  List<dynamic> prayers = [];

  // We will use this to decide which widget to show in the body
  // 0 = Quran, 1 = Routine, 2 = Tasbih, 3 = Prayers
  int _selectedBody = 0;

  // Define color constants as instance variables
  final Color primaryColor = Color(0xFF0000FF); // Blue
  final Color secondaryColor = Color(0xFFFF4081); // Red Accent
  final Color cardBackgroundColor = Colors.white; // White
  final Color shadowColor = Color(0xFFBDBDBD); // Grey
  final Color scaffoldBackgroundColor = Color(0xFFF5F5F5); // Light Grey
  final Color dividerBackgroundColor = Color(0xFFBDBDBD); // Grey
  final Color primaryTextColor = Colors.black; // Black
  final Color secondaryTextColor = Color(0xFF424242); // Dark Grey
  final Color snackBarBackgroundColor = Color(0x80000000); // Semi-Transparent Black
  final Color buttonTextColor = Colors.white; // White
  final Color buttonBackgroundColor = Color(0xFF0000FF); // Blue

  // Define a custom TextTheme using Montserrat
  late TextTheme montserratTextTheme;

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Initialize the TextTheme
    montserratTextTheme = GoogleFonts.montserratTextTheme();
  }

  Future<void> _fetchData() async {
    await fetchTemplate();
    await fetchTodayRoutine();
  }

  Future<void> fetchTodayRoutine() async {
    final routineService = Routine.RoutineService();
    if (arrayID == null) {
      // Handle null case if needed
      print("array ID is null");
      return;
    }

    final result = await routineService.retrieveTodayRoutine(arrayID!);

    setState(() {
      if (result['success']) {
        final routineData = result['routine'];

        prayers = routineData['prayers'];
        prayers = prayers.map((item) => Prayer.fromJson(item)).toList();
        routineID = routineData['_id'];
        print(result['message']);
        completedTasks = routineData['tasks']
            .where((task) => task['isCompleted'] == true)
            .length;
        totalTasks = routineData['tasks'].length;

        completedPrayers = routineData['prayers']
            .where((prayer) => prayer['isCompleted'] == true)
            .length;

        print(
            "CompletedTasks is $completedTasks  CompletedPrayers is $completedPrayers   total tasks $totalTasks");
      } else {
        // Handle failure case if needed
        print("failed to retrive prayers");
      }
    });
  }

  Future<void> fetchTemplate() async {
    template =
        await Template.fetchTemplateData(widget.templateId, widget.token);
    setState(() {
      arrayID = template?.data;
      print("Array id is $arrayID");
    });
  }


  @override
  Widget build(BuildContext context) {
    // Update the TextTheme with Montserrat
    bool isWeb=MediaQuery.of(context).size.width>1200? true: false;
  final TextTheme montserratTextTheme = TextTheme(
  headlineSmall: GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: primaryTextColor,
  ),
  titleMedium: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primaryTextColor,
  ),
  bodyMedium: GoogleFonts.montserrat(
    fontSize: 14,
    color: primaryTextColor,
  ),
  headlineMedium: GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  ),
  // Add more text styles as needed
).apply(
  displayColor: primaryTextColor,
  bodyColor: primaryTextColor,
);

// Usage in your ThemeData
ThemeData(
  textTheme: montserratTextTheme,
);


    return Theme(
      data: ThemeData(
        // Apply the custom TextTheme
        textTheme: montserratTextTheme,
        primaryColor: primaryColor,
        // Define AppBarTheme for consistent styling
        appBarTheme: AppBarTheme(
          backgroundColor: cardBackgroundColor, // White AppBar background
          iconTheme: IconThemeData(color: primaryColor), // Blue icons
          titleTextStyle: montserratTextTheme.headlineSmall,
          elevation: 0,
        ),
        // Define ElevatedButtonTheme for consistent button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: buttonTextColor, 
            backgroundColor: buttonBackgroundColor, // Button text color (White)
            textStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
                automaticallyImplyLeading: false, 
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
              ); // Back button functionality
            },
          ),
          title: Text(
            'Praying Tracker',
            style: montserratTextTheme.headlineSmall,
          ),
        ),
        backgroundColor: scaffoldBackgroundColor, // Light Grey background
        body:RefreshIndicator( 
           onRefresh: () async {
    await    fetchTodayRoutine(); // Ensure this function is asynchronous
    setState(() {
      // Trigger a rebuild after data is fetched
    });
  },
       
        child:
        
         /* Row(
              children: [
               // if (isWeb) WebSidebar(), 
             //   if (isWeb)   SizedBox(width:100), 
               
                Expanded(
                  child: Column(
                    children: [
                    */
     Row(
  children: [
      if (isWeb) WebSidebar(),
    if (isWeb) SizedBox(width: 170), // Spacer for web layout
   Expanded(
          flex: 5, // Adjust flex to allocate space proportionally
  
      child:  
         SingleChildScrollView(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Mosque Image
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'lib/images/islam.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Daily Goals Section
                  _buildDailyGoalsSection(),
                  // Quick Actions Section (the row of icons)
                  _buildQuickActionsSection(),
                  // The dynamic body content
               //  Expanded(
                  //  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //    child:
                     _buildBody(),
             /*      Expanded(
        child:  QuranGoalsPage()
                   )
                   */
         //   QuranGoalsPage()
               // )
            ],
          ),
        ),
        ),
    //  ),

             // ]
              
      //  )
            //    )
           //   ]
        //)
      if (isWeb) SizedBox(width: 100), // Spacer for web layout

  ]
      )
        )
      )
    );
  }

  // Daily Goals Section
  Widget _buildDailyGoalsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackgroundColor, // White background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.5), // Grey shadow
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Goals',
            style: montserratTextTheme.headlineSmall?.copyWith(
                  color: primaryTextColor,
                ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Total Completion Progress Indicator
              _buildProgressIndicator(
                label: 'Total Completion',
                progress: (completedPrayers + completedTasks) /
                    (totalTasks + 5),
              ),
              // Progress Texts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressText(
                    label: 'Praying',
                    progress: completedPrayers / 5,
                  ),
                  if (arrayID != null)
                    _buildProgressText(
                      label: 'Daily Tasks',
                      progress: totalTasks != 0
                          ? completedTasks / totalTasks
                          : 0,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Circular Progress Indicator Widget
  Widget _buildProgressIndicator({
    required String label,
    required double progress,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: dividerBackgroundColor, // Grey background
            color: primaryColor, // Blue indicator
            strokeWidth: 6,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: montserratTextTheme.titleMedium?.copyWith(
                color: primaryTextColor,
              ),
        ),
      ],
    );
  }

  // Progress Text Widget
  Widget _buildProgressText({
    required String label,
    required double progress,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label ${((progress) * 100).toInt()}%',
        style: montserratTextTheme.bodyMedium?.copyWith(
              color: primaryTextColor,
            ),
      ),
    );
  }

  // Quick Actions Section
  Widget _buildQuickActionsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Quran
          _buildQuickActionIcon(
            icon: Icons.book,
            label: 'Quran',
            onTap: () {
              setState(() {
                _selectedBody = 0;
              });
            },
          ),
          // Routine
          _buildQuickActionIcon(
            icon: Icons.library_books,
            label: 'Routine',
            onTap: () {
              setState(() {
                _selectedBody = 1;
              });
            },
          ),
          // Tasbih
          _buildQuickActionIcon(
            icon: Icons.fingerprint,
            label: 'Tasbih',
            onTap: () {
              setState(() {
                _selectedBody = 2;
              });
            },
          ),
          // Prayers
          _buildQuickActionIcon(
            icon: Icons.explore,
            label: 'Prayers',
            onTap: () {
              setState(() {
                _selectedBody = 3;
              });
            },
          ),
        ],
      ),
    );
  }

  // Individual Quick Action Icon Widget
  Widget _buildQuickActionIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: buttonBackgroundColor, // Blue background
            radius: 30,
            child: Icon(
              icon,
              color: buttonTextColor, // White icon
              size: 28,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: montserratTextTheme.bodyMedium?.copyWith(
                  color: primaryColor, // Blue text to match theme
                ),
          ),
        ],
      ),
    );
  }

  // This method returns the Widget that should appear in the body
  // depending on _selectedBody
  Widget _buildBody() {
    switch (_selectedBody) {
      case 0:
      //return  QuranGoalsPage();
        return QuranGoalsPage();
      case 1:
        // Routine
        return _buildRoutineBody();
      case 2:
        // Tasbih
        return _buildTasbihBody();
      case 3:
        // Prayers
        return _buildPrayersBody();
      default:
        return _buildQuranBody();
    }
  }

  // Example placeholders for each page:

  Widget _buildQuranBody() {
    // Ensure QuranGoalsPage handles its own scrolling if needed
    return QuranGoalsPage(); // If QuranGoalsPage contains its own scrollable widgets
  }

  Widget _buildRoutineBody() {
    // Example usage of your routine widget
    if (arrayID == null) {
      return Center(
        child: Text('No routine data yet.'),
      );
    }
    return Routine.RoutineApp(
      arrayID: arrayID!,
      token: widget.token,
      templateId: widget.templateId,
         onAdd: () async {
      await fetchTodayRoutine();
         }
    );
  }

  Widget _buildTasbihBody() {
    if (arrayID == null) {
      return Center(
        child: Text('No Tasbih data yet.'),
      );
    }
    return TasbihCounterPage(
      arrayID: arrayID!,
      token: widget.token,
    );
  }

  Widget _buildPrayersBody() {
    if (routineID == null) {
      return Center(
        child: Text('No prayers data yet.'),
      );
    }
    return PrayingTimes(
      prayers: prayers,
      RoutineID: routineID!,
         onAdd: () async {
      await fetchTodayRoutine();
    },
    );
  }
}

class QiblaPage extends StatelessWidget {
  // Define color constants matching the main page
  final Color primaryColor = Color(0xFF0000FF); // Blue
  final Color cardBackgroundColor = Colors.white; // White
  final Color primaryTextColor = Colors.black; // Black

  @override
  Widget build(BuildContext context) {
    // Define a consistent TextTheme
    final TextTheme montserratTextTheme = GoogleFonts.montserratTextTheme(
      Theme.of(context).textTheme,
    ).copyWith(
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 14,
        color: primaryTextColor,
      ),
    );

    return Theme(
      data: ThemeData(
        textTheme: montserratTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor, // Blue AppBar background
          iconTheme: IconThemeData(color: Colors.white), // White icons
          titleTextStyle: montserratTextTheme.headlineSmall,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Qibla',
            style: montserratTextTheme.headlineSmall,
          ),
        ),
        body: Center(
          child: Text(
            'Qibla Page',
            style: montserratTextTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
