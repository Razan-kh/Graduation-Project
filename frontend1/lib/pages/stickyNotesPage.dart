import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


// If you have these pages (DashboardPage, NotificationsScreen, etc.) import them as needed
import 'package:frontend1/pages/DashBoard.dart';
import 'package:frontend1/pages/UserNotification.dart';

class StickyNotesPage extends StatefulWidget {
  final String token;

  const StickyNotesPage({super.key, required this.token});

  @override
  _StickyNotesPageState createState() => _StickyNotesPageState();
}

class _StickyNotesPageState extends State<StickyNotesPage> {
  List<StickyNote> notes = [];
  final String baseUrl = "http://$localhost/api";
  final List<String> availableColors = [
    "#7AAFEE", // Light Blue
    "#FFEB3B", // Yellow
    "#FF5722", // Deep Orange
    "#4CAF50", // Green
    "#FFC107", // Amber
    "#E91E63", // Pink
  ];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/sticky-notes"),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> noteList = json.decode(response.body);
        setState(() {
          notes = noteList.map((note) => StickyNote.fromJson(note)).toList();
        });
      } else {
        debugPrint('Error fetching notes: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> addNote({required String color}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/sticky-notes"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'content': "New Note",
          'color': color,
          'position': {'x': 50, 'y': 50},
        }),
      );

      if (response.statusCode == 201) {
        fetchNotes();
      } else {
        debugPrint('Error adding note: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/sticky-notes/$noteId"),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          notes.removeWhere((note) => note.id == noteId);
        });
      } else {
        debugPrint('Error deleting note: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting note: $e');
    }
  }

  Future<void> updateNotePosition(String noteId, double x, double y) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/sticky-notes/$noteId/position"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'position': {'x': x, 'y': y},
        }),
      );

      if (response.statusCode == 200) {
        fetchNotes();
      } else {
        debugPrint('Error updating note position: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> updateNoteContent(String noteId, String content) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/sticky-notes/$noteId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 200) {
        fetchNotes();
      } else {
        debugPrint('Error updating note: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _showColorSelectionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose a color',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: availableColors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      addNote(color: color);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(int.parse(color.replaceFirst("#", "0xff"))),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _footer() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home icon - goes to Dashboard
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardPage()),
                      (route) => false,
                    );
                  },
                  child: Icon(Icons.home, color: Colors.grey, size: 28),
                ),
                // Search icon - currently inactive
                Icon(Icons.search, color: Colors.grey, size: 28),
                // Folder icon - goes to Notifications
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationsScreen(token: widget.token)),
                    );
                  },
                  child: Icon(Icons.folder, color: Colors.grey, size: 28),
                ),
                // Edit icon - current page, highlight it
                Icon(Icons.edit, color: Colors.blue, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        bool isWeb=MediaQuery.of(context).size.width>1200?true:false;

    // Using a stack or a FloatingActionButtonLocation to move the FAB a bit above the footer
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Sticky Notes",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Stack(
                children: notes.map((note) {
                  return Positioned(
                    key: ValueKey(note.id),
                    left: note.x,
                    top: note.y,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          note.x += details.delta.dx;
                          note.y += details.delta.dy;
                        });
                        updateNotePosition(note.id, note.x, note.y);
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(10),
                        color: Color(int.parse(note.color.replaceFirst("#", "0xff"))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteNote(note.id);
                              },
                            ),
                            Expanded(
                              child: TextField(
                                style: GoogleFonts.montserrat(color: Colors.black),
                                decoration: const InputDecoration(border: InputBorder.none),
                                controller: TextEditingController.fromValue(
                                  TextEditingValue(
                                    text: note.content,
                                    selection: TextSelection.collapsed(offset: note.content.length),
                                  ),
                                ),
                                onSubmitted: (value) {
                                  updateNoteContent(note.id, value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
       if(!isWeb)   _footer(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Move FAB a bit above the footer
        child: FloatingActionButton(
          onPressed: _showColorSelectionSheet,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class StickyNote {
  final String id;
  String content;
  String color;
  double x;
  double y;

  StickyNote({
    required this.id,
    required this.content,
    required this.color,
    required this.x,
    required this.y,
  });

  factory StickyNote.fromJson(Map<String, dynamic> json) {
    return StickyNote(
      id: json['_id'],
      content: json['content'],
      color: json['color'],
      x: (json['position']['x'] as num).toDouble(),
      y: (json['position']['y'] as num).toDouble(),
    );
  }
}


