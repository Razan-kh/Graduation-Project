import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class CoverLetterScreen extends StatefulWidget {
  final String token;
  final String userName;
  final String cvContent;

  const CoverLetterScreen({super.key, 
    required this.token,
    required this.userName,
    required this.cvContent,
  });

  @override
  _CoverLetterScreenState createState() => _CoverLetterScreenState();
}

class _CoverLetterScreenState extends State<CoverLetterScreen> {
  final companyController = TextEditingController();
  final jobTitleController = TextEditingController();
  final bodyController = TextEditingController();

  bool isGenerating = false;

  Future<void> generateCoverLetter(BuildContext context) async {
    setState(() {
      isGenerating = true;
    });

    try {
      if (widget.cvContent.isEmpty ||
          companyController.text.isEmpty ||
          jobTitleController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please fill in all fields and ensure CV content is available.',
              style: GoogleFonts.montserrat(),
            ),
          ),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('http://$localhost/api/generate-cover-letter'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'cvContent': widget.cvContent,
          'position': jobTitleController.text,
          'userName': widget.userName,
          'companyName': companyController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          bodyController.text = data['coverLetter'] ?? 'Failed to generate cover letter.';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to generate cover letter: ${response.body}',
              style: GoogleFonts.montserrat(),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    } finally {
      setState(() {
        isGenerating = false;
      });
    }
  }

  void downloadCoverLetterPDF({
    required String coverLetterContent,
    required String yourName,
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.openSansRegular();
    final boldFont = await PdfGoogleFonts.openSansBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              'Cover Letter',
              style: pw.TextStyle(font: boldFont, fontSize: 16),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              coverLetterContent,
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Best regards,', style: pw.TextStyle(font: font, fontSize: 12)),
            pw.SizedBox(height: 10),
            pw.Text(yourName, style: pw.TextStyle(font: boldFont, fontSize: 12)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Apply consistent background color and theming
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Cover Letter Creator',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Colors.black),
            onPressed: () {
              downloadCoverLetterPDF(
                coverLetterContent: bodyController.text,
                yourName: widget.userName,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: companyController,
              style: GoogleFonts.montserrat(color: Colors.black87),
              decoration: InputDecoration(
                labelText: 'Company Name',
                labelStyle: GoogleFonts.montserrat(color: Colors.grey[700]),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter the company name',
                hintStyle: GoogleFonts.montserrat(color: Colors.grey, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 8),

            TextField(
              controller: jobTitleController,
              style: GoogleFonts.montserrat(color: Colors.black87),
              decoration: InputDecoration(
                labelText: 'Job Title',
                labelStyle: GoogleFonts.montserrat(color: Colors.grey[700]),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter the job title',
                hintStyle: GoogleFonts.montserrat(color: Colors.grey, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => generateCoverLetter(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isGenerating
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Generate Cover Letter',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: bodyController,
              style: GoogleFonts.montserrat(color: Colors.black87),
              decoration: InputDecoration(
                labelText: 'Generated Cover Letter',
                labelStyle: GoogleFonts.montserrat(color: Colors.grey[700]),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Your generated cover letter will appear here',
                hintStyle: GoogleFonts.montserrat(color: Colors.grey, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 10,
            ),
          ],
        ),
      ),
    );
  }
}
