// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:http/http.dart' as http;
// /*
// router.put('/edit-LeetCode-profile'
// leetCodeProfile
// showLeetCodeProfile
// router.get('/portfolio/LeetCode'

// */
// class LeetCodeSection extends StatefulWidget {
//    final bool isEditing;
//    final String token;
//       final Function(Function()) registerSaveCallback;
//    const LeetCodeSection({super.key, required this.isEditing,required this.registerSaveCallback,required this.token});

//   @override
//   _LeetCodeSectionState createState() => _LeetCodeSectionState();
// }

// class _LeetCodeSectionState extends State<LeetCodeSection> {

//   Map<String, dynamic> leetCodeData = {};
//   bool isLoading = true;
//  bool isVisible=true;
//   final TextEditingController _controller = TextEditingController();
  
//  String username="";
//   @override
//   void initState() {
//     super.initState();
//         widget.registerSaveCallback(saveData);
//         getLeetCodeProfile();
    
      
  
//   }
//    void saveData() {
//     print("data save in Github Section");
// updateLeetProfile();
//   }


//   // The base URL of your backend API


//   // Function to fetch GitHub profile and visibility by userId
//   Future<Map<String, dynamic>> getLeetCodeProfile() async {
//       final String baseUrl = 'http://$localhost/api/portfolio/LeetCode';
//     final url = Uri.parse(baseUrl);

//     try {
//       final response = await http.get(url,
//       headers: {
//         'Authorization': 'Bearer ${widget.token}'
//       }
//       );

//       // Check if the response status code is 200 (OK)
//       if (response.statusCode == 200) {
//         // Parse the JSON response
//         final data = json.decode(response.body);
//         setState(() {
//           print(data);
//           isVisible=data['showLeetCodeProfile'];
// username= data['leetCodeProfile'];
//   _controller.text=username;
//      fetchLeetCodeStats();
//         });
//         return {
//           'leetCodeProfile': data['leetCodeProfile'],
//           'showLeetCodeProfile': data['showLeetCodeProfile'],
//         };
//       } else {
//         throw Exception('Failed to load Leet profile');
//       }
//     } catch (error) {
//       throw Exception('Error fetching Leet profile: $error');
//     }
//   }

//   // Function to update GitHub profile and visibility
//   Future<bool> updateLeetProfile() async {
//        const String apiUrl = 'http://$localhost/api/edit-LeetCode-profile'; // Replace with your API URL

//     try {
//       final response = await http.put(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization':'Bearer ${widget.token}'
//         },
//         body: json.encode({
//           'leetCodeProfile':_controller.text ,
//           'showLeetCodeProfile': isVisible,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // Successfully updated the profile
//         setState(() {
//           username=_controller.text ;
       
//         });
//         return true;
//       } else {
//         // If the response code is not 200, print error and return false
//         print('Failed to update Leet: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       // Handle any error during the request
//       print('Error: $e');
//       return false;
//     }
//   }

//   Widget editMode()
// {
//   return Padding(
//         padding: const EdgeInsets.all(16.0),
//      child:    Column(children: [
//         Text(
//           "Edit LeetCode Username",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 20),
// TextField(
//           controller: _controller,
//            onEditingComplete:(){
//             setState(() {
//                  username= _controller.text;
//                  fetchLeetCodeStats();
//             });
       
//         },
//           decoration: InputDecoration(
//             labelText: "LeetCode Username",
//             hintText: "Enter your LeetCode username",
//             border: OutlineInputBorder(),
//             prefixIcon: Icon(Icons.link),
//           ),
//         ),
            
// SizedBox(height:10),
//          ElevatedButton(   ///for toggle the visibility
//               onPressed: () {
//                 setState(() {
//                   isVisible = !isVisible; // Toggle the visibility
//                 });
//               },
//               child: Text(isVisible ? 'Hide LeetCode' : 'Show LeetCode'),
//             ),
//           ],
//               ),
  
     
//       );
// }

//   Future<void> fetchLeetCodeStats() async {
//     final url = Uri.parse('https://leetcode.com/graphql');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'query': '''
//         query {
//           matchedUser(username: "$username") {
//             username
//             submitStatsGlobal {
//               acSubmissionNum {
//                 difficulty
//                 count
//               }
//             }
//             profile {
//               ranking
//               reputation
//               contestCount
//             }
//           }
//         }
//         '''
//       }),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         leetCodeData = json.decode(response.body)['data']['matchedUser'];
//         isLoading = false;
//       });
//     } else {
//       print('Error fetching LeetCode stats');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? Center(child: CircularProgressIndicator())
//         : Padding(
//             padding: const EdgeInsets.all(16.0),
//                child:  widget.isEditing? editMode()
//            : isVisible?
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'LeetCode Stats',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 20),
//                 _buildStatsOverview(),
//                 SizedBox(height: 20),
//                 _buildDifficultyChart(),
//                 SizedBox(height: 20),
              
//               ],
//             )
//             :SizedBox(height :10),
//           );
    
//   }

//   Widget _buildStatsOverview() {
//     final profile = leetCodeData['profile'] ?? {};
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Username: ${leetCodeData['username']}'),
//             Text('Ranking: ${profile['ranking'] ?? 'N/A'}'),
//             Text('Reputation: ${profile['reputation'] ?? 'N/A'}'),
//             Text('Contests Participated: ${profile['contestCount'] ?? 0}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDifficultyChart() {
//     final stats = leetCodeData['submitStatsGlobal']['acSubmissionNum'] ?? [];
//     final easy = stats.firstWhere((s) => s['difficulty'] == 'Easy', orElse: () => {'count': 0})['count'];
//     final medium = stats.firstWhere((s) => s['difficulty'] == 'Medium', orElse: () => {'count': 0})['count'];
//     final hard = stats.firstWhere((s) => s['difficulty'] == 'Hard', orElse: () => {'count': 0})['count'];

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text('Problems Solved by Difficulty'),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildDifficultyChip('Easy', easy, Colors.green),
//                 _buildDifficultyChip('Medium', medium, Colors.orange),
//                 _buildDifficultyChip('Hard', hard, Colors.red),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDifficultyChip(String label, int count, Color color) {
//     return Chip(
//       label: Text('$label: $count'),
//       backgroundColor: color.withOpacity(0.2),
//     );
//   }


// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class LeetCodeSection extends StatefulWidget {
  final bool isEditing;
  final String token;
  final Function(Function()) registerSaveCallback;

  const LeetCodeSection({
    super.key,
    required this.isEditing,
    required this.registerSaveCallback,
    required this.token,
  });

  @override
  _LeetCodeSectionState createState() => _LeetCodeSectionState();
}

class _LeetCodeSectionState extends State<LeetCodeSection> {
  Map<String, dynamic> leetCodeData = {};
  bool isLoading = true;
  bool isVisible = true;
  final TextEditingController _controller = TextEditingController();
  String username = "";

  @override
  void initState() {
    super.initState();
    widget.registerSaveCallback(saveData);
    getLeetCodeProfile();
  }

  void saveData() {
    print("Saving data in LeetCode Section...");
    updateLeetProfile();
  }

  /// Fetch LeetCode Profile from your backend
  Future<Map<String, dynamic>> getLeetCodeProfile() async {
    final String baseUrl = 'http://$localhost/api/portfolio/LeetCode';
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          print(data);
          isVisible = data['showLeetCodeProfile'];
          username = data['leetCodeProfile'];
          _controller.text = username;
          fetchLeetCodeStats();
        });
        return {
          'leetCodeProfile': data['leetCodeProfile'],
          'showLeetCodeProfile': data['showLeetCodeProfile'],
        };
      } else {
        throw Exception('Failed to load LeetCode profile');
      }
    } catch (error) {
      throw Exception('Error fetching LeetCode profile: $error');
    }
  }

  /// Update LeetCode Profile in your backend
  Future<bool> updateLeetProfile() async {
    const String apiUrl = 'http://$localhost/api/edit-LeetCode-profile';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'leetCodeProfile': _controller.text,
          'showLeetCodeProfile': isVisible,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          username = _controller.text;
        });
        return true;
      } else {
        print('Failed to update LeetCode: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  
Future<void> fetchLeetCodeStats() async {
  final url = Uri.parse('http://$localhost/api/fetchLeetCodeStats');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'username': username,
    }),
  );

  if (response.statusCode == 200 || response.statusCode ==201) {
          if(mounted){
    setState(() {
      leetCodeData = json.decode(response.body);
      isLoading = false;
    });
          }
  } else {
    print('Error fetching LeetCode stats');
  }
}

/*

  Future<void> fetchLeetCodeStats() async {
    final url = Uri.parse('https://leetcode.com/graphql');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'query': '''
          query {
            matchedUser(username: "$username") {
              username
              submitStatsGlobal {
                acSubmissionNum {
                  difficulty
                  count
                }
              }
              profile {
                ranking
                reputation
                contestCount
              }
            }
          }
        '''
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        leetCodeData = json.decode(response.body)['data']['matchedUser'];
        isLoading = false;
      });
    } else {
      print('Error fetching LeetCode stats');
      setState(() {
        isLoading = false;
      });
    }
  }
  */

  /// --- EDIT MODE WIDGET ---
  Widget editMode(TextStyle bodyStyle, TextStyle labelStyle, TextStyle hintStyle) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Edit LeetCode Username",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          // LeetCode Username
          TextField(
            controller: _controller,
            onEditingComplete: () {
              setState(() {
                username = _controller.text;
                fetchLeetCodeStats();
              });
            },
            style: bodyStyle,
            decoration: InputDecoration(
              labelText: "LeetCode Username",
              labelStyle: labelStyle,
              hintText: "Enter your LeetCode username",
              hintStyle: hintStyle,
              prefixIcon: const Icon(Icons.link, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Toggle Visibility Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            child: Text(
              isVisible ? 'Hide LeetCode' : 'Show LeetCode',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// --- PREVIEW MODE WIDGET ---
  @override
  Widget build(BuildContext context) {
    // Common text styles
    final TextStyle headerStyle = GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    final TextStyle subHeaderStyle = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
    final TextStyle bodyStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.black87,
    );
    final TextStyle labelStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[700],
      fontWeight: FontWeight.w500,
    );
    final TextStyle hintStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[400],
    );

    if (widget.isEditing) {
      return editMode(bodyStyle, labelStyle, hintStyle);
    }

    // If not editing, display LeetCode Stats if visible
    if (!isVisible) {
      return const SizedBox(); // Show nothing if not visible
    }

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                Text('LeetCode Stats', style: headerStyle),
                const SizedBox(height: 20),
                // Stats Overview
                _buildStatsOverview(bodyStyle),
                const SizedBox(height: 20),
                // Difficulty Chart
                _buildDifficultyChart(headerStyle),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  /// Builds the Stats Overview Card
  Widget _buildStatsOverview(TextStyle bodyStyle) {
    final profile = leetCodeData['profile'] ?? {};
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username
            Text(
              'Username: ${leetCodeData['username'] ?? 'N/A'}',
              style: bodyStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Ranking
            Text(
              'Ranking: ${profile['ranking'] ?? 'N/A'}',
              style: bodyStyle,
            ),
            const SizedBox(height: 8),
            // Reputation
            Text(
              'Reputation: ${profile['reputation'] ?? 'N/A'}',
              style: bodyStyle,
            ),
            const SizedBox(height: 8),
            // Contests Participated
            Text(
              'Contests Participated: ${profile['contestCount'] ?? 0}',
              style: bodyStyle,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the Difficulty Chart using Chips for visualization
  Widget _buildDifficultyChart(TextStyle headerStyle) {
    final stats = leetCodeData['submitStatsGlobal']['acSubmissionNum'] ?? [];
    final easy = stats.firstWhere(
        (s) => s['difficulty'] == 'Easy',
        orElse: () => {'count': 0})['count'] as int;
    final medium = stats.firstWhere(
        (s) => s['difficulty'] == 'Medium',
        orElse: () => {'count': 0})['count'] as int;
    final hard = stats.firstWhere(
        (s) => s['difficulty'] == 'Hard',
        orElse: () => {'count': 0})['count'] as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Problems Solved by Difficulty', style: headerStyle),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDifficultyChip('Easy', easy, Colors.green),
                _buildDifficultyChip('Medium', medium, Colors.orange),
                _buildDifficultyChip('Hard', hard, Colors.red),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Helper method to build Difficulty Chips
  Widget _buildDifficultyChip(String label, int count, Color color) {
    return Column(
      children: [
        Chip(
          label: Text(
            '$label: $count',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: color,
        ),
      ],
    );
  }
}

