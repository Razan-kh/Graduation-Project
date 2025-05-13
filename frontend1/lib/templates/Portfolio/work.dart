// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:http/http.dart' as http;

// class WorkExperienceSection extends StatefulWidget {
//   final String token;
//     final bool isEditing;
//         final Function(Function()) registerSaveCallback;
//   const WorkExperienceSection({super.key, required this.token,required this.isEditing,required this.registerSaveCallback});
//   @override
//   _WorkExperienceSectionState createState() => _WorkExperienceSectionState();
// }

// class _WorkExperienceSectionState extends State<WorkExperienceSection> {
//   List<WorkExperience> experiences = [];

  
//   List<TextEditingController> companyNameControllers = [];
//   List<TextEditingController> roleControllers = [];
//   List<TextEditingController> descriptionControllers = [];
//   List<TextEditingController> skillsControllers = [];
//   List<DateTime?> startDateControllers = [];
//   List<DateTime?> endDateControllers = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchWorkExperience();
//             widget.registerSaveCallback(saveData);

//   }

//    void saveData() {
//     print("data save in work Section");
// updatePortfolioWork();
//     /*
//    // Replace with actual database logic
//     */
//   }
//   Future<void> updatePortfolioWork() async {
//   final String apiUrl = 'http://$localhost/api/portfolio/work-experience';

//   try {
//     // Convert experiences to JSON
//     List<Map<String, dynamic>> workExperienceJson =
//         experiences.map((work) => work.toJson()).toList();

//     // Make the API call
//     final response = await http.put(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${widget.token}',
//       },
//       body: json.encode({'workExperience': workExperienceJson}),
//     );

//     if (response.statusCode == 200) {
//       print('Work experience updated successfully.');
//     } else {
//       print('Failed to update work: ${response.body}');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }

//   // Fetch work experience from the backend API
//   Future<void> fetchWorkExperience() async {
//     final response = await http.get(
//       Uri.parse('http://$localhost/api/portfolio/work-experience'), // Replace with your backend URL
//       headers: {
//         'Authorization':'Bearer ${widget.token}', // Include the JWT token
//       },
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       setState(() {
//         experiences = data
//             .map((item) => WorkExperience.fromJson(item))
//             .toList();
//                _initializeControllers(); 
//       });
   
//     } else {
//       // Handle error response
//       print('Failed to load work experience');
//     }
//   }
//   void _initializeControllers() {
//     for (var experience in experiences) {
//       companyNameControllers.add(TextEditingController(text: experience.companyName));
//       roleControllers.add(TextEditingController(text: experience.role));
//       descriptionControllers.add(TextEditingController(text: experience.description));
//       skillsControllers.add(TextEditingController(text: experience.skills.join(', ')));
//       startDateControllers.add(experience.startDate);
//       endDateControllers.add(experience.endDate);
//     }
//   }

//   Widget _buildPreviewMode() {
//     return Column(
//       children: experiences.map((experience) {
//         return Card(
//           margin: EdgeInsets.all(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(experience.companyName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 8),
//                 Text(experience.role),
//                 SizedBox(height: 8),
//                 Text('${experience.startDate.month}/${experience.startDate.year} - ${experience.endDate != null ? "${experience.endDate!.month}/${experience.endDate!.year}" : "Present"}'),
//                 SizedBox(height: 8),
//                 Text(experience.description),
//                 SizedBox(height: 8),
//                 Text('Skills: ${experience.skills.join(', ')}'),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//  void _showDeleteConfirmationDialog(int index) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete Work Experience'),
//         content: Text('Are you sure you want to delete this work experience?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               _deleteWorkExperience(index);
//               Navigator.pop(context);
//             },
//             child: Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEditMode() {
//     return Column(
//       children:[
//       ElevatedButton(
//               onPressed: _addWorkExperience,
//               child: Text('Add Work Experience'),
//             ),
//        ...experiences.asMap().entries.map((entry) {
//         int index = entry.key;
//         WorkExperience experience = entry.value;

//         return GestureDetector(
//           onLongPress: () => _showDeleteConfirmationDialog(index),
//           child: Card(
//             margin: EdgeInsets.all(16),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextField(
//                     controller: companyNameControllers[index],
//                     decoration: InputDecoration(labelText: 'Company Name'),
//                     onChanged: (value) {
//                   setState(() {
//                    experiences[index].companyName = value;
//                   });
//                 },
//                   ),
//                   SizedBox(height: 8),
//                   TextField(
//                     controller: roleControllers[index],
//                     decoration: InputDecoration(labelText: 'Role'),
//                      onChanged: (value) {
//                   setState(() {
//                    experiences[index].role = value;
//                   });
//                 },
//                   ),
//                   SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: () => _selectDate(context, index, true),
//                     child: AbsorbPointer(
//                       child: TextField(
//                         controller: TextEditingController(text: '${startDateControllers[index]?.month ?? ''}/${startDateControllers[index]?.year ?? ''}'),
//                         decoration: InputDecoration(labelText: 'Start Date'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: () => _selectDate(context, index, false),
//                     child: AbsorbPointer(
//                       child: TextField(
//                         controller: TextEditingController(text: '${endDateControllers[index]?.month ?? ''}/${endDateControllers[index]?.year ?? ''}'),
//                         decoration: InputDecoration(labelText: 'End Date'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   TextField(
//                     controller: descriptionControllers[index],
//                     decoration: InputDecoration(labelText: 'Description'),
//                      onChanged: (value) {
//                   setState(() {
//                    experiences[index].description = value;
//                   });
//                 },
//                   ),
//                   SizedBox(height: 8),
//                   TextField(
//                     controller: skillsControllers[index],
//                     decoration: InputDecoration(labelText: 'Skills (comma-separated)'),
//                      onChanged: (value) {
//                   setState(() {
//                    experiences[index].skills = value.split(',').map((s) => s.trim()).toList();
//                   });
//                 },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//       ]
//     );
//   }
//     // Add a new work experience
//   void _addWorkExperience() {
//     setState(() {
//       experiences.add(WorkExperience(
//         companyName: '',
//         role: '',
//         startDate: DateTime.now(),
//         description: '',
//         skills: [],
//         endDate: null,
//       ));

//       // Add new controllers for editing the new experience
//       companyNameControllers.add(TextEditingController());
//       roleControllers.add(TextEditingController());
//       descriptionControllers.add(TextEditingController());
//       skillsControllers.add(TextEditingController());
//       startDateControllers.add(DateTime.now());
//       endDateControllers.add(null);
//     });
//   }

//   // Delete a work experience item
//   void _deleteWorkExperience(int index) {
//     setState(() {
//       experiences.removeAt(index);
//       companyNameControllers.removeAt(index);
//       roleControllers.removeAt(index);
//       descriptionControllers.removeAt(index);
//       skillsControllers.removeAt(index);
//       startDateControllers.removeAt(index);
//       endDateControllers.removeAt(index);
//     });
//   }

//   void _selectDate(BuildContext context, int index, bool isStartDate) async {
//     DateTime initialDate = isStartDate ? startDateControllers[index]! : endDateControllers[index]!;
//     final DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (selectedDate != null) {
//       setState(() {
//         if (isStartDate) {
//           startDateControllers[index] = selectedDate;
//           experiences[index].startDate=selectedDate;
//         } else {
//           endDateControllers[index] = selectedDate;
//           experiences[index].endDate=selectedDate;
//         }
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//    return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: widget.isEditing ? _buildEditMode() : _buildPreviewMode(),
//     );
   
//   }
// }

// class WorkExperience {
//   String companyName;
//   String role;
//   DateTime startDate;
//   DateTime? endDate;
//   String description;
//   List<String> skills;

//   WorkExperience({
//     required this.companyName,
//     required this.role,
//     required this.startDate,
//     this.endDate,
//     required this.description,
//     required this.skills,
//   });

//   factory WorkExperience.fromJson(Map<String, dynamic> json) {
//     return WorkExperience(
//       companyName: json['companyName'],
//       role: json['role'],
//       startDate: DateTime.parse(json['startDate']),
//       endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
//       description: json['description'],
//       skills: List<String>.from(json['skills']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'companyName': companyName,
//       'role': role,
//       'startDate': startDate.toIso8601String(),
//       'endDate': endDate?.toIso8601String(),
//       'description': description,
//       'skills': skills,
//     };
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class WorkExperienceSection extends StatefulWidget {
  final String token;
  final bool isEditing;
  final Function(Function()) registerSaveCallback;

  const WorkExperienceSection({
    super.key,
    required this.token,
    required this.isEditing,
    required this.registerSaveCallback,
  });

  @override
  _WorkExperienceSectionState createState() => _WorkExperienceSectionState();
}

class _WorkExperienceSectionState extends State<WorkExperienceSection> {
  List<WorkExperience> experiences = [];

  // Controllers for editing
  List<TextEditingController> companyNameControllers = [];
  List<TextEditingController> roleControllers = [];
  List<TextEditingController> descriptionControllers = [];
  List<TextEditingController> skillsControllers = [];
  List<DateTime?> startDateControllers = [];
  List<DateTime?> endDateControllers = [];

  @override
  void initState() {
    super.initState();
    fetchWorkExperience();
    // Register the save callback so the parent can trigger saving
    widget.registerSaveCallback(saveData);
  }

  /// Method to be called when the parent triggers a save.
  void saveData() {
    print("Saving data from Work Experience Section...");
    updatePortfolioWork();
  }

  /// Update the work experience on the server.
  Future<void> updatePortfolioWork() async {
    final String apiUrl = 'http://$localhost/api/portfolio/work-experience';

    try {
      // Convert experiences to JSON
      List<Map<String, dynamic>> workExperienceJson =
          experiences.map((work) => work.toJson()).toList();

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({'workExperience': workExperienceJson}),
      );

      if (response.statusCode == 200) {
        print('Work experience updated successfully.');
      } else {
        print('Failed to update work: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Fetch work experience from the backend API.
  Future<void> fetchWorkExperience() async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/portfolio/work-experience'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        experiences = data.map((item) => WorkExperience.fromJson(item)).toList();
        _initializeControllers();
      });
    } else {
      print('Failed to load work experience');
    }
  }

  /// Initialize controllers for each existing experience.
  void _initializeControllers() {
    for (var experience in experiences) {
      companyNameControllers.add(
        TextEditingController(text: experience.companyName),
      );
      roleControllers.add(
        TextEditingController(text: experience.role),
      );
      descriptionControllers.add(
        TextEditingController(text: experience.description),
      );
      skillsControllers.add(
        TextEditingController(text: experience.skills.join(', ')),
      );
      startDateControllers.add(experience.startDate);
      endDateControllers.add(experience.endDate);
    }
  }

  /// Build the preview (read-only) mode for the WorkExperience section.
  Widget _buildPreviewMode(TextStyle headerStyle, TextStyle subHeaderStyle, TextStyle bodyStyle) {
    if (experiences.isEmpty) {
      return Center(
        child: Text(
          'No work experiences added yet.',
          style: bodyStyle,
        ),
      );
    }

    return Column(
      children: experiences.map((experience) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Name
                Text(
                  experience.companyName,
                  style: headerStyle.copyWith(fontSize: 18),
                ),
                SizedBox(height: 4),
                // Role
                Text(
                  experience.role,
                  style: subHeaderStyle,
                ),
                SizedBox(height: 8),
                // Dates
                Text(
                  '${_formatDate(experience.startDate)} - ${experience.endDate != null ? _formatDate(experience.endDate!) : "Present"}',
                  style: bodyStyle.copyWith(color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                // Description
                Text(
                  experience.description,
                  style: bodyStyle,
                ),
                SizedBox(height: 8),
                // Skills
                Text(
                  'Skills: ${experience.skills.join(', ')}',
                  style: bodyStyle.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Confirmation dialog for deleting a Work Experience item.
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Work Experience', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete this work experience?',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.montserrat(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              _deleteWorkExperience(index);
              Navigator.pop(context);
            },
            child: Text('Delete', style: GoogleFonts.montserrat(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Build the edit mode for the WorkExperience section.
  Widget _buildEditMode(TextStyle bodyStyle, TextStyle hintStyle, TextStyle labelStyle) {
    return Column(
      children: [
        // "Add Work Experience" button
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _addWorkExperience,
            icon: Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            label: Text(
              'Add Work Experience',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 16),

        // List of experiences (editable)
        ...experiences.asMap().entries.map((entry) {
          int index = entry.key;
          WorkExperience experience = entry.value;

          return GestureDetector(
            // Long press to delete
            onLongPress: () => _showDeleteConfirmationDialog(index),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Name
                    TextField(
                      controller: companyNameControllers[index],
                      style: bodyStyle,
                      decoration: InputDecoration(
                        labelText: 'Company Name',
                        labelStyle: labelStyle,
                        hintStyle: hintStyle,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          experiences[index].companyName = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),

                    // Role
                    TextField(
                      controller: roleControllers[index],
                      style: bodyStyle,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        labelStyle: labelStyle,
                        hintStyle: hintStyle,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          experiences[index].role = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),

                    // Start Date
                    GestureDetector(
                      onTap: () => _selectDate(context, index, true),
                      child: AbsorbPointer(
                        child: TextField(
                          style: bodyStyle,
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                            labelStyle: labelStyle,
                            hintStyle: hintStyle,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          controller: TextEditingController(
                            text: _formatDate(startDateControllers[index]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // End Date
                    GestureDetector(
                      onTap: () => _selectDate(context, index, false),
                      child: AbsorbPointer(
                        child: TextField(
                          style: bodyStyle,
                          decoration: InputDecoration(
                            labelText: 'End Date',
                            labelStyle: labelStyle,
                            hintStyle: hintStyle,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          controller: TextEditingController(
                            text: endDateControllers[index] == null
                                ? ''
                                : _formatDate(endDateControllers[index]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Description
                    TextField(
                      controller: descriptionControllers[index],
                      style: bodyStyle,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: labelStyle,
                        hintStyle: hintStyle,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          experiences[index].description = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),

                    // Skills
                    TextField(
                      controller: skillsControllers[index],
                      style: bodyStyle,
                      decoration: InputDecoration(
                        labelText: 'Skills (comma-separated)',
                        labelStyle: labelStyle,
                        hintStyle: hintStyle,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          experiences[index].skills =
                              value.split(',').map((s) => s.trim()).toList();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Add a new (blank) work experience
  void _addWorkExperience() {
    setState(() {
      experiences.add(
        WorkExperience(
          companyName: '',
          role: '',
          startDate: DateTime.now(),
          description: '',
          skills: [],
          endDate: null,
        ),
      );

      // Add new controllers
      companyNameControllers.add(TextEditingController());
      roleControllers.add(TextEditingController());
      descriptionControllers.add(TextEditingController());
      skillsControllers.add(TextEditingController());
      startDateControllers.add(DateTime.now());
      endDateControllers.add(null);
    });
  }

  /// Delete a work experience item
  void _deleteWorkExperience(int index) {
    setState(() {
      experiences.removeAt(index);
      companyNameControllers.removeAt(index);
      roleControllers.removeAt(index);
      descriptionControllers.removeAt(index);
      skillsControllers.removeAt(index);
      startDateControllers.removeAt(index);
      endDateControllers.removeAt(index);
    });
  }

  /// Open a DatePicker to select a start or end date
  void _selectDate(BuildContext context, int index, bool isStartDate) async {
    // If we don't have a date yet, default to 'now'
    DateTime initialDate =
        isStartDate ? (startDateControllers[index] ?? DateTime.now()) : (endDateControllers[index] ?? DateTime.now());

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          startDateControllers[index] = selectedDate;
          experiences[index].startDate = selectedDate;
        } else {
          endDateControllers[index] = selectedDate;
          experiences[index].endDate = selectedDate;
        }
      });
    }
  }

  /// Helper to format date as M/YYYY (e.g. 3/2023)
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Define text styles here to align with the rest of your template
    final TextStyle headerStyle = GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black87,
    );

    final TextStyle subHeaderStyle = GoogleFonts.montserrat(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: Colors.grey[700],
    );

    final TextStyle bodyStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.black87,
    );

    final TextStyle hintStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[400],
    );

    final TextStyle labelStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[700],
      fontWeight: FontWeight.w500,
    );

    return Container(
      // Use a background color similar to your other templates
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // Switch between preview and edit mode
        child: widget.isEditing
            ? _buildEditMode(bodyStyle, hintStyle, labelStyle)
            : _buildPreviewMode(headerStyle, subHeaderStyle, bodyStyle),
      ),
    );
  }
}

/// Model class for work experience
class WorkExperience {
  String companyName;
  String role;
  DateTime startDate;
  DateTime? endDate;
  String description;
  List<String> skills;

  WorkExperience({
    required this.companyName,
    required this.role,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.skills,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      companyName: json['companyName'],
      role: json['role'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      description: json['description'],
      skills: List<String>.from(json['skills']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'role': role,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
      'skills': skills,
    };
  }
}
