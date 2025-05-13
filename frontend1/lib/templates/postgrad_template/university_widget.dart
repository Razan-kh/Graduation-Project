import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class UniversityApplicationsWidget extends StatefulWidget {
  final String token;
  final String templateId;

  const UniversityApplicationsWidget({super.key, required this.token, required this.templateId});

  @override
  _UniversityApplicationsWidgetState createState() => _UniversityApplicationsWidgetState();
}

class _UniversityApplicationsWidgetState extends State<UniversityApplicationsWidget> {
  List<Map<String, dynamic>> universities = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController logoUrlController = TextEditingController();
  DateTime? openDate;
  DateTime? deadline;

  @override
  void initState() {
    super.initState();
    fetchUniversities();
  }

  Future<void> fetchUniversities() async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/postgraduate/university/${widget.templateId}'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        if (data['universities'] != null && data['universities'] is List) {
          universities = List<Map<String, dynamic>>.from(data['universities']);
        } else {
          universities = [];
        }
      });
    } else {
      print("Failed to fetch universities: ${response.body}");
    }
  }

  Future<void> updateProgress(String universityId, String newProgress) async {
    final response = await http.put(
      Uri.parse('http://$localhost/api/postgraduate/university/progress'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'universityId': universityId, 'progress': newProgress}),
    );

    if (response.statusCode == 200) {
      fetchUniversities();
    } else {
      print("Failed to update progress: ${response.body}");
    }
  }

  Future<void> addUniversity() async {
    final newUniversity = {
      'name': nameController.text,
      'program': programController.text,
      'duration': durationController.text,
      'openDate': openDate?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'progress': 'Not started',
      'logoUrl': logoUrlController.text,
    };

    final response = await http.post(
      Uri.parse('http://$localhost/api/postgraduate/university'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'university': newUniversity}),
    );

    if (response.statusCode == 200) {
      fetchUniversities();
      clearFields();
    }
  }

  Future<void> deleteUniversity(String universityId) async {
    final response = await http.delete(
      Uri.parse('http://$localhost/api/postgraduate/university'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'universityId': universityId}),
    );
    if (response.statusCode == 200) {
      fetchUniversities();
    }
  }

  void clearFields() {
    nameController.clear();
    programController.clear();
    durationController.clear();
    logoUrlController.clear();
    openDate = null;
    deadline = null;
  }

  Future<void> _selectDate(BuildContext context, bool isOpenDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isOpenDate) {
          openDate = pickedDate;
        } else {
          deadline = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.blue[50],
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            "University Applications",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 10,
            columns: [
              DataColumn(label: Text('Logo', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Name', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Program', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Duration', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Open', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Deadline', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Progress', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Actions', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
            ],
            rows: universities.map((university) {
              return DataRow(cells: [
                DataCell(
                  Image.network(
                    university['logoUrl'] ?? 'https://www.vocaleurope.eu/wp-content/uploads/no-image.jpg',
                    width: 30,
                    height: 30,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                  ),
                ),
                DataCell(Text(university['name'] ?? '', style: GoogleFonts.montserrat())),
                DataCell(Text(university['program'] ?? '', style: GoogleFonts.montserrat())),
                DataCell(Text(university['duration'] ?? '', style: GoogleFonts.montserrat())),
                DataCell(Text(university['openDate']?.split('T')[0] ?? '', style: GoogleFonts.montserrat())),
                DataCell(Text(university['deadline']?.split('T')[0] ?? '', style: GoogleFonts.montserrat())),
                DataCell(
                  DropdownButton<String>(
                    value: university['progress'],
                    items: ['Not started', 'In progress', 'Done']
                        .map((progress) => DropdownMenuItem(
                              value: progress,
                              child: Text(progress, style: GoogleFonts.montserrat()),
                            ))
                        .toList(),
                    onChanged: (newProgress) {
                      if (newProgress != null) {
                        updateProgress(university['_id'], newProgress);
                      }
                    },
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUniversity(university['_id']),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          onPressed: () => _showAddUniversityDialog(context),
          child: Text(
            'Add University Application',
            style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showAddUniversityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New University Application', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'University Name', hintStyle: GoogleFonts.montserrat()),
                ),
                TextField(
                  controller: programController,
                  decoration: InputDecoration(hintText: 'Program', hintStyle: GoogleFonts.montserrat()),
                ),
                TextField(
                  controller: durationController,
                  decoration: InputDecoration(hintText: 'Duration', hintStyle: GoogleFonts.montserrat()),
                ),
                TextField(
                  controller: logoUrlController,
                  decoration: InputDecoration(hintText: 'Logo URL', hintStyle: GoogleFonts.montserrat()),
                ),
                TextButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(openDate == null ? 'Select Open Date' : "${openDate!.toLocal()}".split(' ')[0],
                      style: GoogleFonts.montserrat(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(deadline == null ? 'Select Deadline' : "${deadline!.toLocal()}".split(' ')[0],
                      style: GoogleFonts.montserrat(color: Colors.blue)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: GoogleFonts.montserrat(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    programController.text.isNotEmpty &&
                    durationController.text.isNotEmpty &&
                    openDate != null &&
                    deadline != null) {
                  addUniversity();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add', style: GoogleFonts.montserrat(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
