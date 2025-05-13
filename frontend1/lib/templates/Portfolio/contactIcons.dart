//   import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:frontend1/templates/Portfolio/contactSection.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;


// class ContactIcons extends StatefulWidget {
// final bool isEditing;
// final String token;
//     final Function(Function()) registerSaveCallback;

// const ContactIcons({super.key, required this.isEditing,required this.token,required this.registerSaveCallback});
//   @override
//   ContactIconsState createState() => ContactIconsState();
// }

// class ContactIconsState extends State<ContactIcons> {

//   final TextEditingController linkedInController = TextEditingController();
//   final TextEditingController twitterController = TextEditingController();
//   String linkedIn="";
//   String Github="";
//   String twitter="";

// @override
// void initState()
// {
//   super.initState();
//        widget.registerSaveCallback(saveData);
//        fetchSocialLinksAndGithubProfile();

// }

//   void saveData() {
//     print("data save in contact Icons");
//     _updateSocialLinks();
//   }

//   Future<void> _updateSocialLinks() async {

//     final url =
//         'http://$localhost/api/portfolio/social-links';
//     try {
//       final response = await http.put(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization':'Bearer ${widget.token}'
//         },
//         body: jsonEncode({
//           'linkedIn': linkedInController.text,
//           'twitter': twitterController.text,
//         }),
//       );

//       if (response.statusCode == 200) {
//       print("social links updated");
//       } else {
//         final error = jsonDecode(response.body)['message'];
//         print('Error: $error');
        
//       }
//     } catch (e) {
//       print('Error updating social links.');
      
//     } 
//   }


// Future<void> fetchSocialLinksAndGithubProfile() async {
//   final String apiUrl =
//       'http://$localhost/api/portfolio/social-links';

//   try {
//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization':'Bearer ${widget.token}'
//       },
//     );

//     if (response.statusCode == 200) {
//       // Parse the JSON response
//       final Map<String, dynamic> data = jsonDecode(response.body);

//       print("sociallinks ${data['socialLinks']} githubProfile ${data['githubProfile']} ");
      
//       setState(() {
//         linkedInController.text=data['socialLinks']['linkedin'];
//         twitterController.text=data['socialLinks']['twitter'];
//         Github=data['githubProfile'];
//         twitter=data['socialLinks']['twitter'];
//         linkedIn=data['socialLinks']['linkedin'];
//       });
//       /*
//         'socialLinks': data['socialLinks'] ?? {},
//         'githubProfile': data['githubProfile'] ?? '',
//      */
//     } else {
//       // Handle non-200 status codes
//       final error = jsonDecode(response.body)['message'];
//       throw Exception('Error: $error');
//     }
//   } catch (e) {
//     // Handle any errors during the API call
//     throw Exception('Failed to fetch social links and GitHub profile: $e');
//   }
// }

//   Widget _buildSocialLinks() {

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         _buildSocialIcon(
//           icon: Icons.code,
//           label: 'GitHub',
//           url: 'https://github.com/$Github',
//         ),
//         SizedBox(width: 15),
//         _buildSocialIcon(
//           icon: Icons.link,
//           label: 'LinkedIn',
//           url: 'https://linkedin.com/in/$linkedIn',
//         ),
//         SizedBox(width: 15),
//         _buildSocialIcon(
//           icon: Icons.alternate_email,
//           label: 'Twitter',
//           url: 'https://twitter.com/$twitter',
//         ),
//          SizedBox(width: 15),
//         _buildContactIcon(icon:Icons.contact_mail,label :'contact'),
//       ],
//     );
//   }

//   Widget _buildContactIcon({required IconData icon, required String label}) {
//     return GestureDetector(
//       onTap: () {
//        Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ContactSection()),
//         );
//       },

//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             child: Icon(icon, size: 20),
//           ),
//           SizedBox(height: 5),
//           Text(label, style: TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildSocialIcon({required IconData icon, required String label, required String url}) {
//     return GestureDetector(
//       onTap: () async {
//         if (await canLaunch(url)) {
//           await launch(url);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Could not launch $url')),
//           );
//         }
//       },
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             child: Icon(icon, size: 20),
//           ),
//           SizedBox(height: 5),
//           Text(label, style: TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
//  Widget editMode() {


//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Edit Social Media Usernames",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 20),
//         // LinkedIn Username Field
//         TextField(
//           controller: linkedInController,
//           decoration: InputDecoration(
//             labelText: "LinkedIn Username",
//             hintText: "Enter your LinkedIn username",
//             border: OutlineInputBorder(),
//             prefixIcon: Icon(Icons.link),
//           ),
//         ),
//         SizedBox(height: 20),
//         // Twitter Username Field
//         TextField(
//           controller: twitterController,
//           decoration: InputDecoration(
//             labelText: "Twitter Username",
//             hintText: "Enter your Twitter username",
//             border: OutlineInputBorder(),
//             prefixIcon: Icon(Icons.alternate_email),
//           ),
//         ),
//       ],
//     ),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//   return Padding(
//         padding: const EdgeInsets.all(16.0),
//      child: widget.isEditing? editMode():
//      _buildSocialLinks(),
//   );
// }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/templates/Portfolio/contactSection.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

// **************************************
//           CONTACT ICONS
// **************************************

class ContactIcons extends StatefulWidget {
  final bool isEditing;
  final String token;
  final Function(Function()) registerSaveCallback;

  const ContactIcons({
    super.key,
    required this.isEditing,
    required this.token,
    required this.registerSaveCallback,
  });

  @override
  ContactIconsState createState() => ContactIconsState();
}

class ContactIconsState extends State<ContactIcons> {
  final TextEditingController linkedInController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();

  String linkedIn = "";
  String Github = "";
  String twitter = "";

  @override
  void initState() {
    super.initState();
    widget.registerSaveCallback(saveData);
    fetchSocialLinksAndGithubProfile();
  }

  void saveData() {
    print("Saving data in ContactIcons...");
    _updateSocialLinks();
  }

  Future<void> _updateSocialLinks() async {
    final url = 'http://$localhost/api/portfolio/social-links';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'linkedIn': linkedInController.text,
          'twitter': twitterController.text,
        }),
      );

      if (response.statusCode == 200) {
        print("Social links updated");
      } else {
        final error = jsonDecode(response.body)['message'];
        print('Error: $error');
      }
    } catch (e) {
      print('Error updating social links: $e');
    }
  }

  Future<void> fetchSocialLinksAndGithubProfile() async {
    final String apiUrl = 'http://$localhost/api/portfolio/social-links';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Example response shape:
        // "socialLinks": {"linkedin": "...", "twitter": "..."},
        // "githubProfile": "...",

        setState(() {
          linkedInController.text = data['socialLinks']['linkedin'] ?? '';
          twitterController.text = data['socialLinks']['twitter'] ?? '';
          Github = data['githubProfile'] ?? '';
          twitter = data['socialLinks']['twitter'] ?? '';
          linkedIn = data['socialLinks']['linkedin'] ?? '';
        });
      } else {
        final error = jsonDecode(response.body)['message'];
        throw Exception('Error: $error');
      }
    } catch (e) {
      print('Failed to fetch social links and GitHub profile: $e');
    }
  }

  /// --- Preview Mode ---
  Widget _buildSocialLinks(TextStyle labelStyle, TextStyle smallTextStyle) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // GitHub
          _buildSocialIcon(
            icon: Icons.code,
            label: 'GitHub',
            url: 'https://github.com/$Github',
            smallTextStyle: smallTextStyle,
          ),
          const SizedBox(width: 15),
          // LinkedIn
          _buildSocialIcon(
            icon: Icons.link,
            label: 'LinkedIn',
            url: 'https://linkedin.com/in/$linkedIn',
            smallTextStyle: smallTextStyle,
          ),
          const SizedBox(width: 15),
          // Twitter
          _buildSocialIcon(
            icon: Icons.alternate_email,
            label: 'Twitter',
            url: 'https://twitter.com/$twitter',
            smallTextStyle: smallTextStyle,
          ),
          const SizedBox(width: 15),
          // Contact
          _buildContactIcon(
            icon: Icons.contact_mail,
            label: 'Contact',
            smallTextStyle: smallTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildContactIcon({
    required IconData icon,
    required String label,
    required TextStyle smallTextStyle,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ContactSection()),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue, // For a consistent color theme
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(label, style: smallTextStyle),
        ],
      ),
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required String label,
    required String url,
    required TextStyle smallTextStyle,
  }) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(label, style: smallTextStyle),
        ],
      ),
    );
  }

  /// --- Edit Mode ---
  Widget _buildEditMode(
    TextStyle bodyStyle,
    TextStyle labelStyle,
    TextStyle hintStyle,
  ) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Edit Social Media Usernames",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          // LinkedIn
          TextField(
            controller: linkedInController,
            style: bodyStyle,
            decoration: InputDecoration(
              labelText: "LinkedIn Username",
              labelStyle: labelStyle,
              hintText: "Enter your LinkedIn username",
              hintStyle: hintStyle,
              prefixIcon: const Icon(Icons.link, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Twitter
          TextField(
            controller: twitterController,
            style: bodyStyle,
            decoration: InputDecoration(
              labelText: "Twitter Username",
              labelStyle: labelStyle,
              hintText: "Enter your Twitter username",
              hintStyle: hintStyle,
              prefixIcon: const Icon(Icons.alternate_email, color: Colors.grey),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // Shared text styles
    final TextStyle smallTextStyle = GoogleFonts.montserrat(
      fontSize: 12,
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

    if (widget.isEditing) {
      return _buildEditMode(bodyStyle, labelStyle, hintStyle);
    } else {
      return _buildSocialLinks(labelStyle, smallTextStyle);
    }
  }
}