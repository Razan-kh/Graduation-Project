import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentsSection extends StatefulWidget {
  final String templateId;
  final String token;

  const DocumentsSection({super.key, required this.templateId, required this.token});

  @override
  _DocumentsSectionState createState() => _DocumentsSectionState();
}

class _DocumentsSectionState extends State<DocumentsSection> {
  List<Map<String, dynamic>> documents = [];
  List<Map<String, dynamic>> attachments = [];
  TextEditingController documentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDocuments();
    fetchAttachments();
  }

  Future<void> fetchDocuments() async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/postgraduate/document/${widget.templateId}'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      setState(() {
        documents = List<Map<String, dynamic>>.from(json.decode(response.body)['documents']);
      });
    } else {
      print("Failed to fetch documents: ${response.body}");
    }
  }

  Future<void> fetchAttachments() async {
    final response = await http.get(
      Uri.parse('http://$localhost/api/postgraduate/attachment/${widget.templateId}'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      setState(() {
        attachments = List<Map<String, dynamic>>.from(json.decode(response.body)['attachments']);
      });
    } else {
      print("Failed to fetch attachments: ${response.body}");
    }
  }

  Future<void> addDocument(String documentName) async {
    final response = await http.post(
      Uri.parse('http://$localhost/api/postgraduate/document'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'documentName': documentName}),
    );

    if (response.statusCode == 200) {
      fetchDocuments();
      documentController.clear();
    } else {
      print("Failed to add document: ${response.body}");
    }
  }

  Future<void> deleteDocument(String documentName) async {
  print("Deleting document with name: $documentName and template ID: ${widget.templateId}");

  final response = await http.delete(
    Uri.parse('http://$localhost/api/postgraduate/document'),
    headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
    body: json.encode({'templateId': widget.templateId, 'documentName': documentName}),
  );

  print("Response: ${response.body}");
  if (response.statusCode == 200) {
    setState(() {
      documents.removeWhere((doc) => doc['name'] == documentName);
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting document: ${json.decode(response.body)['error']}')),
    );
  }
}



  Future<void> uploadAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result.files.single.path!;
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://$localhost/api/postgraduate/attachment'),
      );

      request.headers['Authorization'] = 'Bearer ${widget.token}';
      request.fields['templateId'] = widget.templateId;
      request.files.add(await http.MultipartFile.fromPath('attachmentFile', filePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        fetchAttachments();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully!')),
        );
      } else {
        print("Failed to upload attachment: ${response.reasonPhrase}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File upload failed')));
      }
    } else {
      print("No file selected.");
    }
  }

  Future<void> deleteAttachment(String attachmentId) async {
    final response = await http.delete(
      Uri.parse('http://$localhost/api/postgraduate/attachment'),
      headers: {'Authorization': 'Bearer ${widget.token}', 'Content-Type': 'application/json'},
      body: json.encode({'templateId': widget.templateId, 'attachmentId': attachmentId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        attachments.removeWhere((attachment) => attachment['_id'] == attachmentId);
      });
    } else {
      print("Failed to delete attachment: ${response.body}");
    }
  }

  void openFile(String fileUrl) async {
    try {
      final Uri uri = Uri.parse('http://$localhost$fileUrl');

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $fileUrl');
      }
    } catch (e) {
      print('Error opening file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader("📄 Documents"),
        ...documents.map((doc) => dismissibleListItem(doc, deleteDocument)),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: TextField(
            controller: documentController,
            decoration: inputDecoration("Add a Document"),
            onSubmitted: (value) => addDocument(value),
          ),
        ),

        sectionHeader("🖥️ Attachments"),
        ...attachments.map((attachment) => dismissibleListItem(attachment, deleteAttachment)),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onPressed: () => uploadAttachment(),
            child: Text(
              "Upload New Attachment",
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

  Widget dismissibleListItem(Map<String, dynamic> item, Function(String) onDelete) {
    return Dismissible(
      key: Key(item['_id'] ?? DateTime.now().toString()),
      onDismissed: (direction) {
        setState(() {
          documents.removeWhere((doc) => doc['_id'] == item['_id']);
        });
        onDelete(item['_id']);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: GestureDetector(
          child: Text(
            item['name'] ?? '',
            style: GoogleFonts.montserrat(
              color: Colors.blue,
              decoration: TextDecoration.none,
            ),
          ),
          onTap: () => openFile(item['fileUrl'] ?? ''),
        ),
      ),
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
