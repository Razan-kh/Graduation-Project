import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// class CertificationAndEducation {
//    String title;
//    String institution;
//    DateTime issueDate;
//    DateTime? expiryDate;
//    String description;
//    List<String> skills;

//   CertificationAndEducation({
//     required this.title,
//     required this.institution,
//     required this.issueDate,
//     this.expiryDate,
//     required this.description,
//     required this.skills,
//   });

//   factory CertificationAndEducation.fromJson(Map<String, dynamic> json) {
//     return CertificationAndEducation(
//       title: json['title'],
//       institution: json['institution'],
//       issueDate: DateTime.parse(json['issueDate']),
//       expiryDate: json['expiryDate'] != null
//           ? DateTime.parse(json['expiryDate'])
//           : null,
//       description: json['description'],
//       skills: List<String>.from(json['skills']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'institution': institution,
//       'issueDate': issueDate.toIso8601String(),
//       'expiryDate': expiryDate?.toIso8601String(),
//       'description': description,
//       'skills': skills,
//     };
//   }
// }

// class CertificationsAndEducationSection extends StatefulWidget {
//     final bool isEditing;
//   final String token;
//      final Function(Function()) registerSaveCallback;
//   const CertificationsAndEducationSection({super.key, required this.isEditing,required this.token,required this.registerSaveCallback});

//   @override
//   _CertificationsAndEducationSectionState createState() =>
//       _CertificationsAndEducationSectionState();
// }

// class _CertificationsAndEducationSectionState
//     extends State<CertificationsAndEducationSection> {
//   List<CertificationAndEducation> certificationsAndEducation = [];

//    List<TextEditingController> titleControllers = [];
//   List<TextEditingController> institutionControllers = [];
//   List<TextEditingController> descriptionControllers = [];
//   List<TextEditingController> skillsControllers = [];
//   List<DateTime?> issueDates = [];
//   List<DateTime?> expiryDates = [];


//   @override
//   void initState() {
//     super.initState();
//     fetchCertifications();
//         widget.registerSaveCallback(saveData);
//     /*
//    if (widget.isEditing) {
//       // Initialize controllers with current values if editing
//       for (var item in certificationsAndEducation) {
//         titleControllers.add(TextEditingController(text: item.title));
//         institutionControllers.add(TextEditingController(text: item.institution));
//         descriptionControllers.add(TextEditingController(text: item.description));
//         skillsControllers.add(TextEditingController(text: item.skills.join(', ')));
//         issueDates.add(item.issueDate);
//         expiryDates.add(item.expiryDate);
//       }
//     }
//     */
//   }

//    void saveData() {
//     print("data save in certificate Section");
// updatePortfolioCertifications(certificationsAndEducation);
//     /*
//    // Replace with actual database logic
//     */
//   }
// Future<void> updatePortfolioCertifications(List<CertificationAndEducation> certifications) async {
//   final String apiUrl = 'http://$localhost/api/portfolio/certifications';

//   try {
//     // Convert certifications to JSON
//     List<Map<String, dynamic>> certificationsJson =
//         certifications.map((cert) => cert.toJson()).toList();

//     // Make the API call
//     final response = await http.put(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization':'Bearer ${widget.token}'
//       },
//       body: json.encode({'certifications': certificationsJson}),
//     );

//     if (response.statusCode == 200) {
//       print('certifications updated successfully.');
//     } else {
//       print('Failed to update portfolio: ${response.body}');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }



//  Future<void> _selectDate(BuildContext context, int index, bool isIssueDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isIssueDate ? issueDates[index]! : expiryDates[index] ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isIssueDate) {
//          certificationsAndEducation[index].issueDate = picked;
//         } else {
//           certificationsAndEducation[index].expiryDate = picked;
//         }
//       });
//     }
//   }

//   // Build Preview Mode
//   Widget _buildPreviewMode() {
//     return Column(
//       children: certificationsAndEducation.map((item) {
//         return Card(
//           margin: EdgeInsets.all(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.title,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text(item.institution),
//                 SizedBox(height: 8),
//                 Text(
//                   'Issued: ${item.issueDate.month}/${item.issueDate.year} - ${item.expiryDate != null ? "${item.expiryDate!.month}/${item.expiryDate!.year}" : "No Expiry"}',
//                 ),
//                 SizedBox(height: 8),
//                 Text(item.description),
//                 SizedBox(height: 8),
//                 Text('Skills: ${item.skills.join(', ')}'),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   // Build Edit Mode
//   Widget _buildEditMode() {
//   return Column(
//     children: [
//       // Button to add a new certificate
//       ElevatedButton(
//         onPressed: _addNewCertificate,
//         child: Text('Add Certificate'),
//       ),
//       SizedBox(height: 16),
      
//       // List of certificates with editing capabilities
//       ...certificationsAndEducation.asMap().entries.map((entry) {
//         int index = entry.key;
//         CertificationAndEducation item = entry.value;
        
//         return GestureDetector(
//           onLongPress: () => _confirmDeleteCertificate(context, index),// Detect long press to delete
//           child: Card(
//             margin: EdgeInsets.all(16),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextField(
//   controller: titleControllers[index],
//   decoration: InputDecoration(labelText: 'Title'),
//   onChanged: (value) {
//     setState(() {
//       certificationsAndEducation[index].title = value;
//     });
//   },
// ),

//                   SizedBox(height: 8),
//                 TextField(
//   controller: institutionControllers[index],
//   decoration: InputDecoration(labelText: 'Institution'),
//   onChanged: (value) {
//     setState(() {
//       certificationsAndEducation[index].institution = value;
//     });
//   },
// ),

//                   SizedBox(height: 8),
//                 GestureDetector(
//   onTap: () => _selectDate(context, index, true),
//   child: AbsorbPointer(
//     child: TextField(
//       controller: TextEditingController(
//         text: '${issueDates[index]?.month ?? ''}/${issueDates[index]?.year ?? ''}',
//       ),
//       decoration: InputDecoration(labelText: 'Issue Date'),
//     ),
//   ),
// ),

//                   SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: () => _selectDate(context, index, false),
//                     child: AbsorbPointer(
//                       child: TextField(
//                         controller: TextEditingController(
//                           text: '${expiryDates[index]?.month ?? ''}/${expiryDates[index]?.year ?? ''}',
//                         ),
//                         decoration: InputDecoration(labelText: 'Expiry Date'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   TextField(
//   controller: descriptionControllers[index],
//   decoration: InputDecoration(labelText: 'Description'),
//   onChanged: (value) {
//     setState(() {
//       certificationsAndEducation[index].description = value;
//     });
//   },
// ),

//                   SizedBox(height: 8),
//                  TextField(
//   controller: skillsControllers[index],
//   decoration: InputDecoration(labelText: 'Skills (comma-separated)'),
//   onChanged: (value) {
//     setState(() {
//       certificationsAndEducation[index].skills = value.split(',').map((s) => s.trim()).toList();
//     });
//   },
// ),

//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     ],
//   );
// }

// void _addNewCertificate() {
//   setState(() {
//     // Add a new certificate
//     certificationsAndEducation.add(CertificationAndEducation(
//       title: '',
//       institution: '',
//       issueDate: DateTime.now(),
//       expiryDate: null,
//       description: '',
//       skills: [],
//     ));

//     // Add new controllers for the new certificate
//     titleControllers.add(TextEditingController());
//     institutionControllers.add(TextEditingController());
//     descriptionControllers.add(TextEditingController());
//     skillsControllers.add(TextEditingController());
//     issueDates.add(DateTime.now());
//     expiryDates.add(null);
//   });
// }
// void _confirmDeleteCertificate(BuildContext context, int index) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Delete Certificate'),
//         content: Text('Are you sure you want to delete this certificate?'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog without doing anything
//             },
//             child: Text('No'),
//           ),
//           TextButton(
//             onPressed: () {
//               _deleteCertificate(index); // Delete the certificate
//               Navigator.of(context).pop(); // Close the dialog after deleting
//             },
//             child: Text('Yes'),
//           ),
//         ],
//       );
//     },
//   );
// }

// void _deleteCertificate(int index) {
//   setState(() {
//     // Remove the certificate at the given index
//     certificationsAndEducation.removeAt(index);
//     titleControllers.removeAt(index);
//     institutionControllers.removeAt(index);
//     descriptionControllers.removeAt(index);
//     skillsControllers.removeAt(index);
//     issueDates.removeAt(index);
//     expiryDates.removeAt(index);
//   });
// }

//   // Fetch certifications from the backend API
//   Future<void> fetchCertifications() async {
//     final response = await http.get(
//       Uri.parse('http://$localhost/api/portfolio/certifications'),
//   headers: {'Authorization': 'Bearer ${widget.token}'},
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       print(data);
//       setState(() {
//         certificationsAndEducation = data
//             .map((item) => CertificationAndEducation.fromJson(item))
//             .toList();
//       });

  
//           // Initialize controllers with current values if editing
//           for (var item in certificationsAndEducation) {
//             titleControllers.add(TextEditingController(text: item.title));
//             institutionControllers.add(TextEditingController(text: item.institution));
//             descriptionControllers.add(TextEditingController(text: item.description));
//             skillsControllers.add(TextEditingController(text: item.skills.join(', ')));
//             issueDates.add(item.issueDate);
//             expiryDates.add(item.expiryDate);
//           }
        
     
//   }
//      else {
//       // Handle error response
//       print('Failed to load certifications');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//       return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: widget.isEditing ? _buildEditMode() : _buildPreviewMode(),
//     );
//   }
//     }
//     /*
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isIssueDate) {
//           issueDate = picked;
//         } else {
//           expiryDate = picked;
//         }
//       });
//     }
//   }





  
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController institutionController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController skillsController = TextEditingController();
// */


class CertificationAndEducation {
  String title;
  String institution;
  DateTime issueDate;
  DateTime? expiryDate;
  String description;
  List<String> skills;

  CertificationAndEducation({
    required this.title,
    required this.institution,
    required this.issueDate,
    this.expiryDate,
    required this.description,
    required this.skills,
  });

  factory CertificationAndEducation.fromJson(Map<String, dynamic> json) {
    return CertificationAndEducation(
      title: json['title'],
      institution: json['institution'],
      issueDate: DateTime.parse(json['issueDate']),
      expiryDate:
          json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      description: json['description'],
      skills: List<String>.from(json['skills']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'institution': institution,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'description': description,
      'skills': skills,
    };
  }
}

class CertificationsAndEducationSection extends StatefulWidget {
  final bool isEditing;
  final String token;
  final Function(Function()) registerSaveCallback;

  const CertificationsAndEducationSection({
    super.key,
    required this.isEditing,
    required this.token,
    required this.registerSaveCallback,
  });

  @override
  _CertificationsAndEducationSectionState createState() =>
      _CertificationsAndEducationSectionState();
}

class _CertificationsAndEducationSectionState
    extends State<CertificationsAndEducationSection> {
  List<CertificationAndEducation> certificationsAndEducation = [];

  // Controllers
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> institutionControllers = [];
  List<TextEditingController> descriptionControllers = [];
  List<TextEditingController> skillsControllers = [];
  List<DateTime?> issueDates = [];
  List<DateTime?> expiryDates = [];

  @override
  void initState() {
    super.initState();
    fetchCertifications();
    widget.registerSaveCallback(saveData);
  }

  /// Called when parent triggers a save (via saveAllSections).
  void saveData() {
    print("Saving data in CertificationsAndEducationSection...");
    updatePortfolioCertifications(certificationsAndEducation);
  }

  /// Send updates to the backend.
  Future<void> updatePortfolioCertifications(
      List<CertificationAndEducation> certifications) async {
    final String apiUrl = 'http://$localhost/api/portfolio/certifications';

    try {
      List<Map<String, dynamic>> certificationsJson =
          certifications.map((cert) => cert.toJson()).toList();

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({'certifications': certificationsJson}),
      );

      if (response.statusCode == 200) {
        print('Certifications updated successfully.');
      } else {
        print('Failed to update certifications: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Fetch certifications from the backend
  Future<void> fetchCertifications() async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/portfolio/certifications'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        certificationsAndEducation =
            data.map((item) => CertificationAndEducation.fromJson(item)).toList();
      });

      // Initialize controllers
      for (var item in certificationsAndEducation) {
        titleControllers.add(TextEditingController(text: item.title));
        institutionControllers
            .add(TextEditingController(text: item.institution));
        descriptionControllers
            .add(TextEditingController(text: item.description));
        skillsControllers
            .add(TextEditingController(text: item.skills.join(', ')));
        issueDates.add(item.issueDate);
        expiryDates.add(item.expiryDate);
      }
    } else {
      print('Failed to load certifications');
    }
  }

  /// Builds the preview (read-only) mode
  Widget _buildPreviewMode(TextStyle headerStyle, TextStyle subHeaderStyle, TextStyle bodyStyle) {
    if (certificationsAndEducation.isEmpty) {
      return Center(
        child: Text(
          'No certifications or education records yet.',
          style: bodyStyle,
        ),
      );
    }

    return Column(
      children: certificationsAndEducation.map((item) {
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
                // Title
                Text(
                  item.title,
                  style: headerStyle.copyWith(fontSize: 18),
                ),
                SizedBox(height: 4),
                // Institution
                Text(
                  item.institution,
                  style: subHeaderStyle,
                ),
                SizedBox(height: 8),
                // Dates
                Text(
                  'Issued: ${_formatDate(item.issueDate)}'
                  ' - ${item.expiryDate != null ? _formatDate(item.expiryDate!) : "No Expiry"}',
                  style: bodyStyle.copyWith(color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                // Description
                Text(
                  item.description,
                  style: bodyStyle,
                ),
                SizedBox(height: 8),
                // Skills
                Text(
                  'Skills: ${item.skills.join(', ')}',
                  style: bodyStyle.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Builds the edit mode
  Widget _buildEditMode(TextStyle bodyStyle, TextStyle hintStyle, TextStyle labelStyle) {
    return Column(
      children: [
        // Add new certificate button
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _addNewCertificate,
            icon: Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            label: Text(
              'Add Certificate',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 16),

        // List of certifications
        ...certificationsAndEducation.asMap().entries.map((entry) {
          int index = entry.key;
          CertificationAndEducation item = entry.value;

          return GestureDetector(
            onLongPress: () => _confirmDeleteCertificate(context, index),
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
                    // Title
                    TextField(
                      controller: titleControllers[index],
                      style: bodyStyle,
                      decoration: InputDecoration(
                        labelText: 'Title',
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
                          certificationsAndEducation[index].title = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),

                    // Institution
                    TextField(
                      controller: institutionControllers[index],
                      style: bodyStyle,
                      decoration: InputDecoration(
                        labelText: 'Institution',
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
                          certificationsAndEducation[index].institution = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),

                    // Issue Date
                    GestureDetector(
                      onTap: () => _selectDate(context, index, true),
                      child: AbsorbPointer(
                        child: TextField(
                          style: bodyStyle,
                          decoration: InputDecoration(
                            labelText: 'Issue Date',
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
                            text: issueDates[index] == null
                                ? ''
                                : _formatDate(issueDates[index]!),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Expiry Date
                    GestureDetector(
                      onTap: () => _selectDate(context, index, false),
                      child: AbsorbPointer(
                        child: TextField(
                          style: bodyStyle,
                          decoration: InputDecoration(
                            labelText: 'Expiry Date',
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
                            text: expiryDates[index] == null
                                ? ''
                                : _formatDate(expiryDates[index]!),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Description
                    TextField(
                      controller: descriptionControllers[index],
                      style: bodyStyle,
                      maxLines: 2,
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
                          certificationsAndEducation[index].description = value;
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
                          certificationsAndEducation[index].skills =
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

  /// Adds a new empty certificate/education record
  void _addNewCertificate() {
    setState(() {
      certificationsAndEducation.add(
        CertificationAndEducation(
          title: '',
          institution: '',
          issueDate: DateTime.now(),
          expiryDate: null,
          description: '',
          skills: [],
        ),
      );
      // Add new controllers
      titleControllers.add(TextEditingController());
      institutionControllers.add(TextEditingController());
      descriptionControllers.add(TextEditingController());
      skillsControllers.add(TextEditingController());
      issueDates.add(DateTime.now());
      expiryDates.add(null);
    });
  }

  /// Confirm before deleting a certificate
  void _confirmDeleteCertificate(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Certificate',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete this certificate?',
            style: GoogleFonts.montserrat(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No', style: GoogleFonts.montserrat(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                _deleteCertificate(index);
                Navigator.of(context).pop();
              },
              child: Text('Yes', style: GoogleFonts.montserrat(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Deletes a certificate at the given index
  void _deleteCertificate(int index) {
    setState(() {
      certificationsAndEducation.removeAt(index);
      titleControllers.removeAt(index);
      institutionControllers.removeAt(index);
      descriptionControllers.removeAt(index);
      skillsControllers.removeAt(index);
      issueDates.removeAt(index);
      expiryDates.removeAt(index);
    });
  }

  /// Select a date from the DatePicker
  void _selectDate(BuildContext context, int index, bool isIssueDate) async {
    DateTime initialDate =
        isIssueDate ? (issueDates[index] ?? DateTime.now()) : (expiryDates[index] ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isIssueDate) {
          issueDates[index] = picked;
          certificationsAndEducation[index].issueDate = picked;
        } else {
          expiryDates[index] = picked;
          certificationsAndEducation[index].expiryDate = picked;
        }
      });
    }
  }

  /// Helper to format DateTime as M/YYYY
  String _formatDate(DateTime date) {
    return '${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Text styles for consistency
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
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.isEditing
            ? _buildEditMode(bodyStyle, hintStyle, labelStyle)
            : _buildPreviewMode(headerStyle, subHeaderStyle, bodyStyle),
      ),
    );
  }
}