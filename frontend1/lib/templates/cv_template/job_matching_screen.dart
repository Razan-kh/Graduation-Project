import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class JobMatchingScreen extends StatefulWidget {
  final String token;

  const JobMatchingScreen({super.key, required this.token});

  @override
  _JobMatchingScreenState createState() => _JobMatchingScreenState();
}

class _JobMatchingScreenState extends State<JobMatchingScreen> {
  List<dynamic> jobs = [];
  List<dynamic> filteredJobs = [];
  bool isLoading = true;

  String selectedLocation = 'All';
  String selectedCompany = 'All';

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final url = Uri.parse('http://$localhost/api/get-jobs');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final jobsData = json.decode(response.body);
        print(jobsData); // Debugging: Log fetched jobs
        setState(() {
          jobs = jobsData;
          filteredJobs = jobs;
          isLoading = false;
        });
      } else {
        print('Failed to load jobs: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching jobs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterJobs() {
    setState(() {
      filteredJobs = jobs.where((job) {
        final matchesLocation = selectedLocation == 'All' || job['location'] == selectedLocation;
        final matchesCompany = selectedCompany == 'All' || job['company'] == selectedCompany;
        return matchesLocation && matchesCompany;
      }).toList();
    });
  }

  Future<void> _openJobUrl(String url) async {
    try {
      Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Applying styling similar to the rest of the app
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Job Matches',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filters
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedLocation,
                            onChanged: (value) {
                              setState(() {
                                selectedLocation = value!;
                                filterJobs();
                              });
                            },
                            underline: SizedBox(),
                            style: GoogleFonts.montserrat(color: Colors.black87),
                            items: [
                              DropdownMenuItem(
                                value: 'All',
                                child: Text(
                                  'All Locations',
                                  style: GoogleFonts.montserrat(color: Colors.grey[700], fontSize: 14),
                                ),
                              ),
                              ...jobs
                                  .map((job) => job['location'])
                                  .where((location) => location != null && location is String)
                                  .toSet()
                                  .map<DropdownMenuItem<String>>((location) {
                                return DropdownMenuItem<String>(
                                  value: location,
                                  child: Text(
                                    location,
                                    style: GoogleFonts.montserrat(color: Colors.grey[700], fontSize: 14),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCompany,
                            onChanged: (value) {
                              setState(() {
                                selectedCompany = value!;
                                filterJobs();
                              });
                            },
                            underline: SizedBox(),
                            style: GoogleFonts.montserrat(color: Colors.black87),
                            items: [
                              DropdownMenuItem(
                                value: 'All',
                                child: Text(
                                  'All Companies',
                                  style: GoogleFonts.montserrat(color: Colors.grey[700], fontSize: 14),
                                ),
                              ),
                              ...jobs
                                  .map((job) => job['company'])
                                  .where((company) => company != null && company is String)
                                  .toSet()
                                  .map<DropdownMenuItem<String>>((company) {
                                return DropdownMenuItem<String>(
                                  value: company,
                                  child: Text(
                                    company,
                                    style: GoogleFonts.montserrat(color: Colors.grey[700], fontSize: 14),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Jobs list
                Expanded(
                  child: filteredJobs.isEmpty
                      ? Center(
                          child: Text(
                            'No jobs found',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredJobs.length,
                          itemBuilder: (context, index) {
                            final job = filteredJobs[index];
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                title: Text(
                                  job['title'] ?? '',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  '${job['company'] ?? ''} • ${job['location'] ?? ''}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward, color: Colors.grey[600]),
                                onTap: () {
                                  if (job['redirect_url'] != null) {
                                    _openJobUrl(job['redirect_url']);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
