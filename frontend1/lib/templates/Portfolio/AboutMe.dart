// import 'package:flutter/material.dart';
// import 'package:frontend1/templates/Portfolio/FirstSection.dart';
// import 'package:frontend1/templates/Portfolio/Projects.dart';
// import 'package:frontend1/templates/Portfolio/certificates.dart';
// import 'package:frontend1/templates/Portfolio/contactIcons.dart';
// import 'package:frontend1/templates/Portfolio/github1.dart';
// import 'package:frontend1/templates/Portfolio/leetcode.dart';
// import 'package:frontend1/templates/Portfolio/work.dart';

// class AboutMeScreen extends StatefulWidget {
//   final String token;
//   const AboutMeScreen({super.key, required this.token});
//   @override
//   _AboutMeScreenState createState() => _AboutMeScreenState();
// }

// class _AboutMeScreenState extends State<AboutMeScreen> {
//   bool isEditing = false; // Tracks whether we are in edit mode
//   final List<Function()> saveCallbacks = [];

//   // Function to register callbacks
//   void registerSaveCallback(Function() callback) {
//     saveCallbacks.add(callback);
//   }

//   // Save button logic
//   void saveAllSections() {
//     for (var callback in saveCallbacks) {
//       callback(); // Notify each section to save data
//     }
//     print("All sections notified to save data.");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('About Me'),
//         actions: [
//           IconButton(
//             icon: Icon(isEditing ? Icons.preview : Icons.edit),
//             onPressed: () {
//               setState(() {
//                 isEditing = !isEditing; // Toggle between preview and edit
//               });
//             },
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body:
//       SingleChildScrollView(    
//         child:
//       Column(
//         children: [
//         Firstsection(isEditing:isEditing,token: widget.token,registerSaveCallback: registerSaveCallback,),
//     CertificationsAndEducationSection(token:widget.token,isEditing: isEditing,registerSaveCallback: registerSaveCallback),
//     WorkExperienceSection(token:widget.token,isEditing: isEditing,registerSaveCallback: registerSaveCallback),
//    //  LanguagesPage(token: widget.token,isEditing: isEditing,registerSaveCallback: registerSaveCallback),
//      //HobbiesPage(token:widget.token),
//      Align(
//       alignment: Alignment.centerLeft, // Aligns only this text to the left
//       child: Text(
//         'Projects',
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Optional: increase size
//       ),
//     ),
//     ProjectPortfolio(token:widget.token,isEditing: isEditing,registerSaveCallback: registerSaveCallback,),
//   GitHubStatsScreen(token: widget.token ,isEditing: isEditing,registerSaveCallback: registerSaveCallback),
//    //ContactSection(),
//   LeetCodeSection(token:widget.token ,isEditing:isEditing, registerSaveCallback: registerSaveCallback),
//   ContactIcons(isEditing:isEditing,token:widget.token,registerSaveCallback: registerSaveCallback) ,

// isEditing?
//        Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                saveAllSections();
//                setState(() {
//                  isEditing=!isEditing;
//                });
//                 },
//                 child: Text('Save'),

//               ),
//               OutlinedButton(
//                 onPressed: () {
//                 },
//                 child: Text('Cancel'),
//               ),
//             ],
//           ):
//           SizedBox()
   
//         ],
//       ),
//     ),
//     );
//   }

//   // Build Preview Mode
  

// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/Portfolio/FirstSection.dart';
import 'package:frontend1/templates/Portfolio/Projects.dart';
import 'package:frontend1/templates/Portfolio/certificates.dart';
import 'package:frontend1/templates/Portfolio/contactIcons.dart';
import 'package:frontend1/templates/Portfolio/github1.dart';
import 'package:frontend1/templates/Portfolio/leetcode.dart';
import 'package:frontend1/templates/Portfolio/work.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:frontend1/templates/sideBar.dart';

// ***************************** //
//      AboutMeScreen Widget     //
// ***************************** //

class AboutMeScreen extends StatefulWidget {
  final String token;
    final String templateId;
  AboutMeScreen({required this.token,required this.templateId});

  @override
  _AboutMeScreenState createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  bool isEditing = false; // Tracks whether we are in edit mode
  final List<Function()> saveCallbacks = [];

  // Function to register callbacks from child widgets
  void registerSaveCallback(Function() callback) {
    saveCallbacks.add(callback);
  }

  // Notifies all child widgets to save their data
  void saveAllSections() {
    for (var callback in saveCallbacks) {
      callback();
    }
    print("All sections notified to save data.");
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb=MediaQuery.of(context).size.width>1200? true: false;
      final String portfolioLink = "http://$localhost/api/portfolio/${widget.templateId}"; // Example link
    // Define text styles for the screen
    final TextStyle appBarTitleStyle = GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    final TextStyle sectionTitleStyle = GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
              automaticallyImplyLeading: false, 
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text('About Me', style: appBarTitleStyle),
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
           
          IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // Show sharing options
                    _showShareOptions( portfolioLink);
                  },
                ),
        
          IconButton(
            icon: Icon(isEditing ? Icons.preview : Icons.edit, color: Colors.black87),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            tooltip: isEditing ? 'Switch to Preview' : 'Edit',
          ),
        ],
      ),
      body: Row(
  children: [
      if (isWeb) WebSidebar(),
    if (isWeb) SizedBox(width: 100), // Spacer for web layout
   Expanded(
          flex: 5, // Adjust flex to allocate space proportionally
  
      child:  
       SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            // Firstsection, Cert, Work, etc. 
            // Provide each child the same styling approach

            // 1. Your Firstsection widget
            Firstsection(
              isEditing: isEditing,
              token: widget.token,
              registerSaveCallback: registerSaveCallback,
            ),

            // 2. Certifications/Education
               Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Certificates',
                  style: sectionTitleStyle,
                ),
              ),
            ),
            CertificationsAndEducationSection(
              token: widget.token,
              isEditing: isEditing,
              registerSaveCallback: registerSaveCallback,
            ),
   Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Work Experience',
                  style: sectionTitleStyle,
                ),
              ),
            ),
            // 3. Work Experience
            WorkExperienceSection(
              token: widget.token,
              isEditing: isEditing,
              registerSaveCallback: registerSaveCallback,
            ),

            // 4. Projects Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Projects',
                  style: sectionTitleStyle,
                ),
              ),
            ),

            // 5. Projects section
            ProjectPortfolio(
              token: widget.token,
              isEditing: isEditing,
              registerSaveCallback: registerSaveCallback,
            ),

            // 6. GitHub Stats
            GitHubStatsScreen(
              token: widget.token,
              isEditing: isEditing,
              registerSaveCallback: registerSaveCallback,
            ),

            // 7. LeetCode
            LeetCodeSection(
              token: widget.token,
              isEditing: isEditing,
              registerSaveCallback: registerSaveCallback,
            ),

            // 8. Contact Icons
            ContactIcons(
              isEditing: isEditing,
              token: widget.token,
              registerSaveCallback: registerSaveCallback,
            ),

            // Show Save/Cancel only in edit mode
            if (isEditing) 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Save Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        saveAllSections();
                        setState(() {
                          isEditing = false;
                        });
                      },
                      child: Text(
                        'Save',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Cancel Button
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: BorderSide(color: Colors.blue),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isEditing = false;
                        });
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
   ),
           if (isWeb) SizedBox(width: 100), // Spacer for web layout

  ]
   ),
    );
  
  }
  
  void _showShareOptions( String link)async {
   
      try {
  await  Share.share(link);
  }
   catch (e) {
    print(e);

  }
  }
}