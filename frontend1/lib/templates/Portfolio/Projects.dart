// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ProjectPortfolio extends StatefulWidget {
//   final String token;
//     final bool isEditing;
//         final Function(Function()) registerSaveCallback;

//   const ProjectPortfolio({super.key, required this.token,required this.isEditing,required this.registerSaveCallback});
//   @override
//   _ProjectPortfolioState createState() => _ProjectPortfolioState();
// }

// class _ProjectPortfolioState extends State<ProjectPortfolio> {
//   List<Project> projects = [];

//   List<TextEditingController> titleControllers = [];
//   List<TextEditingController> descriptionControllers = [];
//   List<TextEditingController> roleControllers = [];
//   List<TextEditingController> githubLinkControllers = [];
//   List<TextEditingController> demoLinkControllers = [];
//   List<TextEditingController> mediaUrlControllers = [];
//   List<TextEditingController> technologiesControllers = [];

//   bool isEditing = false;

//     final ImagePicker _picker = ImagePicker();
//   File? _image;

//  @override
//   void initState() {
//     super.initState();
//        widget.registerSaveCallback(saveData);
//     fetchProjects();
//   }
//   void saveData() {
//     print("data save in projects");
// updatePortfolioProjects();
//     /*
//    // Replace with actual database logic
//     */
//   }

// Future<void> updatePortfolioProjects( ) async {
//   final url = 'http://$localhost/api/portfolio/projects'; // Replace with your API URL
//   print("projects are $projects");
//   final headers = {
//     'Authorization': 'Bearer ${widget.token}', // Sending the token in the Authorization header
//     'Content-Type': 'application/json', // Specify content type
//   };

//   final body = jsonEncode({
//     'projects': projects.map((project) => project.toJson()).toList(),
//   });

//   try {
//     final response = await http.put(
//       Uri.parse(url),
//       headers: headers,
//       body: body,
//     );

//     if (response.statusCode == 200) {
//       // Successfully updated the portfolio
//       print('projects updated successfully.');
//     } else {
//       // Handle the error
//       print('Failed to update projects: ${response.body}');
//     }
//   } catch (e) {
//     // Handle network or other errors
//     print('Error updating projects: $e');
//   }
// }

//   Future<void> fetchProjects() async {
//     final url = 'http://$localhost/api/portfolio/projects'; // Update API URL
//     try {
//       final response = await http.get(Uri.parse(url),
//        headers: {
//         'Authorization':'Bearer ${widget.token}', // Include the JWT token
//       },
//       );
//       if (response.statusCode == 200) {
//            final List<dynamic> data = json.decode(response.body);

//       setState(() {
//         projects = data.map((json) => Project.fromJson(json)).toList();
//       });

//        for (var project in projects) {
//     titleControllers.add(TextEditingController(text: project.title));
//     descriptionControllers.add(TextEditingController(text: project.description));
//     roleControllers.add(TextEditingController(text: project.role));
//     githubLinkControllers.add(TextEditingController(text: project.githubLink));
//     demoLinkControllers.add(TextEditingController(text: project.demoLink));
//     mediaUrlControllers.add(TextEditingController(text: project.mediaUrl));
//     technologiesControllers.add(TextEditingController(text: project.technologies.join(', ')));
//   }

//     } else {
//       throw Exception('Failed to load projects: ${response.statusCode}');
//     }
//   } catch (e) {
//       print('Error fetching projects: $e');

//     }
//   }
//     Future<void> _addNewProject() async {
//     setState(() {
//       projects.add(Project(
//         title: 'New Project',
//         description: 'Project description...',
//         role: 'Role...',
//         technologies: ['Tech 1', 'Tech 2'],
//         githubLink: '',
//         demoLink: '',
//         mediaUrl: '', // Initial empty string for image
//       ));
//     });
//   }


//   // Edit Project Details
//   void _editProject(Project project, String newValue, String field) {
//     setState(() {
//       switch (field) {
//         case 'title':
//           project.title = newValue;
//           break;
//         case 'description':
//           project.description = newValue;
//           break;
//         case 'role':
//           project.role = newValue;
//           break;
//         case 'githubLink':
//           project.githubLink = newValue;
//           break;
//         case 'demoLink':
//           project.demoLink = newValue;
//           break;
//         case 'mediaUrl':
//           project.mediaUrl = newValue;
//           break;
//         case 'technologies':
//           project.technologies = newValue.split(','); // split technologies by comma
//           break;
//       }
//     });
//   }

//   // Delete Project on Long Press
//   void _showDeleteConfirmationDialog(int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Project'),
//           content: Text('Are you sure you want to delete this project?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   projects.removeAt(index);
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// Widget _buildEditMode() {
//   return Expanded(
//     child: Column(
//       children: [
//         ElevatedButton(
//           onPressed: _addNewProject,
//           child: Text('Add New Project'),
//         ),
//        ... projects.map((project) {
//                 // Create controllers for each project field individually
//                 TextEditingController titleController = TextEditingController(text: project.title);
//                 TextEditingController descriptionController = TextEditingController(text: project.description);
//                 TextEditingController roleController = TextEditingController(text: project.role);
//                 TextEditingController githubLinkController = TextEditingController(text: project.githubLink);
//                 TextEditingController demoLinkController = TextEditingController(text: project.demoLink);
//                 TextEditingController mediaUrlController = TextEditingController(text: project.mediaUrl);
//                 TextEditingController technologiesController = TextEditingController(text: project.technologies.join(', '));

//                 return GestureDetector(
//                   onLongPress: () => _showDeleteConfirmationDialog(projects.indexOf(project)),
//                   child: Card(
//                     margin: EdgeInsets.all(16),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextField(
//                             controller: titleController,
//                             decoration: InputDecoration(labelText: 'Project Title'),
//                             onChanged: (value) => _editProject(project, value, 'title'),
//                           ),
//                           SizedBox(height: 8),
//                           TextField(
//                             controller: descriptionController,
//                             decoration: InputDecoration(labelText: 'Project Description'),
//                             onChanged: (value) => _editProject(project, value, 'description'),
//                           ),
//                           SizedBox(height: 8),
//                           TextField(
//                             controller: roleController,
//                             decoration: InputDecoration(labelText: 'Role'),
//                             onChanged: (value) => _editProject(project, value, 'role'),
//                           ),
//                           SizedBox(height: 8),
//                           TextField(
//                             controller: githubLinkController,
//                             decoration: InputDecoration(labelText: 'GitHub Link'),
//                             onChanged: (value) => _editProject(project, value, 'githubLink'),
//                           ),
//                           SizedBox(height: 8),
//                           TextField(
//                             controller: demoLinkController,
//                             decoration: InputDecoration(labelText: 'Live Demo Link'),
//                             onChanged: (value) => _editProject(project, value, 'demoLink'),
//                           ),
//                           SizedBox(height: 8),
//                           TextField(
//                             controller: mediaUrlController,
//                             decoration: InputDecoration(labelText: 'Media URL'),
//                             onChanged: (value) => _editProject(project, value, 'mediaUrl'),
//                           ),
//                           SizedBox(height: 8),
//                           TextField(
//                             controller: technologiesController,
//                             decoration: InputDecoration(labelText: 'Technologies Used'),
//                             onChanged: (value) => _editProject(project, value, 'technologies'),
//                           ),
//                           SizedBox(height: 8),
//                           project.mediaUrl.isNotEmpty
//                             ? GestureDetector(
//                                 onTap: () => _pickImage(project),
//                                 child:      
// project.mediaUrl.isNotEmpty
//     ? Uri.parse(project.mediaUrl).isAbsolute // Check if it's a URL
//         ? Image.network(project.mediaUrl) // Display network image if it's a URL
//         : File(project.mediaUrl).existsSync() // Check if it's a local file
//             ? Image.file(File(project.mediaUrl)) // Display local image if it's a file path
//             : Image.asset('lib/images/placeholder.png') // Display placeholder if the file doesn't exist
//     : Image.asset('lib/images/placeholder.png'), // Default to placeholder if mediaUrl is empty

//                                 //Image.file(File(project.mediaUrl)), // Display the image from Firebase Storage
//                               )
//                             :GestureDetector(
//                                      onTap: () => _pickImage(project),
//                             child: Container(
//                                 width: 100,
//                                 height: 100,
//                                 color: Colors.grey[300], // Placeholder color
//                                 child: Icon(Icons.add_a_photo, color: Colors.white), // Placeholder icon
//                               ),
//                             ),
//                           SizedBox(height: 8),
//                           Row(
//                             children: [
//                               TextButton(
//                                 onPressed: () => _launchURL(project.githubLink),
//                                 child: Text('GitHub'),
//                               ),
//                               TextButton(
//                                 onPressed: () => _launchURL(project.demoLink),
//                                 child: Text('Live Demo'),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
           
  
     
//       ],
//     ),
//   );
// }
//   Future<void> _pickImage(Project project) async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path); // Save the picked image
//         project.mediaUrl = _image!.path; // Update the mediaUrl field of the project
//       });
//       // Optionally, update this image in your backend or database
//     //  _uploadImage(project);  // You can use this method to upload the image to the backend if needed
//     }
//   }
// Widget _buildPreviewMode(){
//     return 
//  Column(
//           children: projects.map((project) {
//         return Card(
//           margin: EdgeInsets.all(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Project Title
//                 Text(
//                   project.title,
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),

//                 // Project Description
//                 Text(
//                   project.description,
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 8),

//                 // Project Role
//                 Text(
//                   "Role: ${project.role}",
//                   style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
//                 ),
//                 SizedBox(height: 8),

//                 // Technologies Used
//                 Text(
//                   "Technologies: ${project.technologies.join(', ')}",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 8),

                
// project.mediaUrl.isNotEmpty
//     ? Uri.parse(project.mediaUrl).isAbsolute // Check if it's a URL
//         ? Image.network(project.mediaUrl) // Display network image if it's a URL
//         : File(project.mediaUrl).existsSync() // Check if it's a local file
//             ? Image.file(File(project.mediaUrl)) // Display local image if it's a file path
//             : Image.asset('lib/images/placeholder.png') // Display placeholder if the file doesn't exist
//     : Image.asset('lib/images/placeholder.png'), // Default to placeholder if mediaUrl is empty

//                 SizedBox(height: 8),

//                 // Links
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () => _launchURL(project.githubLink),
//                       child: Text('GitHub'),
//                     ),
//                     TextButton(
//                       onPressed: () => _launchURL(project.demoLink),
//                       child: Text('Live Demo'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
          
        
      
//     );
// }

//   @override
//   Widget build(BuildContext context) {
//      return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: widget.isEditing ? _buildEditMode() : _buildPreviewMode(),
//     );
//   }


//   // Launch URL function
//   void _launchURL(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
//   }
//   }

// class Project {
//   String title;
//   String description;
//   String role;
//   List<String> technologies;
//   String githubLink;
//   String demoLink;
//   String mediaUrl;

//   Project({
//     required this.title,
//     required this.description,
//     required this.role,
//     required this.technologies,
//     required this.githubLink,
//     required this.demoLink,
//     required this.mediaUrl,
//   });

//   // Factory method to create a Project instance from JSON
//   factory Project.fromJson(Map<String, dynamic> json) {
//     return Project(
//       title: json['title'],
//       description: json['description'],
//       role: json['role'],
//       technologies: List<String>.from(json['technologies'] ?? []),
//       githubLink: json['githubLink'] ?? '',
//       demoLink: json['demoLink'] ?? '',
//       mediaUrl: json['mediaUrl'] ?? '',
//     );
//   }
//     Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'description': description,
//       'role': role,
//       'technologies': technologies,
//       'githubLink': githubLink,
//       'demoLink': demoLink,
//       'mediaUrl': mediaUrl,
//     };
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectPortfolio extends StatefulWidget {
  final String token;
  final bool isEditing;
  final Function(Function()) registerSaveCallback;

  const ProjectPortfolio({
    super.key,
    required this.token,
    required this.isEditing,
    required this.registerSaveCallback,
  });

  @override
  _ProjectPortfolioState createState() => _ProjectPortfolioState();
}

class _ProjectPortfolioState extends State<ProjectPortfolio> {
  List<Project> projects = [];

  // Controllers for each field
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> descriptionControllers = [];
  List<TextEditingController> roleControllers = [];
  List<TextEditingController> githubLinkControllers = [];
  List<TextEditingController> demoLinkControllers = [];
  List<TextEditingController> mediaUrlControllers = [];
  List<TextEditingController> technologiesControllers = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    widget.registerSaveCallback(saveData);
    fetchProjects();
  }

  /// Save data callback
  void saveData() {
    print("Saving data in ProjectPortfolio...");
    updatePortfolioProjects();
  }

  /// Fetch projects from the backend
  Future<void> fetchProjects() async {
    final url = 'http://$localhost/api/portfolio/projects'; // Update API URL
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Include the JWT token
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          projects = data.map((json) => Project.fromJson(json)).toList();

          // Initialize controllers for each project
          for (var project in projects) {
            titleControllers.add(TextEditingController(text: project.title));
            descriptionControllers
                .add(TextEditingController(text: project.description));
            roleControllers.add(TextEditingController(text: project.role));
            githubLinkControllers
                .add(TextEditingController(text: project.githubLink));
            demoLinkControllers
                .add(TextEditingController(text: project.demoLink));
            mediaUrlControllers
                .add(TextEditingController(text: project.mediaUrl));
            technologiesControllers.add(
                TextEditingController(text: project.technologies.join(', ')));
          }
        });
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching projects: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching projects: $e')),
      );
    }
  }

  /// Update projects to the backend
  Future<void> updatePortfolioProjects() async {
    final url = 'http://$localhost/api/portfolio/projects'; // Update with your API URL
    final headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'projects': projects.map((project) => project.toJson()).toList(),
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Projects updated successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Projects updated successfully.')),
        );
      } else {
        print('Failed to update projects: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update projects.')),
        );
      }
    } catch (e) {
      print('Error updating projects: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating projects: $e')),
      );
    }
  }

  /// Add a new project
  void _addNewProject() {
    setState(() {
      projects.add(Project(
        title: 'New Project',
        description: 'Project description...',
        role: 'Role...',
        technologies: ['Tech 1', 'Tech 2'],
        githubLink: '',
        demoLink: '',
        mediaUrl: '',
      ));

      // Initialize controllers for the new project
      titleControllers.add(TextEditingController(text: 'New Project'));
      descriptionControllers
          .add(TextEditingController(text: 'Project description...'));
      roleControllers.add(TextEditingController(text: 'Role...'));
      githubLinkControllers.add(TextEditingController(text: ''));
      demoLinkControllers.add(TextEditingController(text: ''));
      mediaUrlControllers.add(TextEditingController(text: ''));
      technologiesControllers
          .add(TextEditingController(text: 'Tech 1, Tech 2'));
    });
  }

  /// Edit project details
  void _editProject(Project project, String newValue, String field) {
    setState(() {
      switch (field) {
        case 'title':
          project.title = newValue;
          break;
        case 'description':
          project.description = newValue;
          break;
        case 'role':
          project.role = newValue;
          break;
        case 'githubLink':
          project.githubLink = newValue;
          break;
        case 'demoLink':
          project.demoLink = newValue;
          break;
        case 'mediaUrl':
          project.mediaUrl = newValue;
          break;
        case 'technologies':
          project.technologies = newValue.split(',').map((e) => e.trim()).toList();
          break;
      }
    });
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Project',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete this project?',
            style: GoogleFonts.montserrat(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  projects.removeAt(index);
                  // Remove associated controllers
                  titleControllers.removeAt(index);
                  descriptionControllers.removeAt(index);
                  roleControllers.removeAt(index);
                  githubLinkControllers.removeAt(index);
                  demoLinkControllers.removeAt(index);
                  mediaUrlControllers.removeAt(index);
                  technologiesControllers.removeAt(index);
                });
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Project deleted successfully.')),
                );
              },
              child: Text(
                'Delete',
                style: GoogleFonts.montserrat(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Pick image from gallery and assign to project
  Future<void> _pickImage(Project project, int index) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        project.mediaUrl = pickedFile.path;
        mediaUrlControllers[index].text = pickedFile.path;
      });

       final bytes = await pickedFile!.readAsBytes(); // Await the bytes
      String base64Image = base64Encode(bytes); // Convert bytes to base64 string

      // Update profileImage with the base64 string
      setState(() {
        project.mediaUrl = base64Image;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image selected successfully.')),
      );
      // Optionally, upload the image to your backend here
    }
  }

  /// Launch URL
  void _launchURL(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No URL provided.')),
      );
      return;
    }
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  /// --- EDIT MODE WIDGET ---
  Widget _buildEditMode(TextStyle bodyStyle, TextStyle labelStyle,
      TextStyle hintStyle) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Add New Project Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _addNewProject,
              icon: Icon(Icons.add),
              label: Text(
                'Add New Project',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // List of Projects
          ...projects.asMap().entries.map((entry) {
            int index = entry.key;
            Project project = entry.value;
             bool isBase64 = project.mediaUrl.startsWith('data:image/') || project.mediaUrl.startsWith('/9j/');

            return GestureDetector(
              onLongPress: () => _showDeleteConfirmationDialog(index),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Title
                      TextField(
                        controller: titleControllers[index],
                        style: bodyStyle,
                        decoration: InputDecoration(
                          labelText: 'Project Title',
                          labelStyle: labelStyle,
                          hintText: 'Enter project title',
                          hintStyle: hintStyle,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.title, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) =>
                            _editProject(project, value, 'title'),
                      ),
                      const SizedBox(height: 12),

                      // Project Description
                      TextField(
                        controller: descriptionControllers[index],
                        style: bodyStyle,
                        decoration: InputDecoration(
                          labelText: 'Project Description',
                          labelStyle: labelStyle,
                          hintText: 'Enter project description',
                          hintStyle: hintStyle,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              Icon(Icons.description, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) =>
                            _editProject(project, value, 'description'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),

                      // Project Role
                      TextField(
                        controller: roleControllers[index],
                        style: bodyStyle,
                        decoration: InputDecoration(
                          labelText: 'Role',
                          labelStyle: labelStyle,
                          hintText: 'Enter your role',
                          hintStyle: hintStyle,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) =>
                            _editProject(project, value, 'role'),
                      ),
                      const SizedBox(height: 12),

                      // GitHub Link
                      TextField(
                        controller: githubLinkControllers[index],
                        style: bodyStyle,
                        decoration: InputDecoration(
                          labelText: 'GitHub Link',
                          labelStyle: labelStyle,
                          hintText: 'Enter GitHub repository URL',
                          hintStyle: hintStyle,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.link, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) =>
                            _editProject(project, value, 'githubLink'),
                      ),
                      const SizedBox(height: 12),

                      // Live Demo Link
                      TextField(
                        controller: demoLinkControllers[index],
                        style: bodyStyle,
                        decoration: InputDecoration(
                          labelText: 'Live Demo Link',
                          labelStyle: labelStyle,
                          hintText: 'Enter live demo URL',
                          hintStyle: hintStyle,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.link, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) =>
                            _editProject(project, value, 'demoLink'),
                      ),
                      const SizedBox(height: 12),

                      // Technologies Used
                      TextField(
                        controller: technologiesControllers[index],
                        style: bodyStyle,
                        decoration: InputDecoration(
                          labelText: 'Technologies Used',
                          labelStyle: labelStyle,
                          hintText: 'e.g., Flutter, Dart, Firebase',
                          hintStyle: hintStyle,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              Icon(Icons.code, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) =>
                            _editProject(project, value, 'technologies'),
                      ),
                      const SizedBox(height: 12),

                      // Media URL/Image
                      GestureDetector(
                        onTap: () => _pickImage(project, index),
                        child: project.mediaUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Uri.parse(project.mediaUrl).isAbsolute
                                    ? Image.network(
                                        project.mediaUrl,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                       : isBase64?
              
               Image.memory(base64Decode(project.mediaUrl.split(',').last)) // Decode base64
                                    : File(project.mediaUrl).existsSync()
                                        ? Image.file(
                                            File(project.mediaUrl),
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            'https://ninjasites.com/images/blog/webpage-creation.png?v=1684153977260389102',
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                              )
                            : Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _launchURL(project.githubLink),
                            child: Text(
                              'GitHub',
                              style: GoogleFonts.montserrat(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _launchURL(project.demoLink),
                            child: Text(
                              'Live Demo',
                              style: GoogleFonts.montserrat(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// --- PREVIEW MODE WIDGET ---
  Widget _buildPreviewMode(TextStyle headerStyle, TextStyle bodyStyle,
      TextStyle linkStyle) {

    return SingleChildScrollView(
      child: Column(
        children: projects.map((project) {
                  bool isBase64 = project.mediaUrl.startsWith('data:image/') || project.mediaUrl.startsWith('/9j/');

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Title
                  Text(
                    project.title,
                    style: headerStyle,
                  ),
                  const SizedBox(height: 8),

                  // Project Description
                  Text(
                    project.description,
                    style: bodyStyle,
                  ),
                  const SizedBox(height: 8),

                  // Project Role
                  Text(
                    "Role: ${project.role}",
                    style: bodyStyle.copyWith(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),

                  // Technologies Used
                  Text(
                    "Technologies: ${project.technologies.join(', ')}",
                    style: bodyStyle,
                  ),
                  const SizedBox(height: 12),

                  // Project Image
                  project.mediaUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Uri.parse(project.mediaUrl).isAbsolute
                              ? Image.network(
                                  project.mediaUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : File(project.mediaUrl).existsSync()
                                  ? Image.file(
                                      File(project.mediaUrl),
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                      : isBase64?
              
               Image.memory(base64Decode(project.mediaUrl.split(',').last)) // Decode base64
                                  : Image.network(
                                      'https://ninjasites.com/images/blog/webpage-creation.png?v=1684153977260389102',
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                   
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://ninjasites.com/images/blog/webpage-creation.png?v=1684153977260389102',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _launchURL(project.githubLink),
                        child: Text(
                          'GitHub',
                          style: linkStyle,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _launchURL(project.demoLink),
                        child: Text(
                          'Live Demo',
                          style: linkStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build the main widget based on editing mode
  @override
  Widget build(BuildContext context) {
    // Common text styles
    final TextStyle headerStyle = GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    final TextStyle bodyStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.black87,
    );
    final TextStyle labelStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[700],
      fontWeight: FontWeight.w500,
    );
    final TextStyle hintStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[400],
    );
    final TextStyle linkStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );

    return Container(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.isEditing
            ? _buildEditMode(bodyStyle, labelStyle, hintStyle)
            : _buildPreviewMode(headerStyle, bodyStyle, linkStyle),
      ),
    );
  }
}

/// Project Model
class Project {
  String title;
  String description;
  String role;
  List<String> technologies;
  String githubLink;
  String demoLink;
  String mediaUrl;

  Project({
    required this.title,
    required this.description,
    required this.role,
    required this.technologies,
    required this.githubLink,
    required this.demoLink,
    required this.mediaUrl,
  });

  /// Factory method to create a Project instance from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'],
      description: json['description'],
      role: json['role'],
      technologies: List<String>.from(json['technologies'] ?? []),
      githubLink: json['githubLink'] ?? '',
      demoLink: json['demoLink'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
    );
  }

  /// Convert Project instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'role': role,
      'technologies': technologies,
      'githubLink': githubLink,
      'demoLink': demoLink,
      'mediaUrl': mediaUrl,
    };
  }
}
