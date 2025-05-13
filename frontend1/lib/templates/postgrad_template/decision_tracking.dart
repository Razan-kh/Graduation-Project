import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:google_fonts/google_fonts.dart';

class DecisionTrackingWidget extends StatefulWidget {
  final String token;
  final String templateId;

  const DecisionTrackingWidget({super.key, required this.token, required this.templateId});

  @override
  _DecisionTrackingWidgetState createState() => _DecisionTrackingWidgetState();
}

class _DecisionTrackingWidgetState extends State<DecisionTrackingWidget> {
  List<Map<String, dynamic>> decisions = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  DateTime? dateSubmitted;
  String? decision;

  @override
  void initState() {
    super.initState();
    fetchDecisions();
  }

  Future<void> fetchDecisions() async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/postgraduate/decision/${widget.templateId}'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        if (data['decisions'] != null && data['decisions'] is List) {
          decisions = List<Map<String, dynamic>>.from(data['decisions']);
        } else {
          decisions = [];
        }
      });
    } else {
      print("Failed to fetch decisions: ${response.body}");
    }
  }

  Future<void> updateDecision(String decisionId, String newDecision) async {
    final response = await http.put(
      Uri.parse('http://$localhost/api/postgraduate/decision/status'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'decisionId': decisionId, 'decision': newDecision}),
    );

    if (response.statusCode == 200) {
      fetchDecisions();
    } else {
      print("Failed to update decision: ${response.body}");
    }
  }

  Future<void> addDecision() async {
    final newDecision = {
      'name': nameController.text,
      'link': linkController.text,
      'dateSubmitted': dateSubmitted?.toIso8601String(),
      'decision': decision ?? 'Pending',
    };

    final response = await http.post(
      Uri.parse('http://$localhost/api/postgraduate/decision'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'decision': newDecision}),
    );

    if (response.statusCode == 200) {
      fetchDecisions();
      clearFields();
    }
  }

  Future<void> deleteDecision(String decisionId) async {
    final response = await http.delete(
      Uri.parse('http://$localhost/api/postgraduate/decision'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'decisionId': decisionId}),
    );
    if (response.statusCode == 200) {
      fetchDecisions();
    }
  }

  void clearFields() {
    nameController.clear();
    linkController.clear();
    dateSubmitted = null;
    decision = null;
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateSubmitted = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader("📊 Decision Tracking"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 30,
            columns: [
              DataColumn(label: tableHeaderText('Name')),
              DataColumn(label: tableHeaderText('Link')),
              DataColumn(label: tableHeaderText('Date Submitted')),
              DataColumn(label: tableHeaderText('Decision')),
              DataColumn(label: tableHeaderText('Actions')),
            ],
            rows: decisions.map((decision) {
              return DataRow(cells: [
                DataCell(Text(decision['name'] ?? '')),
                DataCell(
                  GestureDetector(
                    onTap: () => _launchUrl(decision['link'] ?? ''),
                    child: Text(
                      decision['link'] ?? '',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                DataCell(Text(decision['dateSubmitted']?.split('T')[0] ?? '')),
                DataCell(
                  DropdownButton<String>(
                    value: decision['decision'],
                    items: ['Pending', 'Accepted', 'Rejected']
                        .map((decisionStatus) => DropdownMenuItem(
                              value: decisionStatus,
                              child: Text(decisionStatus),
                            ))
                        .toList(),
                    onChanged: (newDecision) {
                      if (newDecision != null) {
                        updateDecision(decision['_id'], newDecision);
                      }
                    },
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteDecision(decision['_id']),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onPressed: () => _showAddDecisionDialog(context),
            child: Text(
              'Add Decision',
              style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget sectionHeader(String title) {
    return Container(
      color: Colors.blue[50],
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget tableHeaderText(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  void _showAddDecisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Decision', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: inputDecoration('Name'),
                ),
                TextField(
                  controller: linkController,
                  decoration: inputDecoration('Link'),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    dateSubmitted == null
                        ? 'Select Date Submitted'
                        : "${dateSubmitted!.toLocal()}".split(' ')[0],
                    style: GoogleFonts.montserrat(color: Colors.blue),
                  ),
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
                    linkController.text.isNotEmpty &&
                    dateSubmitted != null) {
                  addDecision();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add', style: GoogleFonts.montserrat(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      labelText: hint,
      labelStyle: GoogleFonts.montserrat(),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
