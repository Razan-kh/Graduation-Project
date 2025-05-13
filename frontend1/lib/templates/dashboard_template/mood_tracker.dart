// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// class MoodTracker extends StatefulWidget {
//   final String baseUrl;
//   final String token;
//   final String templateId;

//   const MoodTracker({
//     required this.baseUrl,
//     required this.token,
//     required this.templateId,
//   });

//   @override
//   _MoodTrackerState createState() => _MoodTrackerState();
// }

// class _MoodTrackerState extends State<MoodTracker> {
//   List<bool> moodTracker = List.generate(31, (index) => false); // 31 days
//   final List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

//   @override
//   void initState() {
//     super.initState();
//     _fetchMoodData();
//   }

//   Future<void> _fetchMoodData() async {
//     // Assuming your backend returns full template data at: GET /api/studentPlanner/:templateId
//     // The moodTracker field is expected as an array of booleans
//     final url = Uri.parse('${widget.baseUrl}/studentPlanner2/${widget.templateId}');
//     final response = await http.get(url, headers: {
//       'Authorization': 'Bearer ${widget.token}',
//     });

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['moodTracker'] != null && data['moodTracker'] is List) {
//         // Ensure it's a List<bool>
//         List<dynamic> fetchedMood = data['moodTracker'];
//         if (fetchedMood.length == 31) {
//           setState(() {
//             moodTracker = fetchedMood.map((val) => val as bool).toList();
//           });
//         }
//       }
//     } else {
//       print('Failed to fetch mood data: ${response.statusCode}');
//     }
//   }

//   Future<void> _updateMoodData() async {
//     // Call PUT /api/studentPlanner/updateMoodTracker with the updated moodArray
//     final url = Uri.parse('${widget.baseUrl}/studentPlanner2/updateMoodTracker');
//     final response = await http.put(
//       url,
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//         'Content-Type': 'application/json'
//       },
//       body: jsonEncode({
//         'templateId': widget.templateId,
//         'moodArray': moodTracker,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Successfully updated mood tracker on the backend
//       // Optionally, you could re-fetch if needed, but not necessary
//     } else {
//       print('Failed to update mood tracker: ${response.statusCode}');
//     }
//   }

//   void _toggleMood(int index) {
//     setState(() {
//       moodTracker[index] = !moodTracker[index];
//     });
//     // After updating the local state, call the backend to sync the data
//     _updateMoodData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Mood Tracker',
//           style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: daysOfWeek.map((day) => Text(day, style: const TextStyle(fontWeight: FontWeight.bold))).toList(),
//         ),
//         const SizedBox(height: 8),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 7, // One column per day of the week
//             crossAxisSpacing: 4,
//             mainAxisSpacing: 4,
//             childAspectRatio: 1, // To make squares smaller
//           ),
//           itemCount: 31, // Assuming a month of 31 days
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 _toggleMood(index);
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: moodTracker[index] ? Colors.green : Colors.grey[300],
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class MoodTracker extends StatefulWidget {
  final String baseUrl;
  final String token;
  final String templateId;

  const MoodTracker({super.key, 
    required this.baseUrl,
    required this.token,
    required this.templateId,
  });

  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  List<bool> moodTracker = List.generate(31, (index) => false); // 31 days
  final List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _fetchMoodData();
  }

  Future<void> _fetchMoodData() async {
    final url = Uri.parse('${widget.baseUrl}/studentPlanner2/${widget.templateId}');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${widget.token}',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['moodTracker'] != null && data['moodTracker'] is List) {
        List<dynamic> fetchedMood = data['moodTracker'];
        if (fetchedMood.length == 31) {
          setState(() {
            moodTracker = fetchedMood.map((val) => val as bool).toList();
          });
        }
      }
    } else {
      print('Failed to fetch mood data: ${response.statusCode}');
    }
  }

  Future<void> _updateMoodData() async {
    final url = Uri.parse('${widget.baseUrl}/studentPlanner2/updateMoodTracker');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'templateId': widget.templateId,
        'moodArray': moodTracker,
      }),
    );

    if (response.statusCode == 200) {
      // Updated successfully
    } else {
      print('Failed to update mood tracker: ${response.statusCode}');
    }
  }

  void _toggleMood(int index) {
    setState(() {
      moodTracker[index] = !moodTracker[index];
    });
    _updateMoodData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Container(
          width: double.infinity,
          color: const Color(0xFFDFE6F2), // light pastel background
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            'Mood Tracker',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Days of the Week Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: daysOfWeek.map((day) {
              return Text(
                day,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),

        // Mood Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: 31,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _toggleMood(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: moodTracker[index] ? Colors.green[300] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Divider(color: Colors.grey[300], thickness: 1),
        const SizedBox(height: 16),
      ],
    );
  }
}
