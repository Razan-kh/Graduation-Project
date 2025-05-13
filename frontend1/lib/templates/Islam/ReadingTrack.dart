// import 'package:flutter/material.dart';

// class QuranGoalsPage extends StatefulWidget {
//   @override
//   _QuranGoalsPageState createState() => _QuranGoalsPageState();
// }

// class _QuranGoalsPageState extends State<QuranGoalsPage> {
//   int readingGoal = 10; // Number of pages/verses to read daily
//   int memorizationGoal = 5; // Number of verses to memorize daily
//   int achievedReading = 0;
//   int achievedMemorization = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Quran Goals'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Section: Goal Setting
//               Text(
//                 'Set Your Goals',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               GoalInput(
//                 label: "Daily Reading Goal (Pages/Verses)",
//                 initialValue: readingGoal.toString(),
//                 onChanged: (value) {
//                   setState(() {
//                     readingGoal = int.tryParse(value) ?? 0;
//                   });
//                 },
//               ),
//               GoalInput(
//                 label: "Daily Memorization Goal (Verses)",
//                 initialValue: memorizationGoal.toString(),
//                 onChanged: (value) {
//                   setState(() {
//                     memorizationGoal = int.tryParse(value) ?? 0;
//                   });
//                 },
//               ),
//               SizedBox(height: 20),

//               // Section: Log Progress
//               Text(
//                 'Log Today\'s Progress',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               GoalInput(
//                 label: "Pages/Verses Read Today",
//                 initialValue: achievedReading.toString(),
//                 onChanged: (value) {
//                   setState(() {
//                     achievedReading = int.tryParse(value) ?? 0;
//                   });
//                 },
//               ),
//               GoalInput(
//                 label: "Verses Memorized Today",
//                 initialValue: achievedMemorization.toString(),
//                 onChanged: (value) {
//                   setState(() {
//                     achievedMemorization = int.tryParse(value) ?? 0;
//                   });
//                 },
//               ),
//               SizedBox(height: 20),

//               // Section: Progress Overview
//               Text(
//                 'Progress Overview',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               ProgressBar(
//                 label: "Reading Progress",
//                 achieved: achievedReading,
//                 goal: readingGoal,
//               ),
//               ProgressBar(
//                 label: "Memorization Progress",
//                 achieved: achievedMemorization,
//                 goal: memorizationGoal,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Widget for goal input fields
// class GoalInput extends StatelessWidget {
//   final String label;
//   final String initialValue;
//   final Function(String) onChanged;

//   const GoalInput({
//     required this.label,
//     required this.initialValue,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: TextStyle(fontSize: 16)),
//           SizedBox(height: 5),
//           TextField(
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               hintText: initialValue,
//             ),
//             onChanged: onChanged,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Widget for progress bar
// class ProgressBar extends StatelessWidget {
//   final String label;
//   final int achieved;
//   final int goal;

//   const ProgressBar({
//     required this.label,
//     required this.achieved,
//     required this.goal,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double progress = achieved / goal;
//     progress = progress > 1.0 ? 1.0 : progress; // Ensure progress doesn't exceed 100%

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: TextStyle(fontSize: 16)),
//           SizedBox(height: 5),
//           LinearProgressIndicator(
//             value: progress,
//             backgroundColor: Colors.grey[300],
//             color: Colors.teal,
//             minHeight: 8,
//           ),
//           SizedBox(height: 5),
//           Text('${achieved} / ${goal}'),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure Google Fonts is imported

class QuranGoalsPage extends StatefulWidget {
  @override
  _QuranGoalsPageState createState() => _QuranGoalsPageState();
}

class _QuranGoalsPageState extends State<QuranGoalsPage> {
  int readingGoal = 10; // Number of pages/verses to read daily
  int memorizationGoal = 5; // Number of verses to memorize daily
  int achievedReading = 0;
  int achievedMemorization = 0;

  @override
  Widget build(BuildContext context) {
        return Padding(
      padding: const EdgeInsets.all(1.0),
    /*  appBar: AppBar(
        title: Text('Finance Details'),
      ),
      */
    //  child: SingleChildScrollView(
 child : //_isLoading ? CircularProgressIndicator():
   Column(
        children: [
            Text(
              'Set Your Goals',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            GoalInput(
              label: "Daily Reading Goal (Pages/Verses)",
              initialValue: readingGoal.toString(),
              onChanged: (value) {
                setState(() {
                  readingGoal = int.tryParse(value) ?? 0;
                });
              },
            ),
            GoalInput(
              label: "Daily Memorization Goal (Verses)",
              initialValue: memorizationGoal.toString(),
              onChanged: (value) {
                setState(() {
                  memorizationGoal = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 24),

            // Section: Log Progress
            Text(
              'Log Today\'s Progress',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            GoalInput(
              label: "Pages/Verses Read Today",
              initialValue: achievedReading.toString(),
              onChanged: (value) {
                setState(() {
                  achievedReading = int.tryParse(value) ?? 0;
                });
              },
            ),
            GoalInput(
              label: "Verses Memorized Today",
              initialValue: achievedMemorization.toString(),
              onChanged: (value) {
                setState(() {
                  achievedMemorization = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 24),

            // Section: Progress Overview
            Text(
              'Progress Overview',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            ProgressBar(
              label: "Reading Progress",
              achieved: achievedReading,
              goal: readingGoal,
            ),
            ProgressBar(
              label: "Memorization Progress",
              achieved: achievedMemorization,
              goal: memorizationGoal,
            ),
          ],
        ),
    //  ),
  //  )
    );
  }
}

// Widget for goal input fields
class GoalInput extends StatelessWidget {
  final String label;
  final String initialValue;
  final Function(String) onChanged;

  const GoalInput({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: initialValue,
              filled: true,
              fillColor: Colors.white,
            ),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.black87,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// Widget for progress bar
class ProgressBar extends StatelessWidget {
  final String label;
  final int achieved;
  final int goal;

  const ProgressBar({
    required this.label,
    required this.achieved,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    double progress = goal > 0 ? achieved / goal : 0.0;
    progress = progress > 1.0 ? 1.0 : progress; // Ensure progress doesn't exceed 100%

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.blue, // Primary color for consistency
            minHeight: 10,
          ),
          SizedBox(height: 6),
          Text(
            '$achieved / $goal',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
