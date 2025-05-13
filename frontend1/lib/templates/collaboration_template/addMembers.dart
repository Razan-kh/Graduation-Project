// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:frontend1/config.dart';
// import 'package:frontend1/pages/NotificationService.dart';
// import 'package:http/http.dart' as http;
// class AddUsersPage extends StatefulWidget {
//       final String templateId;
//       final String token;
//   AddUsersPage( {required this.templateId,required this.token});
//   @override
//   _AddUsersPageState createState() => _AddUsersPageState();
// }

// class _AddUsersPageState extends State<AddUsersPage> {

//     List<Map<String, dynamic>> users = [];
// Map<String, dynamic>  ?SelectedUser; // List of added users

// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _fetchAllUsers();
//   }


// Future<void> _fetchAllUsers() async {
//     final token = widget.token; // Replace with your actual token
//     const url = 'http://$localhost/Users'; // Replace with the actual API URL

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token', // Send token for authentication
//         },
//       );

//       if (response.statusCode == 200) {
//         // Parse the response and update the state
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           users = data.map((user) => user as Map<String, dynamic>).toList();
//       print(users);
//         });
//       } else {
//         // Handle errors if any (e.g., no users found)
//         print('Failed to fetch users');
//       }
//     } catch (error) {
//       print('Error: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Users to Page'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Search and Add Users',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.teal,
//               ),
//             ),
//             SizedBox(height: 10),
//  Autocomplete<Map<String, dynamic>>(
//   optionsBuilder: (TextEditingValue textEditingValue) {
//     if (textEditingValue.text.isEmpty) {
//       return const Iterable<Map<String, dynamic>>.empty();
//     }
//     return users.where((Map<String, dynamic> user) {
//       return user['email']
//           .toLowerCase()
//           .contains(textEditingValue.text.toLowerCase());
//     });
//   },
//   displayStringForOption: (Map<String, dynamic> user) {
//     // Display the email in the UI for each option
//     return user['email'];
//   },
//   onSelected: (Map<String, dynamic> selectedUser) {
//     // Call the function with the user's IDr
//  setState(() {
//    SelectedUser=selectedUser;
//  });
//     //sendInvitation(selectedUser['_id']);
//   },



//               fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
//                 return TextField(
//                   controller: controller,
//                   focusNode: focusNode,
                  
//                   decoration: InputDecoration(
//                     labelText: 'Search for users',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.search),
//                     suffixIcon:IconButton(onPressed: (){
//                       if(SelectedUser !=null){
//                         sendInvitation(SelectedUser!['_id']);
//                         setState(() {
//                               SelectedUser=null;
//                               controller.text="";
//                         });
                    
//                       }
//                      }, icon: Icon(Icons.send))
                  
//                   ),
//                 );
//               },
//             ),
           
//           ],
//         ),
//       ),
//     );
//   }
//   Future<void> sendInvitation(String recipientId) async {
 
// NotificationService.sendMessage(context,"Invitation","You are invited to a project",recipientId,"invitation", 
//  widget.token,widget.templateId,
//  { "status":"pending"}
// );

// }
// }

// /*
//  sendMessage(BuildContext context,  String title, String body,String recepient,

//   String type,[String projectID='',String sender='',String data=''])
//   */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/NotificationService.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class AddUsersPage extends StatefulWidget {
  final String templateId;
  final String token;

  const AddUsersPage({required this.templateId, required this.token, super.key});

  @override
  _AddUsersPageState createState() => _AddUsersPageState();
}

class _AddUsersPageState extends State<AddUsersPage> {
  List<Map<String, dynamic>> users = [];
  Map<String, dynamic>? SelectedUser;

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  Future<void> _fetchAllUsers() async {
    final token = widget.token;
    final url = Uri.parse('http://$localhost/Users');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          users = data.map((user) => user as Map<String, dynamic>).toList();
        });
      } else {
        print('Failed to fetch users');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> sendInvitation(String recipientId) async {
    NotificationService.sendMessage(
      context,
      "Invitation",
      "You are invited to a project",
      recipientId,
      "invitation",
      widget.token,
      widget.templateId,
      {"status": "pending"},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
          automaticallyImplyLeading: false, 
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add Users',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search and Add Users',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Autocomplete<Map<String, dynamic>>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Map<String, dynamic>>.empty();
                }
                return users.where((Map<String, dynamic> user) {
                  return user['email']
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              displayStringForOption: (Map<String, dynamic> user) {
                return user['email'];
              },
              onSelected: (Map<String, dynamic> selectedUser) {
                setState(() {
                  SelectedUser = selectedUser;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (SelectedUser != null) {
                          sendInvitation(SelectedUser!['_id']);
                          setState(() {
                            SelectedUser = null;
                            controller.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Invitation sent!',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.blue[800],
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.send, color: Colors.blue[800]),
                    ),
                    hintText: 'Search for users',
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
