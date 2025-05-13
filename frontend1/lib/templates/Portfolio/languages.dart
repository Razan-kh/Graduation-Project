import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// class LanguagesPage extends StatefulWidget {
//   final String token;
//   final bool isEditing;
//   final Function(Function()) registerSaveCallback;
//   const LanguagesPage({super.key, required this.token,required this.isEditing,required this.registerSaveCallback});

      

//   @override
//   _LanguagesPageState createState() => _LanguagesPageState();
// }
// class _LanguagesPageState extends State<LanguagesPage> {
//   List<dynamic> languages = [];
//   bool isLoading = true;

//   String newLanguageName = '';
// String newLanguageDescription = '';
// int newSpeakingProficiency = 0;
// int newReadingProficiency = 0;
// int newWritingProficiency = 0;
// int newListeningProficiency = 0;

//     @override
//   void initState() {
//     super.initState();
//     fetchLanguages();
//        widget.registerSaveCallback(saveData);
//   }
  
//   void saveData() {
//     print("data save in languages Section");
// sendLanguagesToBackend();
//     /*
//    // Replace with actual database logic
//     */
//   }

//   Future<void> fetchLanguages() async {
//     final url = 'http://$localhost/api/portfolio/Languages'; // Update with actual API endpoint
//     try {
//       final response = await http.get(Uri.parse(url),
//       headers: {'Authorization':'Bearer ${widget.token}'}
//       );
      
//       if (response.statusCode == 200) {
//         setState(() {
//           languages = json.decode(response.body);
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load languages');
//       }
//     } catch (e) {
//       print('Error fetching languages: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// Future<void> sendLanguagesToBackend() async {
//   final url = 'http://$localhost/api/portfolio/updateLanguages'; // Update with your actual API endpoint

//   final cleanedLanguages = languages.map((language) {
//     // Check if 'id' exists and rename it to '_id'
//     if (language['id'] != null) {
//       language['_id'] = language.remove('id'); // Rename 'id' to '_id'
//     }

//     // Remove 'id' if it's empty or null (this can prevent passing empty IDs)
//     if (language['_id'] == '' || language['_id'] == null) {
//       language.remove('_id');
//     }

//     return language;
//   }).toList();

//   print(cleanedLanguages); // Ensure that the cleaned languages are printed correctly for debugging.

//   try {
//     final response = await http.put(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer ${widget.token}',
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'languages': cleanedLanguages, // The entire array to be sent
//       }),
//     );

//     if (response.statusCode == 200) {
//       print('Languages successfully updated!');
//       // You can show a success message or navigate to another page
//     } else {
//       throw Exception('Failed to update languages');
//     }
//   } catch (e) {
//     print('Error sending languages to backend: $e');
//   }
// }


//   Widget _buildPreviewMode() {
//   return isLoading
//       ? Center(child: CircularProgressIndicator()) // Show loading spinner
//       : SingleChildScrollView( // Make it scrollable if the content is long
//           child: Column(
//             children: languages.map((language) {
//               return LanguageCard(
//                 languageName: language['languageName'],
//                 icon: _getIconFromName(language['icon']),
//                 speakingProficiency: language['speakingProficiency'],
//                 readingProficiency: language['readingProficiency'],
//                 writingProficiency: language['writingProficiency'],
//                 listeningProficiency: language['listeningProficiency'],
//                 description: language['description'],
//                 isEditMode: widget.isEditing,
//               );
//             }).toList(),
//           ),
//         );
// }
// Widget _buildEditMode() {
//   return isLoading 
//       ? Center(child: CircularProgressIndicator()) // Show loading spinner
//       : Column(
//           children: [
//             ElevatedButton(
//               onPressed: _addNewLanguage,
//               child: Text('Add Language'),
//             ),
//             ...languages.map((language) {
//               int index = languages.indexOf(language); // Find index of the language
//  return GestureDetector(
//                 onLongPress: () {
//                   // Delete the language when long-pressed
//                  _showDeleteConfirmationDialog(index);
//                 },
//               child: Card(
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextField(
//                         controller: TextEditingController(text: language['languageName']),
//                         decoration: InputDecoration(labelText: 'Language Name'),
//                         onChanged: (value) {
//                           language['languageName'] = value; // Update language name
//                         },
//                       ),
//                       SizedBox(height: 8),
//                       TextField(
//                         controller: TextEditingController(text: language['description']),
//                         decoration: InputDecoration(labelText: 'Description'),
//                         onChanged: (value) {
//                           language['description'] = value; // Update description
//                         },
//                       ),
//                       SizedBox(height: 8),
//                       // Skill Levels Input
//                       _buildSkillLevelInput(
//                         label: 'Speaking Proficiency',
//                         value: language['speakingProficiency'],
//                         onChanged: (value) {
//                           setState(() {
//                             language['speakingProficiency'] = int.tryParse(value) ?? 0;
//                           });
//                         },
//                       ),
//                       _buildSkillLevelInput(
//                         label: 'Reading Proficiency',
//                         value: language['readingProficiency'],
//                         onChanged: (value) {
//                           setState(() {
//                             language['readingProficiency'] = int.tryParse(value) ?? 0;
//                           });
//                         },
//                       ),
//                       _buildSkillLevelInput(
//                         label: 'Writing Proficiency',
//                         value: language['writingProficiency'],
//                         onChanged: (value) {
//                           setState(() {
//                             language['writingProficiency'] = int.tryParse(value) ?? 0;
//                           });
//                         },
//                       ),
//                       _buildSkillLevelInput(
//                         label: 'Listening Proficiency',
//                         value: language['listeningProficiency'],
//                         onChanged: (value) {
//                           setState(() {
//                             language['listeningProficiency'] = int.tryParse(value) ?? 0;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               );
//             }),
//           ],
//         );
// }

// void _showDeleteConfirmationDialog(int index) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Delete Language'),
//         content: Text('Are you sure you want to delete this language?'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               // If user cancels, close the dialog
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               // If user confirms, delete the language
//               setState(() {
//                 languages.removeAt(index);
//               });
//               Navigator.of(context).pop();
//             },
//             child: Text('Delete'),
//           ),
//         ],
//       );
//     },
//   );
// }
// Widget _buildSkillLevelInput({
//   required String label,
//   required int value,
//   required Function(String) onChanged,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//       TextField(
//         keyboardType: TextInputType.number,
//         controller: TextEditingController(text: value.toString()),
//         decoration: InputDecoration(hintText: 'Enter a value between 1 and 5'),
//         onChanged: onChanged,
//       ),
//       SizedBox(height: 8),
//     ],
//   );
// }

//   // Function to add a new language
 
// void _addNewLanguage() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Add New Language'),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Language Name'),
//                 onChanged: (value) {
//                   setState(() {
//                     newLanguageName = value;
//                   });
//                 },
//               ),
//               SizedBox(height: 8),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Description'),
//                 onChanged: (value) {
//                   setState(() {
//                     newLanguageDescription = value;
//                   });
//                 },
//               ),
//               SizedBox(height: 8),
//               _buildSkillLevelInput(
//                 label: 'Speaking Proficiency',
//                 value: newSpeakingProficiency,
//                 onChanged: (value) {
//                   setState(() {
//                     newSpeakingProficiency = int.tryParse(value) ?? 0;
//                   });
//                 },
//               ),
//               _buildSkillLevelInput(
//                 label: 'Reading Proficiency',
//                 value: newReadingProficiency,
//                 onChanged: (value) {
//                   setState(() {
//                     newReadingProficiency = int.tryParse(value) ?? 0;
//                   });
//                 },
//               ),
//               _buildSkillLevelInput(
//                 label: 'Writing Proficiency',
//                 value: newWritingProficiency,
//                 onChanged: (value) {
//                   setState(() {
//                     newWritingProficiency = int.tryParse(value) ?? 0;
//                   });
//                 },
//               ),
//               _buildSkillLevelInput(
//                 label: 'Listening Proficiency',
//                 value: newListeningProficiency,
//                 onChanged: (value) {
//                   setState(() {
//                     newListeningProficiency = int.tryParse(value) ?? 0;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 // Adding the new language to the list
//                 languages.add({
//                   'languageName': newLanguageName,
//                   'description': newLanguageDescription,
//                   'speakingProficiency': newSpeakingProficiency,
//                   'readingProficiency': newReadingProficiency,
//                   'writingProficiency': newWritingProficiency,
//                   'listeningProficiency': newListeningProficiency,
//                   'icon':'language',
//                   'id':""
        
//                 });
//               });
//               Navigator.of(context).pop();
//             },
//             child: Text('Add Language'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//         ],
//       );
//     },
//   );
// }

//   // Function to delete a language
//   void _deleteLanguage(String languageId) {
//     // Implement your logic for deleting a language
//     print('Deleting language with ID: $languageId');
//     setState(() {
//       languages.removeWhere((language) => language['id'] == languageId);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//    return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: widget.isEditing ? _buildEditMode() : _buildPreviewMode(),
  
//     );
//   }
//   }

//   IconData _getIconFromName(String iconName) {
//     switch (iconName) {
//       case 'language':
//         return Icons.language;
//       case 'flag':
//         return Icons.flag;
//       case 'flag_outlined':
//         return Icons.flag_outlined;
//       default:
//         return Icons.help_outline;
//     }
//   }


// class LanguageCard extends StatelessWidget {
//   final String languageName;
//   final IconData icon;
//   final int speakingProficiency;
//   final int readingProficiency;
//   final int writingProficiency;
//   final int listeningProficiency;
//   final String description;
//   final bool isEditMode;

//   const LanguageCard({super.key, 
//     required this.languageName,
//     required this.icon,
//     required this.speakingProficiency,
//     required this.readingProficiency,
//     required this.writingProficiency,
//     required this.listeningProficiency,
//     required this.description,
//     required this.isEditMode,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(15),
//         leading: Icon(icon, size: 40, color: Color(0xFF76c7c0)),
//         title: Text(
//           languageName,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (isEditMode) ...[
//               TextField(
//                 controller: TextEditingController(text: languageName),
//                 decoration: InputDecoration(labelText: 'Language Name'),
//               ),
//               TextField(
//                 controller: TextEditingController(text: description),
//                 decoration: InputDecoration(labelText: 'Description'),
//               ),
//             ],
//             if (!isEditMode) ...[
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _buildProficiencyStars('Speaking', speakingProficiency),
//                     _buildProficiencyStars('Reading', readingProficiency),
//                     _buildProficiencyStars('Writing', writingProficiency),
//                     _buildProficiencyStars('Listening', listeningProficiency),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Text(
//                   description,
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.7),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProficiencyStars(String category, int proficiency) {
//     int starCount = (proficiency / 20).ceil(); // Convert percentage to 1-5 stars
//     return Padding(
//       padding: const EdgeInsets.only(right: 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             category,
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//           Row(
//             children: List.generate(5, (index) {
//               return Icon(
//                 index < starCount ? Icons.star : Icons.star_border,
//                 color: Colors.amber,
//                 size: 20,
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
class LanguagesPage extends StatefulWidget {
  final String token;
  final bool isEditing;
  final Function(Function()) registerSaveCallback;

  const LanguagesPage({
    super.key,
    required this.token,
    required this.isEditing,
    required this.registerSaveCallback,
  });

  @override
  _LanguagesPageState createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  List<dynamic> languages = [];
  bool isLoading = true;

  // Temp fields for new language
  String newLanguageName = '';
  String newLanguageDescription = '';
  int newSpeakingProficiency = 0;
  int newReadingProficiency = 0;
  int newWritingProficiency = 0;
  int newListeningProficiency = 0;

  @override
  void initState() {
    super.initState();
    fetchLanguages();
    widget.registerSaveCallback(saveData);
  }

  void saveData() {
    print("Saving data in Languages Section...");
    sendLanguagesToBackend();
  }

  Future<void> fetchLanguages() async {
    final url = 'http://$localhost/api/portfolio/Languages';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          languages = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load languages');
      }
    } catch (e) {
      print('Error fetching languages: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendLanguagesToBackend() async {
    final url = 'http://$localhost/api/portfolio/updateLanguages';

    // Clean up data by renaming 'id' to '_id'
    final cleanedLanguages = languages.map((language) {
      if (language['id'] != null) {
        language['_id'] = language.remove('id');
      }
      if (language['_id'] == '' || language['_id'] == null) {
        language.remove('_id');
      }
      return language;
    }).toList();

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({'languages': cleanedLanguages}),
      );

      if (response.statusCode == 200) {
        print('Languages successfully updated!');
      } else {
        throw Exception('Failed to update languages');
      }
    } catch (e) {
      print('Error sending languages to backend: $e');
    }
  }

  /// --- PREVIEW MODE ---
  Widget _buildPreviewMode() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (languages.isEmpty) {
      return Center(
        child: Text(
          'No languages found.',
          style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[700]),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: languages.map((language) {
          return LanguageCard(
            languageName: language['languageName'],
            icon: _getIconFromName(language['icon']),
            speakingProficiency: language['speakingProficiency'],
            readingProficiency: language['readingProficiency'],
            writingProficiency: language['writingProficiency'],
            listeningProficiency: language['listeningProficiency'],
            description: language['description'],
            isEditMode: widget.isEditing,
          );
        }).toList(),
      ),
    );
  }

  /// --- EDIT MODE ---
  Widget _buildEditMode(
      TextStyle bodyStyle, TextStyle labelStyle, TextStyle hintStyle) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Add new language button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _addNewLanguage,
              icon: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              label: Text(
                'Add Language',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // List of existing languages
          ...languages.asMap().entries.map((entry) {
            final index = entry.key;
            final language = entry.value;

            return GestureDetector(
              onLongPress: () => _showDeleteConfirmationDialog(index),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildEditLanguageFields(
                    index,
                    language,
                    bodyStyle,
                    labelStyle,
                    hintStyle,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEditLanguageFields(
    int index,
    dynamic language,
    TextStyle bodyStyle,
    TextStyle labelStyle,
    TextStyle hintStyle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Language Name
        TextField(
          controller: TextEditingController(text: language['languageName']),
          style: bodyStyle,
          decoration: InputDecoration(
            labelText: 'Language Name',
            labelStyle: labelStyle,
            hintText: 'Enter language name',
            hintStyle: hintStyle,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            language['languageName'] = value;
          },
        ),
        const SizedBox(height: 8),

        // Description
        TextField(
          controller: TextEditingController(text: language['description']),
          style: bodyStyle,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Description',
            labelStyle: labelStyle,
            hintText: 'Enter a short description',
            hintStyle: hintStyle,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            language['description'] = value;
          },
        ),
        const SizedBox(height: 8),

        // Proficiency Inputs
        _buildSkillLevelInput(
          label: 'Speaking Proficiency',
          value: language['speakingProficiency'],
          onChanged: (val) {
            language['speakingProficiency'] = int.tryParse(val) ?? 0;
          },
          bodyStyle: bodyStyle,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
        ),
        _buildSkillLevelInput(
          label: 'Reading Proficiency',
          value: language['readingProficiency'],
          onChanged: (val) {
            language['readingProficiency'] = int.tryParse(val) ?? 0;
          },
          bodyStyle: bodyStyle,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
        ),
        _buildSkillLevelInput(
          label: 'Writing Proficiency',
          value: language['writingProficiency'],
          onChanged: (val) {
            language['writingProficiency'] = int.tryParse(val) ?? 0;
          },
          bodyStyle: bodyStyle,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
        ),
        _buildSkillLevelInput(
          label: 'Listening Proficiency',
          value: language['listeningProficiency'],
          onChanged: (val) {
            language['listeningProficiency'] = int.tryParse(val) ?? 0;
          },
          bodyStyle: bodyStyle,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Language',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete this language?',
            style: GoogleFonts.montserrat(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  languages.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: GoogleFonts.montserrat(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkillLevelInput({
    required String label,
    required int value,
    required Function(String) onChanged,
    required TextStyle bodyStyle,
    required TextStyle labelStyle,
    required TextStyle hintStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 4),
        TextField(
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: value.toString()),
          style: bodyStyle,
          decoration: InputDecoration(
            hintText: 'Enter a value between 1 and 5',
            hintStyle: hintStyle,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _addNewLanguage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Montserrat text styles
        final TextStyle labelStyle = GoogleFonts.montserrat(
          fontSize: 14,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        );
        final TextStyle hintStyle = GoogleFonts.montserrat(
          fontSize: 14,
          color: Colors.grey[400],
        );
        final TextStyle bodyStyle = GoogleFonts.montserrat(
          fontSize: 14,
          color: Colors.black87,
        );

        return AlertDialog(
          title: Text(
            'Add New Language',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Language Name
                TextField(
                  style: bodyStyle,
                  decoration: InputDecoration(
                    labelText: 'Language Name',
                    labelStyle: labelStyle,
                    hintStyle: hintStyle,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => newLanguageName = value,
                ),
                const SizedBox(height: 8),

                // Description
                TextField(
                  style: bodyStyle,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: labelStyle,
                    hintStyle: hintStyle,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => newLanguageDescription = value,
                ),
                const SizedBox(height: 8),

                // Speaking
                _buildDialogSkillLevelInput(
                  'Speaking Proficiency',
                  newSpeakingProficiency,
                  (val) {
                    newSpeakingProficiency = int.tryParse(val) ?? 0;
                  },
                  bodyStyle,
                  labelStyle,
                  hintStyle,
                ),
                // Reading
                _buildDialogSkillLevelInput(
                  'Reading Proficiency',
                  newReadingProficiency,
                  (val) {
                    newReadingProficiency = int.tryParse(val) ?? 0;
                  },
                  bodyStyle,
                  labelStyle,
                  hintStyle,
                ),
                // Writing
                _buildDialogSkillLevelInput(
                  'Writing Proficiency',
                  newWritingProficiency,
                  (val) {
                    newWritingProficiency = int.tryParse(val) ?? 0;
                  },
                  bodyStyle,
                  labelStyle,
                  hintStyle,
                ),
                // Listening
                _buildDialogSkillLevelInput(
                  'Listening Proficiency',
                  newListeningProficiency,
                  (val) {
                    newListeningProficiency = int.tryParse(val) ?? 0;
                  },
                  bodyStyle,
                  labelStyle,
                  hintStyle,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Add the new language
                setState(() {
                  languages.add({
                    'languageName': newLanguageName,
                    'description': newLanguageDescription,
                    'speakingProficiency': newSpeakingProficiency,
                    'readingProficiency': newReadingProficiency,
                    'writingProficiency': newWritingProficiency,
                    'listeningProficiency': newListeningProficiency,
                    'icon': 'language',
                    'id': "",
                  });
                });
                Navigator.of(context).pop();
              },
              child: Text('Add Language',
                  style: GoogleFonts.montserrat(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel',
                  style: GoogleFonts.montserrat(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogSkillLevelInput(
    String label,
    int value,
    Function(String) onChanged,
    TextStyle bodyStyle,
    TextStyle labelStyle,
    TextStyle hintStyle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 4),
        TextField(
          keyboardType: TextInputType.number,
          style: bodyStyle,
          decoration: InputDecoration(
            hintText: 'Enter a value between 1 and 5',
            hintStyle: hintStyle,
            border: const OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'language':
        return Icons.language;
      case 'flag':
        return Icons.flag;
      case 'flag_outlined':
        return Icons.flag_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Common text styles
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

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16.0),
      child: widget.isEditing
          ? _buildEditMode(bodyStyle, labelStyle, hintStyle)
          : _buildPreviewMode(),
    );
  }
}

// ------------------------------------------------------------------------ //
//                      LANGUAGE CARD (READ-ONLY VIEW)
// ------------------------------------------------------------------------ //

class LanguageCard extends StatelessWidget {
  final String languageName;
  final IconData icon;
  final int speakingProficiency;
  final int readingProficiency;
  final int writingProficiency;
  final int listeningProficiency;
  final String description;
  final bool isEditMode;

  const LanguageCard({
    super.key,
    required this.languageName,
    required this.icon,
    required this.speakingProficiency,
    required this.readingProficiency,
    required this.writingProficiency,
    required this.listeningProficiency,
    required this.description,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    final TextStyle bodyStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.black87,
    );
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue[100],
          child: Icon(icon, size: 24, color: Colors.blue),
        ),
        title: Text(languageName, style: titleStyle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isEditMode) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildProficiencyStars('Speaking', speakingProficiency),
                    const SizedBox(width: 20),
                    _buildProficiencyStars('Reading', readingProficiency),
                    const SizedBox(width: 20),
                    _buildProficiencyStars('Writing', writingProficiency),
                    const SizedBox(width: 20),
                    _buildProficiencyStars('Listening', listeningProficiency),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(description, style: bodyStyle),
            ],
            // If it's edit mode, the actual editing fields appear in _buildEditMode of the parent.
          ],
        ),
      ),
    );
  }

  Widget _buildProficiencyStars(String category, int proficiency) {
    // Convert numeric proficiency (1-5) into star rating
    final starCount = proficiency.clamp(0, 5); // Ensure it's within 0-5
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14)),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < starCount ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 20,
            );
          }),
        ),
      ],
    );

  }}