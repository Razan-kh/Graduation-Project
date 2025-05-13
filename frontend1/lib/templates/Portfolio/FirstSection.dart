import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

// class Firstsection extends StatefulWidget {
//   final bool isEditing;
//   final String token;
//     final Function(Function()) registerSaveCallback;
//   const Firstsection({super.key, required this.isEditing,required this.token,required this.registerSaveCallback});
//   @override
//   FirstsectionState createState() => FirstsectionState();
// }

// class FirstsectionState extends State<Firstsection> {
  
//       final TextEditingController nameController = TextEditingController();
// final TextEditingController roleController = TextEditingController();
// final TextEditingController bioController = TextEditingController();

//  File? _image; // To hold the selected image

//   String profileImage = '';
//   String name = '';
//   String role = '';
//   String bio = '';

// @override
// void initState() {
//     // TODO: implement initState
//     super.initState();
//      widget.registerSaveCallback(saveData);
//    _fetchPortfolioData();

   
//   }

//   void saveData() {
//     print("data save in first Section");
// updatePortfolio(nameController.text,roleController.text,bioController.text,profileImage);
//     /*
//    // Replace with actual database logic
//     */
//   }
// Future<void> updatePortfolio(String name, String role, String bio, String profileImage) async {
// try{
//     // Prepare the API URL
//     final String url = 'http://$localhost/api/portfolio/editBasicInfo'; // Replace with your API URL

//     // Prepare the headers
//     final Map<String, String> headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${widget.token}', // Pass the token in the Authorization header
//     };

//     // Prepare the request body
//     final Map<String, dynamic> body = {
//       'name': name,
//       'role': role,
//       'bio': bio,
//       'profileImage': profileImage,
//     };

//     // Send the PUT request
//     final response = await http.put(
//       Uri.parse(url),
//       headers: headers,
//       body: json.encode(body),
//     );

//     // Handle the response
//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);
//       print('Portfolio updated successfully: ${responseData['message']}');
//     } else {
//       print('Failed to update portfolio: ${response.statusCode}');
//     }
//   } catch (error) {
//     print('Error: $error');
//   }
// }
  
//   final ImagePicker _picker = ImagePicker();
  

//  Future<void> _fetchPortfolioData() async {
//     final token = widget.token; // Replace with the actual token

//     final response = await http.get(
//       Uri.parse('http://$localhost/api/portfolio/BasicInfo'), // Replace with your actual backend URL
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);

//       setState(() {
//            profileImage = data['profileImage'] ?? '';
//         name = data['name'] ?? '';
//         role = data['role'] ?? '';
//         bio = data['bio'] ?? '';
        
//           bioController.text=bio;
//      roleController.text=role;
//      nameController.text=name;

     
//       });
//     } else {
//       print('Failed to fetch portfolio data');
//       // Handle error appropriately (e.g., show an error message)
//     }
//   }

//   // Function to pick an image from the gallery
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path); // Save the picked image
//         profileImage = _image!.path; // Update profile picture with new image path
//       });
//     }
//   }


//   Widget _buildPreviewMode() {
//   //  return SingleChildScrollView(
//      // scrollDirection: Axis.vertical,
//     // child:
//      return Padding(
//       padding: const EdgeInsets.all(16.0),
//      child:Column(
//           mainAxisSize: MainAxisSize.max, // This ensures Column takes up only as much space as needed
//     //   crossAxisAlignment: CrossAxisAlignment.start,
//       children:[
//           // Profile Picture
//           Center(
//             child: CircleAvatar(
//               radius: 100,
//           backgroundImage: profileImage.isNotEmpty
//                     ? (Uri.parse(profileImage).isAbsolute // Check if it's a URL
//         ? NetworkImage(profileImage) // Display network image if it's a URL
//         : FileImage(File(profileImage)) // Display local image if it's a file path
//     ): AssetImage('lib/images/placeholder.png') as ImageProvider,
//             ),
//           ),
//           SizedBox(height: 20),

//          SizedBox(height: 20),
              
//               // Name and Role
//               Text(
//                 nameController.text,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 roleController.text,
//                 style: TextStyle(fontSize: 18, color: Colors.grey),
//               ),
//               SizedBox(height: 20),
              
//               // Bio
//               Text(
//                 'Bio',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 bioController.text,
//                 style: TextStyle(fontSize: 16),
//               ),


//         ],
//      ),
//    //  ),
//     );
//   }
// /* image == null 
//             ? Center(
//                 child: Icon(
//                   Icons.add_a_photo,
//                   size: 50,
//                   color: Colors.grey,
//                 ),
//               )
//             : Image.file(
//                 image!,
//                 width: 150,
//                 height: 150,
//                 fit: BoxFit.cover,
//               ),*/
//   Widget _buildEditMode() {


//   return SingleChildScrollView(
//     scrollDirection: Axis.vertical,
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // Ensures the column takes up only as much space as needed
//         children: [
//           // Profile Picture
//           Center(
//             child: Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 100,
//                   backgroundImage: profileImage.isNotEmpty
//                       ? (Uri.parse(profileImage).isAbsolute // Check if it's a URL
//         ? NetworkImage(profileImage) // Display network image if it's a URL
//         : FileImage(File(profileImage)) // Display local image if it's a file path
//     )
//                       : AssetImage('lib/images/placeholder.png') as ImageProvider,
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: GestureDetector(
//                     onTap: () {
//                       // Function to upload or change profile picture
//                      // _changeProfilePicture();
//                      _pickImage();
//                     },
//                     child: CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.blue,
//                       child: Icon(Icons.camera_alt, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),

//           // Name and Role
//           TextField(
//             controller: nameController,
//             decoration: InputDecoration(
//               labelText: 'Name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           SizedBox(height: 20),

//           TextField(
//             controller: roleController,
//             decoration: InputDecoration(
//               labelText: 'Role',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           SizedBox(height: 20),

//           // Bio
//           TextField(
//             controller: bioController,
//             maxLines: 5,
//             decoration: InputDecoration(
//               labelText: 'Bio',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           SizedBox(height: 20),

//           // Save and Cancel Buttons
//           /*
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   // Save changes
//                //   _saveProfile();
//                 },
//                 child: Text('Save'),
//               ),
//               OutlinedButton(
//                 onPressed: () {
//                   // Discard changes
//                  // _cancelEdit();
//                 },
//                 child: Text('Cancel'),
//               ),
//             ],
//           ),
//           */
//         ],
//       ),
//     ),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//    return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: widget.isEditing ? _buildEditMode() : _buildPreviewMode(),
//   );
//   }
// }



class Firstsection extends StatefulWidget {
  final bool isEditing;
  final String token;
  final Function(Function()) registerSaveCallback;

  const Firstsection({
    super.key,
    required this.isEditing,
    required this.token,
    required this.registerSaveCallback,
  });

  @override
  FirstsectionState createState() => FirstsectionState();
}

class FirstsectionState extends State<Firstsection> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  File? _image; // Local file for newly picked image
  String profileImage = '';
  String name = '';
  String role = '';
  String bio = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    widget.registerSaveCallback(saveData);
    _fetchPortfolioData();
  }

  void saveData() {
    print("Saving data in Firstsection...");
    updatePortfolio(
      nameController.text,
      roleController.text,
      bioController.text,
      profileImage,
    );
  }

  Future<void> updatePortfolio(
    String name,
    String role,
    String bio,
    String profileImage,
  ) async {
    try {
      final String url = 'http://$localhost/api/portfolio/editBasicInfo';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      final Map<String, dynamic> body = {
        'name': name,
        'role': role,
        'bio': bio,
        'profileImage': profileImage,
      };

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Portfolio updated successfully: ${responseData['message']}');
      } else {
        print('Failed to update portfolio: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating portfolio: $error');
    }
  }

  Future<void> _fetchPortfolioData() async {
    try {
      final response = await http.get(
        Uri.parse('http://$localhost/api/portfolio/BasicInfo'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          profileImage = data['profileImage'] ?? '';
          name = data['name'] ?? '';
          role = data['role'] ?? '';
          bio = data['bio'] ?? '';

          nameController.text = name;
          roleController.text = role;
          bioController.text = bio;
        });
      } else {
        print('Failed to fetch portfolio data. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching portfolio data: $e');
    }
  }

  /// Pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Save the picked image
        profileImage = _image!.path; // Update profile picture with new image path
      });
      final bytes = await _image!.readAsBytes(); // Await the bytes
      String base64Image = base64Encode(bytes); // Convert bytes to base64 string

      // Update profileImage with the base64 string
      setState(() {
        profileImage = base64Image;
      });
    }
    }

  /// --- PREVIEW MODE ---
  Widget _buildPreviewMode(
    
    TextStyle headerStyle,
    TextStyle subHeaderStyle,
    TextStyle bodyStyle,
  ) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue[100],
            backgroundImage: profileImage.isNotEmpty
                ? _buildProfileImage(profileImage)
                : const AssetImage('lib/images/placeholder.png')
                    as ImageProvider,
          ),
          const SizedBox(height: 20),

          // Name
          Text(
            nameController.text,
            style: headerStyle.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Role
          Text(
            roleController.text,
            style: subHeaderStyle.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Bio
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Bio',
              style: headerStyle.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 8),
           Align(
            alignment: Alignment.center,
            child: 
          Text(
            bioController.text,
            style: bodyStyle,
            
           // textAlign: TextAlign.justify,
          ),
           )
        ],
      ),
    );
  }

  /// --- EDIT MODE ---
  Widget _buildEditMode(
    TextStyle bodyStyle,
    TextStyle labelStyle,
    TextStyle hintStyle,
  ) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue[100],
                    backgroundImage: profileImage.isNotEmpty
                        ? _buildProfileImage(profileImage)
                        : const AssetImage('lib/images/placeholder.png')
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _pickImage(),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Name
            TextField(
              controller: nameController,
              style: bodyStyle,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: labelStyle,
                hintText: 'Enter your name',
                hintStyle: hintStyle,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Role
            TextField(
              controller: roleController,
              style: bodyStyle,
              decoration: InputDecoration(
                labelText: 'Role',
                labelStyle: labelStyle,
                hintText: 'e.g. Software Engineer',
                hintStyle: hintStyle,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bio
            TextField(
              controller: bioController,
              style: bodyStyle,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: labelStyle,
                hintText: 'Write a short introduction about yourself...',
                hintStyle: hintStyle,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to determine if it's a URL or file path
  ImageProvider _buildProfileImage(String imagePath) {
      bool isBase64 = profileImage.startsWith('data:image/') || profileImage.startsWith('/9j/');
    final uri = Uri.parse(imagePath);
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      // Network image
      return NetworkImage(imagePath);
    }
    else if(isBase64)
    {
 return MemoryImage(base64Decode(profileImage.split(',').last)) ;// Decode base64 and display
    }
     else {
      // Local file path
      return FileImage(File(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Common text styles
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

    final TextStyle labelStyle = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[700],
      fontWeight: FontWeight.w500,
    );

    return widget.isEditing
        ? _buildEditMode(bodyStyle, labelStyle, hintStyle)
        : _buildPreviewMode(headerStyle, subHeaderStyle, bodyStyle);
  }
}