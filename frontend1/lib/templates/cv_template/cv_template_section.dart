import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/cv_template/cover_letter.dart';
import 'package:frontend1/templates/cv_template/job_matching_screen.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CVEditorScreen extends StatefulWidget {
  final String token;
  final String templateId;

  const CVEditorScreen({super.key, required this.token, required this.templateId});

  @override
  _CVEditorScreenState createState() => _CVEditorScreenState();
}

class _CVEditorScreenState extends State<CVEditorScreen> {
  late CVDataProvider cvProvider;

  @override
  void initState() {
    super.initState();
    cvProvider = CVDataProvider(token: widget.token, templateId: widget.templateId);
    cvProvider.fetchCVData();
  }

  @override
  Widget build(BuildContext context) {
    // Define a theme style here for convenience
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

    return ChangeNotifierProvider<CVDataProvider>.value(
      value: cvProvider,
      child: Consumer<CVDataProvider>(
        builder: (context, cvProvider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            bottomNavigationBar: _footer(context),
            appBar: AppBar(
              title: Text('CV Editor', style: headerStyle.copyWith(color: Colors.black87)),
              backgroundColor: Colors.white,
              elevation: 1,
              iconTheme: IconThemeData(color: Colors.black87),
              actions: [
                IconButton(
                  icon: Icon(Icons.download, color: Colors.black87),
                  onPressed: () {
                    cvProvider.downloadPDF();
                  },
                  tooltip: 'Download PDF',
                ),
                IconButton(
                  icon: Icon(Icons.work, color: Colors.black87),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JobMatchingScreen(token: widget.token)),
                    );
                  },
                  tooltip: 'Job Matching',
                ),
                IconButton(
                  icon: Icon(Icons.edit_note, color: Colors.black87),
                  onPressed: () {
                    final cvContent = cvProvider.cvComponents
                        .map((component) => component.getTextContent())
                        .join('\n\n');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoverLetterScreen(
                          token: widget.token,
                          userName: cvProvider.nameController.text,
                          cvContent: cvContent,
                        ),
                      ),
                    );
                  },
                  tooltip: 'Generate Cover Letter',
                ),
              ],
            ),
            body: cvProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Name and Contact Info Section
                      Card(
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: cvProvider.nameController,
                                style: headerStyle.copyWith(fontSize: 24),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Your Name',
                                  hintStyle: hintStyle.copyWith(fontSize: 24),
                                ),
                                onChanged: (value) {
                                  cvProvider.saveCVData();
                                },
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: cvProvider.contactInfoController,
                                style: subHeaderStyle.copyWith(fontStyle: FontStyle.italic),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Contact Info (Email, Phone, LinkedIn)',
                                  hintStyle: hintStyle,
                                ),
                                onChanged: (value) {
                                  cvProvider.saveCVData();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Reorderable ListView for Sections
                      Expanded(
                        child: ReorderableListView(
                          onReorder: (oldIndex, newIndex) {
                            cvProvider.reorderComponent(oldIndex, newIndex);
                          },
                          padding: EdgeInsets.zero,
                          children: [
                            for (int index = 0; index < cvProvider.cvComponents.length; index++)
                              Dismissible(
                                key: ValueKey(cvProvider.cvComponents[index].id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  cvProvider.deleteSection(index);
                                },
                                child: Card(
                                  key: ValueKey(cvProvider.cvComponents[index].id),
                                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                  child: CVComponentWidget(
                                    component: cvProvider.cvComponents[index],
                                    token: widget.token,
                                    cvId: widget.templateId,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Add New Section Button
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.blue,
                            textStyle: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            cvProvider.addNewSection();
                          },
                          icon: Icon(Icons.add),
                          label: Text("Add New Section"),
                        ),
                      ),
                    ],
                  ),
                  
          );
        },
      ),
    );
  }
}

class CVDataProvider extends ChangeNotifier {
  final String token;
  final String templateId;

  bool isLoading = true;

  CVDataProvider({required this.token, required this.templateId});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();

  List<CVComponent> cvComponents = [];

  Future<String?> getAISuggestion(String text) async {
    final url = Uri.parse('http://$localhost/api/ai/suggestions');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['suggestion'];
      } else {
        print('Failed to get AI suggestion: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting AI suggestion: $e');
      return null;
    }
  }

  // Check Grammar
  Future<String?> checkGrammar(String text) async {
    final url = Uri.parse('http://$localhost/api/grammer/check');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['correction']; // 'correction' field contains the corrected text
      } else {
        print('Failed to check grammar: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error checking grammar: $e');
      return null;
    }
  }

  // Fetch CV data from the backend
  Future<void> fetchCVData() async {
    final url = Uri.parse('http://$localhost/api/cv/$templateId');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        nameController.text = data['name'] ?? '';
        contactInfoController.text = data['contactInfo'] ?? '';

        cvComponents = (data['components'] as List)
            .map((componentData) => CVComponent.fromJson(
                  componentData,
                  token: token,
                  cvId: templateId,
                  onComponentChanged: saveCVData,
                ))
            .toList();
      } else {
        print('Failed to load CV data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching CV data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Save CV data to the backend
  Future<void> saveCVData() async {
    final url = Uri.parse('http://$localhost/api/cv/$templateId');
    try {
      final body = json.encode({
        'name': nameController.text,
        'contactInfo': contactInfoController.text,
        'components': cvComponents.map((c) => c.toJson()).toList(),
      });

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('CV data saved successfully');
      } else {
        print('Failed to save CV data: ${response.body}');
      }
    } catch (e) {
      print('Error saving CV data: $e');
    }
  }

  void reorderComponent(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = cvComponents.removeAt(oldIndex);
    cvComponents.insert(newIndex, item);
    saveCVData();
    notifyListeners();
  }

  void deleteSection(int index) async {
    final componentId = cvComponents[index].id;
    if (componentId.isNotEmpty) {
      // Call the backend API to delete the component
      final url = Uri.parse('http://$localhost/api/cv/$templateId/component/$componentId');
      try {
        final response = await http.delete(
          url,
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          print('Component deleted successfully');
        } else {
          print('Failed to delete component: ${response.body}');
        }
      } catch (e) {
        print('Error deleting component: $e');
      }
    }
    cvComponents.removeAt(index);
    saveCVData();
    notifyListeners();
  }

  void addNewSection() async {
    final url = Uri.parse('http://$localhost/api/cv/$templateId/component');
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: json.encode({'title': 'New Section', 'entries': []}),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final newComponent = CVComponent.fromJson(
          data,
          token: token,
          cvId: templateId,
          onComponentChanged: saveCVData,
        );
        cvComponents.add(newComponent);
        notifyListeners();
      } else {
        print('Failed to add new section: ${response.body}');
      }
    } catch (e) {
      print('Error adding new section: $e');
    }
  }

  void downloadPDF() async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.openSansRegular();
    final boldFont = await PdfGoogleFonts.openSansBold();
    final italicFont = await PdfGoogleFonts.openSansItalic();

    final nameStyle = pw.TextStyle(font: boldFont, fontSize: 28);
    final contactStyle = pw.TextStyle(font: italicFont, fontSize: 10);
    final sectionHeaderStyle = pw.TextStyle(font: boldFont, fontSize: 18);
    final entryTitleStyle = pw.TextStyle(font: boldFont, fontSize: 14);
    final entryRoleStyle = pw.TextStyle(font: italicFont, fontSize: 12, color: PdfColors.grey700);
    final entryDateLocationStyle = pw.TextStyle(font: italicFont, fontSize: 12, color: PdfColors.grey);
    final bulletPointStyle = pw.TextStyle(font: font, fontSize: 12);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(nameController.text, style: nameStyle),
              pw.SizedBox(height: 4),
              pw.Text(contactInfoController.text, style: contactStyle),
              pw.SizedBox(height: 16),
            ],
          ),
          pw.Divider(thickness: 1, color: PdfColors.grey),

          for (var component in cvComponents)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(component.title, style: sectionHeaderStyle),
                    pw.Divider(thickness: 1, color: PdfColors.grey),
                  ],
                ),
                pw.SizedBox(height: 8),
                for (var entry in component.entries)
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          if (entry.title.isNotEmpty)
                            pw.Text(entry.title, style: entryTitleStyle),
                          if (entry.date.isNotEmpty)
                            pw.Text(entry.date, style: entryDateLocationStyle),
                        ],
                      ),
                      if (entry.subtitle.isNotEmpty)
                        pw.Text(entry.subtitle, style: entryRoleStyle),
                      pw.SizedBox(height: 4),
                      if (entry.bulletPoints.isNotEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 16),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              for (var bullet in entry.bulletPoints)
                                pw.Row(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("• ", style: bulletPointStyle),
                                    pw.Expanded(
                                      child: pw.Text(bullet, style: bulletPointStyle),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      pw.SizedBox(height: 12),
                    ],
                  ),
                pw.SizedBox(height: 16),
              ],
            ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}

class CVComponent {
  String id;
  String title;
  List<CVEntry> entries;
  final String token;
  final String cvId;
  final VoidCallback onComponentChanged;

  String getTextContent() {
    return entries
        .map((entry) =>
            '${entry.title}\n${entry.subtitle}\n${entry.bulletPoints.join("\n")}')
        .join('\n\n');
  }

  CVComponent({
    required this.id,
    required this.title,
    required this.entries,
    required this.token,
    required this.cvId,
    required this.onComponentChanged,
  });

  factory CVComponent.fromJson(
    Map<String, dynamic> json, {
    required String token,
    required String cvId,
    required VoidCallback onComponentChanged,
  }) {
    return CVComponent(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      entries: (json['entries'] as List)
          .map((entryData) => CVEntry.fromJson(
                entryData,
                token: token,
                cvId: cvId,
                componentId: json['_id'] ?? '',
                onEntryChanged: onComponentChanged,
              ))
          .toList(),
      token: token,
      cvId: cvId,
      onComponentChanged: onComponentChanged,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.isNotEmpty ? id : null,
      'title': title,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }
}

class CVEntry {
  String id;
  String title;
  String subtitle;
  String date;
  List<String> bulletPoints;
  final String token;
  final String cvId;
  final String componentId;
  final VoidCallback onEntryChanged;

  CVEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.bulletPoints,
    required this.token,
    required this.cvId,
    required this.componentId,
    required this.onEntryChanged,
  });

  factory CVEntry.fromJson(
    Map<String, dynamic> json, {
    required String token,
    required String cvId,
    required String componentId,
    required VoidCallback onEntryChanged,
  }) {
    List<String> bulletPoints = [];
    if (json['bulletPoints'] != null) {
      bulletPoints = (json['bulletPoints'] as List)
          .map((bp) => bp['content'] as String)
          .toList();
    }

    return CVEntry(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      date: json['date'] ?? '',
      bulletPoints: bulletPoints,
      token: token,
      cvId: cvId,
      componentId: componentId,
      onEntryChanged: onEntryChanged,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.isNotEmpty ? id : null,
      'title': title,
      'subtitle': subtitle,
      'date': date,
      'bulletPoints': bulletPoints.map((bp) => {'content': bp}).toList(),
    };
  }
}

class CVComponentWidget extends StatefulWidget {
  final CVComponent component;
  final String token;
  final String cvId;

  const CVComponentWidget({super.key, 
    required this.component,
    required this.token,
    required this.cvId,
  });

  @override
  _CVComponentWidgetState createState() => _CVComponentWidgetState();
}

class _CVComponentWidgetState extends State<CVComponentWidget> {
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.component.title);
    titleController.addListener(() {
      widget.component.title = titleController.text;
      widget.component.onComponentChanged();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void addEntry() {
    setState(() {
      final newEntry = CVEntry(
        id: '',
        title: '',
        subtitle: '',
        date: '',
        bulletPoints: [],
        token: widget.token,
        cvId: widget.cvId,
        componentId: widget.component.id,
        onEntryChanged: widget.component.onComponentChanged,
      );
      widget.component.entries.add(newEntry);
    });
    widget.component.onComponentChanged();
  }

  void deleteEntry(int index) {
    setState(() {
      widget.component.entries.removeAt(index);
    });
    widget.component.onComponentChanged();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle sectionHeaderStyle = GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black87,
    );

    final TextStyle bodyStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.black87,
    );

    final TextStyle hintStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[400],
    );

    return Padding(
      key: ValueKey(widget.component.id),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title with actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: titleController,
                  style: sectionHeaderStyle,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Section Title',
                    hintStyle: hintStyle.copyWith(fontSize: 20),
                  ),
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.grey[700]),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'suggest_improvements',
                    child: Text('Suggest Improvements', style: bodyStyle),
                  ),
                  PopupMenuItem(
                    value: 'check_grammar',
                    child: Text('Check Grammar', style: bodyStyle),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'suggest_improvements') {
                    await _handleSuggestImprovements(context);
                  } else if (value == 'check_grammar') {
                    await _handleCheckGrammar(context);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          // Entries
          for (int i = 0; i < widget.component.entries.length; i++)
            Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.only(right: 16),
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                deleteEntry(i);
              },
              child: CVEntryWidget(
                entry: widget.component.entries[i],
                token: widget.token,
                cvId: widget.cvId,
                componentId: widget.component.id,
              ),
            ),
          // Add New Entry Button
          Align(
            alignment: Alignment.bottomLeft,
            child: TextButton.icon(
              onPressed: () {
                addEntry();
              },
              icon: Icon(Icons.add, color: Colors.blue),
              label: Text("Add new project or company",
                  style: GoogleFonts.montserrat(color: Colors.blue)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSuggestImprovements(BuildContext context) async {
    showLoadingDialog(context);

    try {
      final cvProvider = Provider.of<CVDataProvider>(context, listen: false);
      String inputText = widget.component.getTextContent();

      String? suggestions = await cvProvider.getAISuggestion(inputText);

      Navigator.pop(context); // Close loading dialog

      showResultDialog(context, "AI Suggestions", suggestions!);
        } catch (e) {
      Navigator.pop(context); // Close loading dialog
      showErrorSnackbar(context, "An error occurred: $e");
    }
  }

  Future<void> _handleCheckGrammar(BuildContext context) async {
    showLoadingDialog(context);

    try {
      final cvProvider = Provider.of<CVDataProvider>(context, listen: false);
      String inputText = widget.component.getTextContent();

      String? corrections = await cvProvider.checkGrammar(inputText);

      Navigator.pop(context); // Close loading dialog

      showResultDialog(context, "Grammar Check", corrections!);
        } catch (e) {
      Navigator.pop(context); // Close loading dialog
      showErrorSnackbar(context, "An error occurred: $e");
    }
  }
}

// Helper methods for dialogs and snackbars
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );
}

void showResultDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Text(content, style: GoogleFonts.montserrat()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close", style: GoogleFonts.montserrat(color: Colors.blue)),
          ),
        ],
      );
    },
  );
}

void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: GoogleFonts.montserrat()),
      backgroundColor: Colors.red[400],
    ),
  );
}

class CVEntryWidget extends StatefulWidget {
  final CVEntry entry;
  final String token;
  final String cvId;
  final String componentId;

  const CVEntryWidget({super.key, 
    required this.entry,
    required this.token,
    required this.cvId,
    required this.componentId,
  });

  @override
  _CVEntryWidgetState createState() => _CVEntryWidgetState();
}

class _CVEntryWidgetState extends State<CVEntryWidget> {
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController dateController;
  late List<TextEditingController> bulletPointControllers;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.entry.title);
    subtitleController = TextEditingController(text: widget.entry.subtitle);
    dateController = TextEditingController(text: widget.entry.date);
    bulletPointControllers = widget.entry.bulletPoints
        .map((bp) => TextEditingController(text: bp))
        .toList();

    titleController.addListener(() {
      widget.entry.title = titleController.text;
      widget.entry.onEntryChanged();
    });
    subtitleController.addListener(() {
      widget.entry.subtitle = subtitleController.text;
      widget.entry.onEntryChanged();
    });
    dateController.addListener(() {
      widget.entry.date = dateController.text;
      widget.entry.onEntryChanged();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    dateController.dispose();
    for (var controller in bulletPointControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addBulletPoint() {
    setState(() {
      widget.entry.bulletPoints.add('');
      bulletPointControllers.add(TextEditingController());
    });
    widget.entry.onEntryChanged();
  }

  void deleteBulletPoint(int index) {
    setState(() {
      widget.entry.bulletPoints.removeAt(index);
      bulletPointControllers.removeAt(index);
    });
    widget.entry.onEntryChanged();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.black87,
    );
    final TextStyle hintStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[400],
    );
    final TextStyle boldTitleStyle = GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    final TextStyle semiBoldStyle = GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );
    final TextStyle dateStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[600],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: dateController,
          style: dateStyle,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Date (e.g., Jan 2020 - Dec 2021)',
            hintStyle: hintStyle,
          ),
        ),
        TextFormField(
          controller: titleController,
          style: boldTitleStyle,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Position/Project Title',
            hintStyle: hintStyle.copyWith(fontSize: 18),
          ),
        ),
        TextFormField(
          controller: subtitleController,
          style: semiBoldStyle,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Company/Project Name',
            hintStyle: hintStyle.copyWith(fontSize: 16),
          ),
        ),
        SizedBox(height: 8),
        for (int j = 0; j < bulletPointControllers.length; j++)
          Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.only(right: 16),
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              deleteBulletPoint(j);
            },
            child: Row(
  crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
  children: [
    Text("• ", style: bodyStyle.copyWith(fontSize: 20)),
    Expanded(
      child: TextFormField(
        controller: bulletPointControllers[j],
        style: bodyStyle,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Bullet point...',
          hintStyle: hintStyle,
        ),
        onChanged: (newContent) {
          widget.entry.bulletPoints[j] = newContent;
          widget.entry.onEntryChanged();
        },
      ),
    ),
  ],
)

          ),
        Align(
          alignment: Alignment.bottomLeft,
          child: TextButton.icon(
            onPressed: () {
              addBulletPoint();
            },
            icon: Icon(Icons.add, color: Colors.blue),
            label: Text(
              "Add bullet point",
              style: GoogleFonts.montserrat(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
  Widget _footer(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: Colors.grey, size: 28),
            Icon(Icons.search, color: Colors.grey, size: 28),
            Icon(Icons.folder, color: Colors.grey, size: 28),
            Icon(Icons.edit, color: Colors.grey, size: 28),
          ],
        ),
      ),
    );
  }

