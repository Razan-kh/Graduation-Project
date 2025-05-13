import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// class ContactSection extends StatefulWidget {
//   const ContactSection({super.key});

//   @override
//   _ContactSectionState createState() => _ContactSectionState();
// }

// class _ContactSectionState extends State<ContactSection> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Connect Me"),
//       ),
//       body:
//      Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Contact Me',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           _buildContactForm(),
//           SizedBox(height: 30),
//        /*   Text(
//             'Connect with Me',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),*/
//           SizedBox(height: 10),
//        //   _buildSocialLinks(),
//         ],
//       ),
//      )
//     );
//   }

//   Widget _buildContactForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextFormField(
//             controller: _nameController,
//             decoration: InputDecoration(
//               labelText: 'Name',
//               border: OutlineInputBorder(),
//               prefixIcon: Icon(Icons.person),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your name';
//               }
//               return null;
//             },
//           ),
//           SizedBox(height: 15),
//           TextFormField(
//             controller: _emailController,
//             decoration: InputDecoration(
//               labelText: 'Email',
//               border: OutlineInputBorder(),
//               prefixIcon: Icon(Icons.email),
//             ),
//             keyboardType: TextInputType.emailAddress,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your email';
//               }
//               if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                 return 'Please enter a valid email';
//               }
//               return null;
//             },
//           ),
//           SizedBox(height: 15),
//           TextFormField(
//             controller: _messageController,
//             decoration: InputDecoration(
//               labelText: 'Message',
//               border: OutlineInputBorder(),
//               prefixIcon: Icon(Icons.message),
//             ),
//             maxLines: 5,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your message';
//               }
//               return null;
//             },
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   // Perform your submit logic here
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Message sent!')),
//                   );
//                   _nameController.clear();
//                   _emailController.clear();
//                   _messageController.clear();
//                 }
//               },
//               icon: Icon(Icons.send),
//               label: Text('Send Message'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSocialLinks() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         _buildSocialIcon(
//           icon: Icons.code,
//           label: 'GitHub',
//           url: 'https://github.com/your_username',
//         ),
//         SizedBox(width: 15),
//         _buildSocialIcon(
//           icon: Icons.link,
//           label: 'LinkedIn',
//           url: 'https://linkedin.com/in/your_username',
//         ),
//         SizedBox(width: 15),
//         _buildSocialIcon(
//           icon: Icons.alternate_email,
//           label: 'Twitter',
//           url: 'https://twitter.com/your_username',
//         ),
//       ],
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
// }


class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  _ContactSectionState createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Common text styles
    final TextStyle headerStyle = GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.bold,
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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          "Connect Me",
          style: headerStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact Me", style: headerStyle),
            const SizedBox(height: 20),
            _buildContactForm(labelStyle, hintStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm(TextStyle labelStyle, TextStyle hintStyle) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Name
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: labelStyle,
              hintText: 'Enter your name',
              hintStyle: hintStyle,
              prefixIcon: const Icon(Icons.person, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),

          // Email
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: labelStyle,
              hintText: 'Enter your email',
              hintStyle: hintStyle,
              prefixIcon: const Icon(Icons.email, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),

          // Message
          TextFormField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Message',
              labelStyle: labelStyle,
              hintText: 'Enter your message',
              hintStyle: hintStyle,
              prefixIcon: const Icon(Icons.message, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Submit
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message sent!')),
                );
                // Clear fields
                _nameController.clear();
                _emailController.clear();
                _messageController.clear();
              }
            },
            icon: const Icon(Icons.send),
            label: Text(
              'Send Message',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}