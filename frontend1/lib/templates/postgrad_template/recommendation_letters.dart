import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationLettersWidget extends StatefulWidget {
  final String token;
  final String templateId;

  const RecommendationLettersWidget({super.key, required this.token, required this.templateId});

  @override
  _RecommendationLettersWidgetState createState() => _RecommendationLettersWidgetState();
}

class _RecommendationLettersWidgetState extends State<RecommendationLettersWidget> {
  List<Map<String, dynamic>> recommendationLetters = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DateTime? deadline;
  String? status;

  @override
  void initState() {
    super.initState();
    fetchRecommendationLetters();
  }

  Future<void> fetchRecommendationLetters() async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/postgraduate/recommendation/${widget.templateId}'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        if (data['recommendationLetters'] != null && data['recommendationLetters'] is List) {
          recommendationLetters = List<Map<String, dynamic>>.from(data['recommendationLetters']);
        } else {
          recommendationLetters = [];
        }
      });
    } else {
      print("Failed to fetch recommendation letters: ${response.body}");
    }
  }

  Future<void> updateStatus(String letterId, String newStatus) async {
    final response = await http.put(
      Uri.parse('http://$localhost/api/postgraduate/recommendation/status'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'recommendationLetterId': letterId, 'status': newStatus}),
    );

    if (response.statusCode == 200) {
      fetchRecommendationLetters();
    } else {
      print("Failed to update status: ${response.body}");
    }
  }

  Future<void> addRecommendationLetter() async {
    final newLetter = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'deadline': deadline?.toIso8601String(),
      'status': status ?? 'Not started',
    };

    final response = await http.post(
      Uri.parse('http://$localhost/api/postgraduate/recommendation'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'recommendationLetter': newLetter}),
    );

    if (response.statusCode == 200) {
      fetchRecommendationLetters();
      clearFields();
    }
  }

  Future<void> deleteRecommendationLetter(String letterId) async {
    final response = await http.delete(
      Uri.parse('http://$localhost/api/postgraduate/recommendation'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'recommendationLetterId': letterId}),
    );
    if (response.statusCode == 200) {
      fetchRecommendationLetters();
    }
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    deadline = null;
    status = null;
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        deadline = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Color(0xFFDFE6F2),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            "Recommendation Letters",
            style: TextStyle(
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
            columnSpacing: 16,
            dataRowHeight: 60,
            headingRowColor: WidgetStateColor.resolveWith((states) => Colors.grey[200]!),
            columns: [
              DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Deadline', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: recommendationLetters.map((letter) {
              return DataRow(cells: [
                DataCell(Text(letter['name'] ?? '')),
                DataCell(Text(letter['email'] ?? '')),
                DataCell(Text(letter['phone'] ?? '')),
                DataCell(Text(letter['deadline']?.split('T')[0] ?? '')),
                DataCell(
                  DropdownButton<String>(
                    value: letter['status'],
                    items: ['Not started', 'In progress', 'Submitted']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                        updateStatus(letter['_id'], newStatus);
                      }
                    },
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteRecommendationLetter(letter['_id']),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _showAddRecommendationDialog(context),
          child: Text(
            'Add Recommendation Letter',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _showAddRecommendationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            'Add New Recommendation Letter',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Recommender Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => _selectDeadline(context),
                  child: Text(
                    deadline == null
                        ? 'Select Deadline'
                        : "${deadline!.toLocal()}".split(' ')[0],
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
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
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty &&
                    deadline != null) {
                  addRecommendationLetter();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
