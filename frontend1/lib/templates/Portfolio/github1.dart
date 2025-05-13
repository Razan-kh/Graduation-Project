// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:http/http.dart' as http;
// import 'package:syncfusion_flutter_charts/charts.dart';

// class GitHubStatsScreen extends StatefulWidget {

//    final bool isEditing;
//    final String token;
//       final Function(Function()) registerSaveCallback;
//    const GitHubStatsScreen({super.key, required this.isEditing,required this.registerSaveCallback,required this.token});
//   @override
//   _GitHubStatsScreenState createState() => _GitHubStatsScreenState();
// }

// class _GitHubStatsScreenState extends State<GitHubStatsScreen> {
 

//   Map<String, dynamic> profileData = {};
//   Map<String, int> languageData = {};
//   int pullRequestsOpened = 0;
//   int pullRequestsMerged = 0;
//   int issuesOpened = 0;
//   int issuesResolved = 0;

//   bool isLoading = true;
// bool isVisible=true;

//  final TextEditingController _controller = TextEditingController();

//  String username="";
//   @override
//   void initState() {
//     super.initState();
//         widget.registerSaveCallback(saveData);
//         getGithubProfile();
    
      
  
//   }
//    void saveData() {
//     print("data save in Github Section");
// updateGithubProfile();
//   }


//   // The base URL of your backend API


//   // Function to fetch GitHub profile and visibility by userId
//   Future<Map<String, dynamic>> getGithubProfile() async {
//       final String baseUrl = 'http://$localhost/api/portfolio/gitHub';
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
//           isVisible=data['showGithubProfile'];
// username= data['githubProfile'];
//   _controller.text=username;
//      fetchGitHubData();
//         });
//         return {
//           'githubProfile': data['githubProfile'],
//           'showGithubProfile': data['showGithubProfile'],
//         };
//       } else {
//         throw Exception('Failed to load GitHub profile');
//       }
//     } catch (error) {
//       throw Exception('Error fetching GitHub profile: $error');
//     }
//   }

//   // Function to update GitHub profile and visibility
//   Future<bool> updateGithubProfile() async {
//        const String apiUrl = 'http://$localhost/api/edit-github-profile'; // Replace with your API URL

//     try {
//       final response = await http.put(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//            'Authorization':'Bearer ${widget.token}'
//         },
//         body: json.encode({
//           'githubProfile':_controller.text ,
//           'showGithubProfile': isVisible,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // Successfully updated the profile
//         return true;
//       } else {
//         // If the response code is not 200, print error and return false
//         print('Failed to update Github: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       // Handle any error during the request
//       print('Error: $e');
//       return false;
//     }
//   }


// Widget editMode()
// {
//   return Padding(
//         padding: const EdgeInsets.all(16.0),
//      child:   Column(children: [
//         Text(
//           "Edit Github Username",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 20),
//               Row(
//           children: [
//                 Expanded(
//        child: TextField(
//         onEditingComplete:(){
//           username= _controller.text;
//         },
//           controller: _controller,
//           decoration: InputDecoration(
//             labelText: "Github Username",
//             hintText: "Enter your Github username",
//             border: OutlineInputBorder(),
//             prefixIcon: Icon(Icons.link),
            
//           ),
//         ),
//                 ),
           
//             SizedBox(width: 10),
           
//           ],
//         ),
//          ElevatedButton(   ///for toggle the visibility
//               onPressed: () {
//                 setState(() {
//                   isVisible = !isVisible; // Toggle the visibility
//                 });
//               },
//               child: Text(isVisible ? 'Hide Github' : 'Show Github'),
//             ),
//           ],
//           ),
//       );
// }
//   Future<void> fetchGitHubData() async {
//     try {
//       final profileResponse = await http.get(Uri.parse('https://api.github.com/users/$username'));
//       final reposResponse = await http.get(Uri.parse('https://api.github.com/users/$username/repos'));
//       final issuesResponse = await http.get(Uri.parse('https://api.github.com/search/issues?q=author:$username'));

//       if (profileResponse.statusCode == 200 &&
//           reposResponse.statusCode == 200 &&
//           issuesResponse.statusCode == 200) {
//         final profileJson = json.decode(profileResponse.body);
//         final reposJson = json.decode(reposResponse.body);
//         final issuesJson = json.decode(issuesResponse.body);

//         int mergedCount = 0;
//         int openedIssues = 0;
//         int resolvedIssues = 0;
//         Map<String, int> langData = {};

//         for (var repo in reposJson) {
//           final langResponse = await http.get(Uri.parse(repo['languages_url']));
//           if (langResponse.statusCode == 200) {
//             final langJson = json.decode(langResponse.body);
//             langJson.forEach((key, value) {
//               langData[key] = (langData[key] ?? 0) + value as int;
//             });
//           }
//           else{
//             print(langResponse.statusCode);
//                 final langJson = json.decode(langResponse.body);
//                 print(langJson);

//           }

//           final prResponse = await http.get(Uri.parse(repo['pulls_url'].split('{')[0]));
//           if (prResponse.statusCode == 200) {
//             final prJson = json.decode(prResponse.body);
//             mergedCount += prJson.where((pr) => pr['merged_at'] != null).length as int;
//           }
//         }

//         for (var issue in issuesJson['items']) {
//           if (issue['state'] == 'open') {
//             openedIssues++;
//           } else if (issue['state'] == 'closed') {
//             resolvedIssues++;
//           }
//         }

//         setState(() {
//           profileData = profileJson;
//           languageData = langData;
//           pullRequestsOpened = issuesJson['total_count'];
//           pullRequestsMerged = mergedCount;
//           issuesOpened = openedIssues;
//           issuesResolved = resolvedIssues;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         print("status code ${reposResponse.statusCode}");
//         throw Exception('Failed to load GitHub data.');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error fetching GitHub data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//      return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: widget.isEditing ? editMode() : 
//       isVisible? 
//        Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                    _buildProfileSection(),
//                     SizedBox(height: 20),
//                     _buildLanguageChart(),
//                     SizedBox(height: 20),
//                    _buildPRAndIssueStats(),
//                   ],
//                 )
//                 :
//                 SizedBox()
  
//     );
//     /*
//     return Material(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                    _buildProfileSection(),
//                     SizedBox(height: 20),
//                     _buildLanguageChart(),
//                     SizedBox(height: 20),
//                    _buildPRAndIssueStats(),
//                   ],
//                 ),
//               ),
//             );
//             */
  
//   }

//   Widget _buildProfileSection() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//      child:Padding(
     
//       padding: const EdgeInsets.all(16.0),
      
//      child:Column(
//           mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           'Profile Overview',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Text('Total Stars: ${profileData['public_gists'] ?? 0}'),
//         Text('Total Forks: ${profileData['public_repos'] ?? 0}'),
//         Text('Followers: ${profileData['followers'] ?? 0}'),
//         Text('Public Repositories: ${profileData['public_repos'] ?? 0}'),
//       ],
//       ),
//      ),
//     );
//   }

//   Widget _buildLanguageChart() {
//    // fetchGitHubData();
//     final data = languageData.entries.map((entry) {
//       final percentage = (entry.value / languageData.values.reduce((a, b) => a + b)) * 100;
//       return _LanguageData(entry.key, percentage);
//     }).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Top Languages',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         SizedBox(
//           height: 300,
//           child:isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : 
//            SfCircularChart(
//             legend: Legend(
//               isVisible: true,
//               position: LegendPosition.right,
//               overflowMode: LegendItemOverflowMode.wrap,
//               textStyle: TextStyle(fontSize: 14),
//             ),
//             tooltipBehavior: TooltipBehavior(enable: true),
//             series: <CircularSeries>[
//               PieSeries<_LanguageData, String>(
//                 dataSource: data,
//                 xValueMapper: (item, _) => item.language,
//                 yValueMapper: (item, _) => item.percentage,
//                 dataLabelMapper: (item, _) => '${item.percentage.toStringAsFixed(1)}%',
//                 dataLabelSettings: DataLabelSettings(isVisible: true),
//                 explode: true,
//                 explodeIndex: 0,
//                 enableTooltip: true,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPRAndIssueStats() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Pull Requests & Issues',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Text('Pull Requests Opened: $pullRequestsOpened'),
//         Text('Pull Requests Merged: $pullRequestsMerged'),
//         Text('Issues Opened: $issuesOpened'),
//         Text('Issues Resolved: $issuesResolved'),
//       ],
//     );
//   }
// }

// class _LanguageData {
//   final String language;
//   final double percentage;

//   _LanguageData(this.language, this.percentage);
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';

class GitHubStatsScreen extends StatefulWidget {
  final bool isEditing;
  final String token;
  final Function(Function()) registerSaveCallback;

  const GitHubStatsScreen({
    super.key,
    required this.isEditing,
    required this.registerSaveCallback,
    required this.token,
  });

  @override
  _GitHubStatsScreenState createState() => _GitHubStatsScreenState();
}

class _GitHubStatsScreenState extends State<GitHubStatsScreen> {
  Map<String, dynamic> profileData = {};
  Map<String, int> languageData = {};
  int pullRequestsOpened = 0;
  int pullRequestsMerged = 0;
  int issuesOpened = 0;
  int issuesResolved = 0;

  bool isLoading = true;
  bool isVisible = true;

  final TextEditingController _controller = TextEditingController();
  String username = "";

  @override
  void initState() {
    super.initState();
    widget.registerSaveCallback(saveData);
    getGithubProfile();
  }

  void saveData() {
    print("Saving data in GitHub Section...");
    updateGithubProfile();
  }

  /// Fetch GitHub Profile from your backend
  Future<Map<String, dynamic>> getGithubProfile() async {
    final String baseUrl = 'http://$localhost/api/portfolio/gitHub';
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
          isVisible = data['showGithubProfile'];
          username = data['githubProfile'];
          _controller.text = username;
          fetchGitHubData();
        });
        return {
          'githubProfile': data['githubProfile'],
          'showGithubProfile': data['showGithubProfile'],
        };
      } else {
        throw Exception('Failed to load GitHub profile');
      }
    } catch (error) {
      throw Exception('Error fetching GitHub profile: $error');
    }
  }

  /// Update GitHub Profile in your backend
  Future<bool> updateGithubProfile() async {
    const String apiUrl = 'http://$localhost/api/edit-github-profile';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'githubProfile': _controller.text,
          'showGithubProfile': isVisible,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update GitHub: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  /// Fetch public GitHub data via the GitHub API

  Future<void> fetchGitHubData() async {
    try {
      final profileResponse = await http.get(Uri.parse('https://api.github.com/users/${username}'));
      final reposResponse = await http.get(Uri.parse('https://api.github.com/users/${username}/repos'));
      final issuesResponse = await http.get(Uri.parse('https://api.github.com/search/issues?q=author:${username}'));

      if (profileResponse.statusCode == 200 &&
          reposResponse.statusCode == 200 &&
          issuesResponse.statusCode == 200) {
        final profileJson = json.decode(profileResponse.body);
        final reposJson = json.decode(reposResponse.body);
        final issuesJson = json.decode(issuesResponse.body);

        int mergedCount = 0;
        int openedIssues = 0;
        int resolvedIssues = 0;
        Map<String, int> langData = {};

        for (var repo in reposJson) {
          final langResponse = await http.get(Uri.parse(repo['languages_url']));
          if (langResponse.statusCode == 200) {
            final langJson = json.decode(langResponse.body);
            langJson.forEach((key, value) {
              langData[key] = (langData[key] ?? 0) + value as int;
            });
          }
          else{
            print(langResponse.statusCode);
                final langJson = json.decode(langResponse.body);
                print(langJson);

          }

          final prResponse = await http.get(Uri.parse(repo['pulls_url'].split('{')[0]));
          if (prResponse.statusCode == 200) {
            final prJson = json.decode(prResponse.body);
            mergedCount += prJson.where((pr) => pr['merged_at'] != null).length as int;
          }
        }

        for (var issue in issuesJson['items']) {
          if (issue['state'] == 'open') {
            openedIssues++;
          } else if (issue['state'] == 'closed') {
            resolvedIssues++;
          }
        }

        setState(() {
          profileData = profileJson;
          languageData = langData;
          pullRequestsOpened = issuesJson['total_count'];
          pullRequestsMerged = mergedCount;
          issuesOpened = openedIssues;
          issuesResolved = resolvedIssues;
          isLoading = false;
        });
      } else {
        if(mounted){
        setState(() {
          isLoading = false;
        });
        }
        print("status code ${reposResponse.statusCode}");
        throw Exception('Failed to load GitHub data.');
      }
    } catch (e) {
            if(mounted){
      setState(() {
        isLoading = false;
      });
            }
      print('Error fetching GitHub data: $e');
    }
  }


  /// --- EDIT MODE WIDGET ---
  Widget editMode(TextStyle bodyStyle, TextStyle labelStyle, TextStyle hintStyle) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Edit GitHub Username",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          // GitHub Username
          TextField(
            onEditingComplete: () => username = _controller.text,
            controller: _controller,
            style: bodyStyle,
            decoration: InputDecoration(
              labelText: "GitHub Username",
              labelStyle: labelStyle,
              hintText: "Enter your GitHub username",
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
          const SizedBox(height: 20),
          // Toggle Visibility
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
            child: Text(isVisible ? 'Hide GitHub' : 'Show GitHub',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  /// --- PREVIEW MODE WIDGET ---
  @override
  Widget build(BuildContext context) {
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

    // If not editing, we show the actual GitHub Stats (if visible)
    if (!isVisible) {
      return const SizedBox(); // If hidden, show nothing
    }

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Overview
                Text('Profile Overview', style: headerStyle),
                const SizedBox(height: 10),
                Text('Total Stars: ${profileData['public_gists'] ?? 0}',
                    style: bodyStyle),
                Text('Total Forks: ${profileData['public_repos'] ?? 0}',
                    style: bodyStyle),
                Text('Followers: ${profileData['followers'] ?? 0}',
                    style: bodyStyle),
                Text('Public Repositories: ${profileData['public_repos'] ?? 0}',
                    style: bodyStyle),
                const SizedBox(height: 20),

                // Language Chart
                Text('Top Languages', style: headerStyle),
                const SizedBox(height: 10),
                _buildLanguageChart(headerStyle),
                const SizedBox(height: 20),

                // PR & Issue Stats
                Text('Pull Requests & Issues', style: headerStyle),
                const SizedBox(height: 10),
                Text('Pull Requests Opened: $pullRequestsOpened',
                    style: bodyStyle),
                Text('Pull Requests Merged: $pullRequestsMerged',
                    style: bodyStyle),
                Text('Issues Opened: $issuesOpened', style: bodyStyle),
                Text('Issues Resolved: $issuesResolved', style: bodyStyle),
              ],
            ),
    );
  }

  Widget _buildLanguageChart(TextStyle headerStyle) {
    final data = languageData.entries.map((entry) {
      final totalLangValue =
          languageData.values.reduce((a, b) => a + b).toDouble();
      final percentage = (entry.value / totalLangValue) * 100;
      return _LanguageData(entry.key, percentage);
    }).toList();

    if (data.isEmpty) {
      return Text(
        'No language data found.',
        style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[700]),
      );
    }

    return SizedBox(
      height: 300,
      child: SfCircularChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.right,
          overflowMode: LegendItemOverflowMode.wrap,
          textStyle: GoogleFonts.montserrat(fontSize: 14),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CircularSeries>[
          PieSeries<_LanguageData, String>(
            dataSource: data,
            xValueMapper: (item, _) => item.language,
            yValueMapper: (item, _) => item.percentage,
            dataLabelMapper: (item, _) =>
                '${item.percentage.toStringAsFixed(1)}%',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            explode: true,
            explodeIndex: 0,
            enableTooltip: true,
          ),
        ],
      ),
    );
  }
}

class _LanguageData {
  final String language;
  final double percentage;

  _LanguageData(this.language, this.percentage);
}