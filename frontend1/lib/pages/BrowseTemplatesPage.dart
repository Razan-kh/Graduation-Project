import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/creationFunctions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend1/pages/DashBoard.dart';

class BrowseTemplatesPage extends StatefulWidget {
  final String token;
  final VoidCallback onTemplateAdded;

  const BrowseTemplatesPage({
    required this.token,
    required this.onTemplateAdded,
    super.key,
  });

  @override
  _BrowseTemplatesPageState createState() => _BrowseTemplatesPageState();
}

class _BrowseTemplatesPageState extends State<BrowseTemplatesPage> {
  List<dynamic> availableTemplates = [];
  List<dynamic> filteredTemplates = [];
  String selectedCategory = 'all'; // Default category
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchAvailableTemplates();
  }

  Future<void> _fetchAvailableTemplates() async {
    final url = 'http://$localhost/api/template/available';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['templates'];
        setState(() {
          availableTemplates = data;
          filteredTemplates = data; // Show all templates by default
        });
      } else {
        print('Failed to fetch templates');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _filterTemplates(String category) {
    setState(() {
      selectedCategory = category;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredTemplates = availableTemplates.where((template) {
        final matchesCategory = selectedCategory == 'all' || template['category'] == selectedCategory;
        final matchesSearch = template['name'].toLowerCase().contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  Future<void> _addTemplateToUser(String endpoint) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Template added successfully!')),
        );

        // Notify the DashboardPage that a change occurred
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add template.')),
        );
      }
    } catch (error) {
      print('Error adding template: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while adding the template.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Browse Templates',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _applyFilters();
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search',
                hintStyle: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _categoryButton('Life', 'life', Colors.amber[100]),
                _categoryButton('Work', 'work', Colors.blue[100]),
                _categoryButton('School', 'school', Colors.red[100]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredTemplates.isEmpty
                ? Center(
                    child: Text(
                      'No templates available',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: filteredTemplates.length,
                    itemBuilder: (context, index) {
                      final template = filteredTemplates[index];
                      return GestureDetector(
                        onTap: ()async {
                          switch (template['type']) {
                            case 'cv':
                              _addTemplateToUser('http://$localhost/api/cv/');
                              break;
                            case 'internship':
                              _addTemplateToUser('http://$localhost/api/internship/template');
                              break;
                            case 'postgraduate':
                              _addTemplateToUser('http://$localhost/api/postgraduate');
                              break;
                            case 'project':
                              _addTemplateToUser('http://$localhost/api/project-templates');
                              break;
                            case 'studentplanner':
                              _addTemplateToUser('http://$localhost/api/studentplanner');
                              break;
                              case 'student_planner':
                               _addTemplateToUser('http://$localhost/api/studentplanner2');
                               case 'booktracker':
  // Call the function that creates a Book Tracker on your server
  _addTemplateToUser('http://$localhost/api/booktracker');
  break;

                               case 'customPage':
                               createCustomPage(widget.token);
                              break;
                              case 'Assignment':
  try {
    String? idArray = await functionServices.createCoursesArray(widget.token, template['templateId']);
    if (idArray != null && idArray.isNotEmpty) {
      print('Courses array ID: $idArray');
      await functionServices.createTemplate(widget.token, "Assignment", "Assignment", idArray);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      print('Failed to retrieve courses array ID. ID is null or empty.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create assignment. Please check your inputs and try again.')),
      );
    }
  } catch (e, stackTrace) {
    print('Error occurred while creating assignment: $e');
    print('Stack trace: $stackTrace');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An unexpected error occurred. Please try again.')),
    );
  }
  break;

                              case 'Islam':
                             String ? idArray=await functionServices.createFirstRoutine();
                             functionServices.createTemplate(widget.token,"Islam","Islam",idArray!);
                               await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                              builder: (context) =>
                                                  DashboardPage(),
                                            ),
                                      );
                              break;
                              case 'MealsTracker':
                            String idArray=await functionServices.createAllMealsDays() ;
                          await  functionServices.createTemplate(widget.token,"MealsTracker","MealsTracker",idArray);
                               Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                              builder: (context) =>
                                                  DashboardPage(),
                                            ),
                                      );
                              break;
                              
                               case 'Portfolio':
                         
                           await functionServices.createPortfolio(widget.token);
                               Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                              builder: (context) =>
                                                  DashboardPage(),
                                            ),
                                      );
                              break;
                            case 'Finance':
                              await functionServices.postFinanceData(widget.token);
                               Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                        builder: (context) =>
                                        DashboardPage(),
                                            ),
                                      );
                              break;  
                            default:
                              print('Unknown template type');
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                  child: Image.network(
                                    template['image'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white, // Background color for the name section
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    template['name'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          _footer(),
        ],
      ),
    );
  }

  Widget _categoryButton(String label, String category, Color? color) {
    return GestureDetector(
      onTap: () => _filterTemplates(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedCategory == category ? color : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedCategory == category ? Colors.grey : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: selectedCategory == category
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2), // Shadow position
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            if (label == 'Life') Icon(Icons.local_florist, color: Colors.amber, size: 18),
            if (label == 'Work') Icon(Icons.bar_chart, color: Colors.blue, size: 18),
            if (label == 'School') Icon(Icons.school, color: Colors.red, size: 18),
            SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
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
                Icon(Icons.search, color:  Colors.grey, size: 28), // Active icon
                Icon(Icons.folder, color: Colors.grey, size: 28),
                Icon(Icons.edit, color: Colors.grey, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
 Future<void> createCustomPage(String token) async {
  const url = 'http://$localhost/api/custom-page'; // Update with your server URL
 String? userId= await functionServices.retrieveUserInfo();

  // Data to be sent in the request body
  final Map<String, dynamic> data = {
    'title': 'My Page',
    'BackgroundColor': 4294967295,
    'appBarColor': 4294967295,
    'icon': '📝',
    'toolBarColor': 4294967295,
    'userId': '$userId', // Replace with a valid user ID
    'elements': [],
  };

  try {
    // Send POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      },
      body: json.encode(data), // Convert data to JSON format
    );

    // Check response status
    if (response.statusCode == 201) {
      // Successful creation
      print('Custom page created successfully!');
      print('Response: ${response.body}');
          Navigator.pop(context, true);
    } else {
      // Failed to create custom page
      print('Failed to create custom page. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
}